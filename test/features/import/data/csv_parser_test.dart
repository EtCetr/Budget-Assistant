import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/import/data/parsers/csv_parser.dart';
import 'package:budget_assistant/features/import/domain/entities/column_mapping.dart';

/// Этап 24: CSV-парсер банковских выписок (кавычки, кодировки, суммы).
void main() {
  late Directory tmp;
  late CsvParser parser;

  const mapping = ColumnMapping(
    dateColumnIndex: 0,
    amountColumnIndex: 1,
    merchantColumnIndex: 2,
  );

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('csv_parser_test');
    parser = CsvParser(logger: Logger(level: Level.off));
  });

  tearDown(() async {
    if (await tmp.exists()) await tmp.delete(recursive: true);
  });

  Future<String> writeCsv(String content, {List<int>? bytes}) async {
    final file = File('${tmp.path}/sample.csv');
    if (bytes != null) {
      await file.writeAsBytes(bytes, flush: true);
    } else {
      await file.writeAsString(content, flush: true);
    }
    return file.path;
  }

  test('отсутствующий файл — ошибка, строк нет', () async {
    final r = await parser.parse(
      filePath: '${tmp.path}/missing.csv',
      mapping: mapping,
    );

    expect(r.isSuccess, isFalse);
    expect(r.error, isNotNull);
    expect(r.rows, isEmpty);
  });

  test('базовый CSV: пропуск заголовка, знак суммы, дата', () async {
    final path = await writeCsv(
      'Дата;Сумма;Описание\n'
      '01.07.2026;-1 500,00;Пятёрочка\n'
      '02.07.2026;20000,00;Зарплата\n',
    );

    final r = await parser.parse(
      filePath: path,
      mapping: mapping.copyWith(skipRows: 1),
    );

    expect(r.isSuccess, isTrue);
    expect(r.totalRows, 2);
    expect(r.rows.length, 2);
    expect(r.rows[0].amountKopecks, -150000);
    expect(r.rows[0].merchantName, 'Пятёрочка');
    expect(r.rows[1].amountKopecks, 2000000);
    expect(r.periodStart!.isBefore(r.periodEnd!), isTrue);
  });

  test('разделитель внутри кавычек не режет колонку', () async {
    final path = await writeCsv('01.07.2026;-100,00;"Магазин; ООО"\n');

    final r = await parser.parse(filePath: path, mapping: mapping);

    expect(r.rows.single.merchantName, 'Магазин; ООО');
  });

  test('удвоенные кавычки превращаются в одну', () async {
    final path = await writeCsv('01.07.2026;-100,00;"ООО ""Ромашка"""\n');

    final r = await parser.parse(filePath: path, mapping: mapping);

    expect(r.rows.single.merchantName, 'ООО "Ромашка"');
  });

  test('сумма с символом рубля и неразрывным пробелом', () async {
    final path = await writeCsv('01.07.2026;-2\u00A0100,50 ₽;Магазин\n');

    final r = await parser.parse(filePath: path, mapping: mapping);

    expect(r.rows.single.amountKopecks, -210050);
  });

  test('запятая как разделитель разрядов, точка как дробный', () async {
    final path = await writeCsv('01.07.2026;1,234.56;Магазин\n');

    final r = await parser.parse(filePath: path, mapping: mapping);

    expect(r.rows.single.amountKopecks, 123456);
  });

  test('windows-1251 декодируется в кириллицу', () async {
    // 'Магазин' в cp1251: М=204 а=224 г=227 а=224 з=231 и=232 н=237
    final bytes = <int>[
      ...'01.07.2026;-100,00;'.codeUnits,
      204, 224, 227, 224, 231, 232, 237,
      10,
    ];
    final path = await writeCsv('', bytes: bytes);

    final r = await parser.parse(
      filePath: path,
      mapping: mapping.copyWith(encoding: 'windows-1251'),
    );

    expect(r.rows.single.merchantName, 'Магазин');
  });

  test('битая строка пропускается, totalRows считает все строки', () async {
    final path = await writeCsv(
      '01.07.2026;-100,00;Магазин\n'
      'не-дата;-100,00;Магазин\n',
    );

    final r = await parser.parse(filePath: path, mapping: mapping);

    expect(r.totalRows, 2);
    expect(r.rows.length, 1);
  });

  test('файл только из заголовков — ошибка', () async {
    final path = await writeCsv('Дата;Сумма;Описание\n');

    final r = await parser.parse(
      filePath: path,
      mapping: mapping.copyWith(skipRows: 1),
    );

    expect(r.isSuccess, isFalse);
    expect(r.rows, isEmpty);
  });
}