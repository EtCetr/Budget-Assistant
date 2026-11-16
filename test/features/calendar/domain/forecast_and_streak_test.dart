import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/calendar/data/datasources/calendar_dao.dart';
import 'package:budget_assistant/features/calendar/domain/usecases/get_free_day_streak_usecase.dart';
import 'package:budget_assistant/features/calendar/domain/usecases/recalculate_forecast_cache_usecase.dart';
import '../../../helpers/fake_forecast_cache_repository.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: кэш прогноза (total-строка всегда) и streak «бесплатных дней».
void main() {
  final skip = sqliteSkipReason();

  group('RecalculateForecastCacheUseCase', () {
    late FakeForecastCacheRepository repo;
    late RecalculateForecastCacheUseCase useCase;

    setUp(() {
      repo = FakeForecastCacheRepository();
      useCase = RecalculateForecastCacheUseCase(
        repository: repo,
        logger: Logger(level: Level.off),
      );
    });

    test('расходы агрегируются по категориям + total-строка', () async {
      await useCase(
        userId: 'u1',
        monthKey: '2026-11',
        events: [
          ForecastEventDto(
            dateUtc: DateTime.utc(2026, 11, 5),
            amountKopecks: 1000,
            categoryId: 'c1',
            isExpense: true,
          ),
          ForecastEventDto(
            dateUtc: DateTime.utc(2026, 11, 6),
            amountKopecks: 2000,
            categoryId: 'c1',
            isExpense: true,
          ),
          ForecastEventDto(
            dateUtc: DateTime.utc(2026, 11, 7),
            amountKopecks: 5000,
            categoryId: 'i1',
            isExpense: false,
          ),
        ],
      );

      final entries = repo.stored['2026-11']!;
      final total = entries.firstWhere((e) => e.categoryId == null);
      final c1 = entries.firstWhere((e) => e.categoryId == 'c1');

      expect(entries.length, 2);
      expect(total.forecastedAmount, 3000);
      expect(total.id, 'u1_2026-11_total');
      expect(c1.forecastedAmount, 3000);
      expect(repo.replacedMonths, ['2026-11']);
    });

    test('нет расходов — total-строка с нулём (fix 14.4e)', () async {
      await useCase(
        userId: 'u1',
        monthKey: '2026-12',
        events: [
          ForecastEventDto(
            dateUtc: DateTime.utc(2026, 12, 1),
            amountKopecks: 5000,
            isExpense: false,
          ),
        ],
      );

      final entries = repo.stored['2026-12']!;
      expect(entries.length, 1);
      expect(entries.single.categoryId, isNull);
      expect(entries.single.forecastedAmount, 0);
    });

    test('пересчёт месяца атомарно заменяет старый кэш', () async {
      await useCase(
        userId: 'u1',
        monthKey: '2026-11',
        events: [
          ForecastEventDto(
            dateUtc: DateTime.utc(2026, 11, 5),
            amountKopecks: 1000,
            categoryId: 'c1',
            isExpense: true,
          ),
        ],
      );
      await useCase(userId: 'u1', monthKey: '2026-11', events: const []);

      expect(repo.stored['2026-11']!.length, 1);
      expect(repo.stored['2026-11']!.single.forecastedAmount, 0);
    });
  });

  group('GetFreeDayStreakUseCase (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late GetFreeDayStreakUseCase useCase;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      useCase = GetFreeDayStreakUseCase(
        dao: CalendarDao(db),
        logger: Logger(level: Level.off),
      );
    });

    tearDown(() async {
      await db.close();
    });

    Future<int> streak() => useCase(
          userId: kUserId,
          fromDay: DateTime.now(),
        );

    test('нет трат — streak упирается в потолок 120', () async {
      expect(await streak(), 120);
    });

    test('трата сегодня и 3 дня назад — streak 2', () async {
      await seed.tx(
        id: 't0',
        amountKopecks: 1000,
        categoryId: 'c1',
        date: DateTime.now(),
      );
      await seed.tx(
        id: 't3',
        amountKopecks: 1000,
        categoryId: 'c1',
        date: DateTime.now().subtract(const Duration(days: 3)),
      );

      expect(await streak(), 2);
    });

    test('траты сегодня и вчера — streak 0', () async {
      await seed.tx(
        id: 't0',
        amountKopecks: 1000,
        categoryId: 'c1',
        date: DateTime.now(),
      );
      await seed.tx(
        id: 't1',
        amountKopecks: 1000,
        categoryId: 'c1',
        date: DateTime.now().subtract(const Duration(days: 1)),
      );

      expect(await streak(), 0);
    });
  }, skip: skip);
}