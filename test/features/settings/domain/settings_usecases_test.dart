import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/settings/domain/usecases/clear_local_cache_usecase.dart';
import 'package:budget_assistant/features/settings/domain/usecases/update_app_settings_usecase.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: настройки (ТЗ 6.3.38.9). Очистка кэша НЕ трогает
/// транзакции, счета, цели, долги, напоминания.
void main() {
  final skip = sqliteSkipReason();

  group('Настройки (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    final now = DateTime.utc(2026, 11, 15, 12);

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      await db.appSettingsDao.getForUser(kUserId);
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> seedCache() async {
      for (var i = 0; i < 2; i++) {
        await db.into(db.forecastCache).insert(ForecastCacheCompanion(
              id: Value('f$i'),
              userId: const Value(kUserId),
              monthYear: const Value('2026-11'),
              forecastedAmount: Value(1000 * (i + 1)),
              updatedAt: Value(now),
            ));
      }
      for (var i = 0; i < 3; i++) {
        await db.into(db.productAnalyticsCache).insert(
              ProductAnalyticsCacheCompanion.insert(
                id: 'a$i',
                userId: kUserId,
                day: '2026-11-0${i + 1}',
                productHash: 'hash$i',
                updatedAt: Value(now),
              ),
            );
      }
    }

    test('пустой кэш — удалено 0 строк', () async {
      final useCase = ClearLocalCacheUseCase(db: db);

      expect(await useCase(), 0);
    });

    test('очистка удаляет строки прогноза и аналитики товаров', () async {
      await seedCache();
      final useCase = ClearLocalCacheUseCase(db: db);

      final deleted = await useCase();

      expect(deleted, 5);
      expect(await db.select(db.forecastCache).get(), isEmpty);
      expect(await db.select(db.productAnalyticsCache).get(), isEmpty);
    });

    test('очистка не трогает транзакции, счета и категории', () async {
      await seed.tx(id: 't1', amountKopecks: 1000, categoryId: 'c1');
      await seedCache();
      final useCase = ClearLocalCacheUseCase(db: db);

      await useCase();

      expect((await db.select(db.transactions).get()).length, 1);
      expect(await db.select(db.accounts).get(), isNotEmpty);
      expect(await db.select(db.categories).get(), isNotEmpty);
    });

    test('повторная очистка идемпотентна', () async {
      await seedCache();
      final useCase = ClearLocalCacheUseCase(db: db);

      await useCase();

      expect(await useCase(), 0);
    });

    test('настройка сохраняется через единый UseCase', () async {
      final useCase = UpdateAppSettingsUseCase(db: db);

      await useCase(
        userId: kUserId,
        changes: const AppSettingsCompanion(
          enableSecrecyMode: Value(true),
          secrecyDaysBefore: Value(5),
        ),
      );

      final s = await db.appSettingsDao.getForUser(kUserId);
      expect(s.enableSecrecyMode, isTrue);
      expect(s.secrecyDaysBefore, 5);
    });

    test('две последовательные правки не теряются', () async {
      final useCase = UpdateAppSettingsUseCase(db: db);

      await useCase(
        userId: kUserId,
        changes: const AppSettingsCompanion(secrecyDaysBefore: Value(3)),
      );
      await useCase(
        userId: kUserId,
        changes: const AppSettingsCompanion(enableSecrecyMode: Value(true)),
      );

      final s = await db.appSettingsDao.getForUser(kUserId);
      expect(s.secrecyDaysBefore, 3);
      expect(s.enableSecrecyMode, isTrue);
    });
  }, skip: skip);
}