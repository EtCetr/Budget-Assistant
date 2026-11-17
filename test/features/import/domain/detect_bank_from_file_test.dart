import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/import/domain/entities/parser_config.dart';
import 'package:budget_assistant/features/import/domain/usecases/detect_bank_from_file_usecase.dart';

/// Этап 24: автоопределение банка по первым строкам файла (ТЗ 6.3.25.13).
/// PDF и XLSX пропускаются (бинарные форматы), CSV читается в UTF-8
/// с фолбэком windows-1251. Порог включения кандидата: confidence > 0.3.
ParserConfig _config({
  required String code,
  required String name,
  List<String> keywords = const [],
  List<String> headers = const [],
  String? patternsJson,
}) =>
    ParserConfig(
      id: 'pc_$code',
      bankName: name,
      bankCode: code,
      supportedFormats: const ['csv'],
      configJson: '{}',
      detectionPatterns: patternsJson ??
          jsonEncode({'keywords': keywords, 'headers': headers}),
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );

void main() {
  late Directory tmp;
  late DetectBankFromFileUseCase useCase;

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('detect_bank_test');
    useCase = DetectBankFromFileUseCase(logger: Logger(level: Level.off));
  });

  tearDown(() async {
    if (await tmp.exists()) await tmp.delete(recursive: true);
  });

  Future<String> write(String name, String content, {List<int>? bytes}) async {
    final file = File('${tmp.path}/$name');
    if (bytes != null) {
      await file.writeAsBytes(bytes, flush: true);
    } else {
      await file.writeAsString(content, flush: true);
    }
    return file.path;
  }

  final tbank = _config(
    code: 'tbank',
    name: 'Т-Банк',
    keywords: ['т-банк'],
    headers: ['дата операции', 'сумма', 'описание'],
  );

  test('отсутствующий файл — пусто', () async {
    final result = await useCase(
      filePath: '${tmp.path}/missing.csv',
      configs: [tbank],
    );

    expect(result, isEmpty);
  });

  test('PDF пропускается даже с ключевыми словами', () async {
    final path = await write('sample.pdf', 'Выписка Т-Банк;Сумма;Описание');

    expect(await useCase(filePath: path, configs: [tbank]), isEmpty);
  });

  test('XLSX пропускается', () async {
    final path = await write('sample.xlsx', 'Выписка Т-Банк;Сумма;Описание');

    expect(await useCase(filePath: path, configs: [tbank]), isEmpty);
  });

  test('CSV с ключами и заголовками — уверенность 1.0', () async {
    final path = await write(
      'sample.csv',
      'Выписка Т-Банк\nДата операции;Сумма;Описание\n',
    );

    final result = await useCase(filePath: path, configs: [tbank]);

    expect(result.length, 1);
    expect(result.single.bankCode, 'tbank');
    expect(result.single.confidence, closeTo(1.0, 0.001));
  });

  test('нет совпадений — пусто', () async {
    final path = await write('sample.csv', 'Совершенно другой банк\n');

    expect(await useCase(filePath: path, configs: [tbank]), isEmpty);
  });

  test('совпадение ниже порога 0.3 отсеивается', () async {
    final path = await write('sample.csv', 'Выписка Т-Банк\n');

    // 1 ключ из 4 паттернов = 0.25 — кандидат не показывается.
    expect(await useCase(filePath: path, configs: [tbank]), isEmpty);
  });

  test('несколько банков сортируются по уверенности', () async {
    final path = await write(
      'sample.csv',
      'Выписка Т-Банк\nДата операции;Сумма;Описание\n',
    );
    final ozon = _config(
      code: 'ozon',
      name: 'Ozon Банк',
      keywords: ['ozon банк', 'озон банк'],
      headers: ['сумма'],
    );

    final result = await useCase(filePath: path, configs: [ozon, tbank]);

    expect(result.first.bankCode, 'tbank');
    expect(result.last.bankCode, 'ozon');
    expect(result.first.confidence, greaterThan(result.last.confidence));
  });

  test('битый JSON паттернов — конфиг пропускается', () async {
    final path = await write('sample.csv', 'Выписка Т-Банк\n');
    final broken = _config(
      code: 'broken',
      name: 'Сломанный',
      patternsJson: '{не json',
    );

    expect(await useCase(filePath: path, configs: [broken]), isEmpty);
  });

  test('windows-1251 читается фолбэком', () async {
    // 'Выписка Т-Банк' в cp1251:
    // В=194 ы=251 п=239 и=232 с=241 к=234 а=224 пробел=32
    // Т=210 -=45 Б=193 а=224 н=237 к=234, перевод строки=10
    final bytes = <int>[
      194, 251, 239, 232, 241, 234, 224, 32,
      210, 45, 193, 224, 237, 234,
      10,
    ];
    final path = await write('sample.csv', '', bytes: bytes);

    // Конфиг только с ключевым словом: 1 из 1 = 1.0.
    // Так тест проверяет декодирование, а не совпадение заголовков.
    final keywordsOnly = _config(
      code: 'tbank',
      name: 'Т-Банк',
      keywords: ['т-банк'],
    );

    final result = await useCase(filePath: path, configs: [keywordsOnly]);

    expect(result, isNotEmpty);
    expect(result.single.bankCode, 'tbank');
    expect(result.single.confidence, closeTo(1.0, 0.001));
  });
}