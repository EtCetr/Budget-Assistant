import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/cashback/data/remote/cbr_rate_remote_source.dart';
import 'package:budget_assistant/features/cashback/data/repositories/exchange_rate_repository_impl.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

class _MockCbr extends Mock implements CbrRateRemoteSource {}

/// Этап 24: цепочка приоритетов курса (ТОМ 4 §4.2, Этап 10).
///
/// Важно: UNIQUE(from_currency, to_currency, date) — на пару и дату
/// существует ровно ОДНА строка. Приоритет ручного исключения проверяется
/// сравнением с официальным курсом другой даты в окне 7 дней.
void main() {
  final skip = sqliteSkipReason();

  setUpAll(() {
    registerFallbackValue(DateTime.utc(2026));
  });

  group('ExchangeRateRepositoryImpl (in-memory)', () {
    late AppDatabase db;
    late _MockCbr remote;
    late ExchangeRateRepositoryImpl repo;
    final day = DateTime.utc(2026, 7, 15);

    setUp(() async {
      db = openTestDb();
      remote = _MockCbr();
      when(() => remote.fetchRubRates(any())).thenAnswer((_) async => null);
      repo = ExchangeRateRepositoryImpl(
        db: db,
        logger: Logger(level: Level.off),
        uuid: const Uuid(),
        remote: remote,
      );
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> putRate({
      required String from,
      String to = 'RUB',
      required DateTime date,
      required double rate,
      String source = 'CBR',
    }) async {
      await db.into(db.exchangeRates).insert(ExchangeRatesCompanion.insert(
            id: 'r-$from-$to-${date.millisecondsSinceEpoch}',
            fromCurrency: from,
            toCurrency: to,
            date: date,
            rate: rate,
            source: Value(source),
            createdAt: DateTime.now().toUtc(),
          ));
    }

    Future<double?> rate({
      String from = 'USD',
      String to = 'RUB',
      DateTime? date,
    }) =>
        repo.getRate(
          fromCurrency: from,
          toCurrency: to,
          dateUtc: date ?? day,
        );

    test('одна валюта: курс 1.0 без обращения к БД', () async {
      expect(await rate(from: 'RUB', to: 'RUB'), 1.0);
    });

    test('приоритет 1: ручное исключение на дату важнее официального окна',
        () async {
      await putRate(
        from: 'USD',
        date: day.subtract(const Duration(days: 3)),
        rate: 90,
      );
      await putRate(from: 'USD', date: day, rate: 100, source: 'manual');

      expect(await rate(), 100);
    });

    test('приоритет 2: официальный кросс-курс через RUB', () async {
      await putRate(from: 'USD', date: day, rate: 90);
      await putRate(from: 'EUR', date: day, rate: 100);

      final usdEur = await rate(from: 'USD', to: 'EUR');

      expect(usdEur, isNotNull);
      expect(usdEur!, closeTo(0.9, 1e-9));
    });

    test('окно 7 дней: курс трёхдневной давности подходит', () async {
      await putRate(
        from: 'USD',
        date: day.subtract(const Duration(days: 3)),
        rate: 90,
      );

      expect(await rate(), 90);
    });

    test('приоритет 4: ручное исключение в окне 7 дней', () async {
      await putRate(
        from: 'USD',
        date: day.subtract(const Duration(days: 2)),
        rate: 100,
        source: 'manual',
      );

      expect(await rate(), 100);
    });

    test('приоритет 5: устаревший официальный курс как последний шанс',
        () async {
      await putRate(
        from: 'USD',
        date: day.subtract(const Duration(days: 40)),
        rate: 90,
      );

      expect(await rate(), 90);
    });

    test('курсов нет вообще: null', () async {
      expect(await rate(), isNull);
    });

    test('приоритет 3: ленивая загрузка с ЦБ кэшируется', () async {
      when(() => remote.fetchRubRates(any()))
          .thenAnswer((_) async => {'USD': 90});

      expect(await rate(), 90);
      expect(await rate(), 90);

      verify(() => remote.fetchRubRates(any())).called(1);
      final rows = await db.select(db.exchangeRates).get();
      expect(rows.length, 1);
      expect(rows.single.source, 'CBR');
    });

    test('неудачная дата не запрашивается повторно за сессию', () async {
      expect(await rate(), isNull);
      expect(await rate(), isNull);

      verify(() => remote.fetchRubRates(any())).called(1);
    });

    test('ручной курс перезаписывает запись за ту же дату', () async {
      await repo.upsertRate(
        fromCurrency: 'USD',
        toCurrency: 'RUB',
        dateUtc: day,
        rate: 90,
        source: 'manual',
      );
      await repo.upsertRate(
        fromCurrency: 'USD',
        toCurrency: 'RUB',
        dateUtc: day,
        rate: 95,
        source: 'manual',
      );

      final recent = await repo.getRecent();
      expect(recent.length, 1);
      expect(recent.single.rate, 95);
      expect(await rate(), 95);
    });

    test('удаление курса убирает запись', () async {
      await repo.upsertRate(
        fromCurrency: 'USD',
        toCurrency: 'RUB',
        dateUtc: day,
        rate: 90,
        source: 'manual',
      );
      final recent = await repo.getRecent();

      await repo.deleteRate(recent.single.id);

      expect(await repo.getRecent(), isEmpty);
    });
  }, skip: skip);
}