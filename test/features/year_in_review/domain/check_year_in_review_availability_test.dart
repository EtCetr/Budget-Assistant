import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/year_in_review/domain/models/year_in_review_data.dart';
import 'package:budget_assistant/features/year_in_review/domain/usecases/check_year_in_review_availability_usecase.dart';
import 'package:budget_assistant/features/year_in_review/domain/usecases/recalculate_yearly_aggregates_usecase.dart';
import '../../../helpers/fake_yearly_aggregates_repository.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

class _MockRecalculate extends Mock
    implements RecalculateYearlyAggregatesUseCase {}

/// Этап 24: авто-показ годового отчёта после 27 декабря (ТЗ 6.3.37.12).
/// Время задаётся параметром now (D24-81) — тест не зависит от календаря.
void main() {
  final skip = sqliteSkipReason();

  group('CheckYearInReviewAvailabilityUseCase (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late FakeYearlyAggregatesRepository repo;
    late _MockRecalculate recalc;
    late CheckYearInReviewAvailabilityUseCase useCase;

    final dec27 = DateTime(2026, 12, 27, 10);

    String json({required int count}) => jsonEncode(
          YearInReviewData(year: 2026, transactionCount: count).toJson(),
        );

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      await db.appSettingsDao.getForUser(kUserId);
      repo = FakeYearlyAggregatesRepository();
      recalc = _MockRecalculate();
      when(() => recalc.call(
            userId: any(named: 'userId'),
            year: any(named: 'year'),
            baseCurrency: any(named: 'baseCurrency'),
            spaceId: any(named: 'spaceId'),
          )).thenAnswer(
        (_) async => const YearInReviewData(year: 2026, transactionCount: 9),
      );
      useCase = CheckYearInReviewAvailabilityUseCase(
        repository: repo,
        recalculate: recalc,
        settingsDao: db.appSettingsDao,
        logger: Logger(level: Level.off),
      );
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> disableAlerts() => db.customStatement(
          'UPDATE app_settings SET enable_year_in_review_alerts = 0 '
          'WHERE user_id = ?',
          [kUserId],
        );

    test('не декабрь — оверлей не показывается', () async {
      expect(
        await useCase(kUserId, now: DateTime(2026, 7, 15)),
        isNull,
      );
      expect(repo.calls, isEmpty);
    });

    test('26 декабря — ещё рано', () async {
      expect(
        await useCase(kUserId, now: DateTime(2026, 12, 26, 23)),
        isNull,
      );
    });

    test('выключенный тумблер годового отчёта блокирует показ', () async {
      await disableAlerts();

      expect(await useCase(kUserId, now: dec27), isNull);
    });

    test('кэша нет, пересчёт дал данные — показываем текущий год', () async {
      final year = await useCase(kUserId, now: dec27);

      expect(year, 2026);
      verify(() => recalc.call(
            userId: kUserId,
            year: 2026,
            baseCurrency: any(named: 'baseCurrency'),
            spaceId: null,
          )).called(1);
    });

    test('кэша нет и операций нет — показывать нечего', () async {
      when(() => recalc.call(
            userId: any(named: 'userId'),
            year: any(named: 'year'),
            baseCurrency: any(named: 'baseCurrency'),
            spaceId: any(named: 'spaceId'),
          )).thenAnswer((_) async => const YearInReviewData(year: 2026));

      expect(await useCase(kUserId, now: dec27), isNull);
    });

    test('пересчёт вернул null — показывать нечего', () async {
      when(() => recalc.call(
            userId: any(named: 'userId'),
            year: any(named: 'year'),
            baseCurrency: any(named: 'baseCurrency'),
            spaceId: any(named: 'spaceId'),
          )).thenAnswer((_) async => null);

      expect(await useCase(kUserId, now: dec27), isNull);
    });

    test('просмотренный отчёт повторно не показывается', () async {
      repo.seed(makeAggregate(
        userId: kUserId,
        dataJson: json(count: 12),
        isViewed: true,
      ));

      expect(await useCase(kUserId, now: dec27), isNull);
    });

    test('непросмотренный отчёт с данными — показываем', () async {
      repo.seed(makeAggregate(userId: kUserId, dataJson: json(count: 12)));

      expect(await useCase(kUserId, now: dec27), 2026);
    });

    test('кэш с нулём операций — показывать нечего', () async {
      repo.seed(makeAggregate(userId: kUserId, dataJson: json(count: 0)));

      expect(await useCase(kUserId, now: dec27), isNull);
    });

    test('ошибка репозитория гасится — null без исключения', () async {
      repo.error = Exception('db down');

      expect(await useCase(kUserId, now: dec27), isNull);
    });
  }, skip: skip);
}