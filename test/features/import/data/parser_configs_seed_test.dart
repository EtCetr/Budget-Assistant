import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/import/data/datasources/parser_configs_dao.dart';
import 'package:budget_assistant/features/import/data/seeds/default_parser_configs_seed.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: локальные сиды банков (заменяют Remote Config до Этапа 25).
/// Идемпотентность + обновление конфига с меньшей версией.
///
/// ВАЖНО: сиды применяются в beforeOpen, поэтому таблица parser_configs
/// уже заполнена к моменту теста. Проверка версии делается понижением
/// существующей строки, а не вставкой новой (иначе UNIQUE по id).
void main() {
  final skip = sqliteSkipReason();

  group('DefaultParserConfigsSeed (in-memory)', () {
    late AppDatabase db;
    late ParserConfigsDao dao;

    setUp(() {
      db = openTestDb();
      dao = ParserConfigsDao(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('в базе шесть банков', () async {
      await DefaultParserConfigsSeed.seedIfEmpty(db);

      final all = await dao.getAll();
      expect(all.length, 6);
      expect(
        all.map((c) => c.bankCode).toSet(),
        {'tbank', 'sber', 'alfa', 'yandex', 'vtb', 'ozon'},
      );
    });

    test('повторный запуск не плодит дубли', () async {
      await DefaultParserConfigsSeed.seedIfEmpty(db);
      await DefaultParserConfigsSeed.seedIfEmpty(db);

      expect((await dao.getAll()).length, 6);
    });

    test('конфиг с меньшей версией обновляется до актуальной', () async {
      await DefaultParserConfigsSeed.seedIfEmpty(db);

      // Понижаем версию и стираем конфиг — имитация старого клиента.
      await (db.update(db.parserConfigs)
            ..where((t) => t.id.equals('pc_alfa')))
          .write(const ParserConfigsCompanion(
        version: Value(1),
        configJson: Value('{}'),
      ));

      await DefaultParserConfigsSeed.seedIfEmpty(db);

      final alfa = await dao.getByBankCode('alfa');
      expect(alfa, isNotNull);
      expect(alfa!.version, 2);
      // Версия 2 содержит явный маппинг колонок Альфы.
      expect(alfa.configJson, contains('no_autodetect'));
      expect((await dao.getAll()).length, 6);
    });

    test('актуальная версия не перезаписывается', () async {
      await DefaultParserConfigsSeed.seedIfEmpty(db);
      await (db.update(db.parserConfigs)
            ..where((t) => t.id.equals('pc_tbank')))
          .write(const ParserConfigsCompanion(
        usageCount: Value(42),
      ));

      await DefaultParserConfigsSeed.seedIfEmpty(db);

      final tbank = await dao.getByBankCode('tbank');
      expect(tbank!.usageCount, 42);
    });

    test('популярные банки идут первыми', () async {
      await DefaultParserConfigsSeed.seedIfEmpty(db);

      final all = await dao.getAll();
      expect(all.first.isPopular, isTrue);
      expect(all.last.bankCode, 'ozon');
    });

    test('паттерны детекта — валидный JSON с ключевыми словами', () async {
      await DefaultParserConfigsSeed.seedIfEmpty(db);

      final tbank = await dao.getByBankCode('tbank');
      final patterns =
          jsonDecode(tbank!.detectionPatterns!) as Map<String, dynamic>;

      expect(patterns['keywords'], contains('т-банк'));
      expect(patterns['headers'], isNotEmpty);
    });
  }, skip: skip);
}