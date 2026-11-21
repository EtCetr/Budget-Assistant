import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/year_in_review/domain/models/year_in_review_data.dart';
import 'package:budget_assistant/features/year_in_review/domain/usecases/calculate_year_in_review_usecase.dart';
import 'package:budget_assistant/features/year_in_review/domain/usecases/recalculate_yearly_aggregates_usecase.dart';
import '../../../helpers/fake_yearly_aggregates_repository.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

class _MockRecalculate extends Mock
    implements RecalculateYearlyAggregatesUseCase {}

/// Этап 24: чтение годовых итогов (ТЗ 6.3.37.16, D19-19).
/// Кэш отдаётся мгновенно, если он свежий и не пустой; иначе пересчёт.
/// Пересчёт мокается: реальный UseCase открывает файловую БД в изоляте.
void main() {
  final skip = sqliteSkipReason();

  group('CalculateYearInReviewUseCase (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late FakeYearlyAggregatesRepository repo;
    late _MockRecalculate recalc;
    late CalculateYearInReviewUseCase useCase;

    const recalculated = YearInReviewData(
      year: 2026,
      totalExpense: 123456,
      transactionCount: 7,
    );

    String cachedJson({int count = 5, int expense = 999}) => jsonEncode(
          YearInReviewData(
            year: 2026,
            totalExpense: expense,
            transactionCount: count,
          ).toJson(),
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
          )).thenAnswer((_) async => recalculated);
      useCase = CalculateYearInReviewUseCase(
        repository: repo,
        recalculate: recalc,
        settingsDao: db.appSettingsDao,
        logger: Logger(level: Level.off),
      );
    });

    tearDown(() async {
      await db.close();
    });

    Future<YearInReviewData?> run({String? spaceId}) =>
        useCase(userId: kUserId, year: 2026, spaceId: spaceId);

    test('свежий непустой кэш отдаётся без пересчёта', () async {
      repo.seed(makeAggregate(
        userId: kUserId,
        dataJson: cachedJson(),
        lastCalculatedAt: DateTime.utc(2026, 7, 15),
      ));
      repo.lastTxUpdate = DateTime.utc(2026, 7, 10);

      final data = await run();

      expect(data!.transactionCount, 5);
      expect(data.totalExpense, 999);
      verifyNever(() => recalc.call(
            userId: any(named: 'userId'),
            year: any(named: 'year'),
            baseCurrency: any(named: 'baseCurrency'),
            spaceId: any(named: 'spaceId'),
          ));
    });

    test('нет операций после расчёта — кэш тоже свежий', () async {
      repo.seed(makeAggregate(userId: kUserId, dataJson: cachedJson()));
      repo.lastTxUpdate = null;

      expect((await run())!.transactionCount, 5);
    });

    test('кэш старше последней операции — пересчёт (D19-19)', () async {
      repo.seed(makeAggregate(
        userId: kUserId,
        dataJson: cachedJson(),
        lastCalculatedAt: DateTime.utc(2026, 7, 10),
      ));
      repo.lastTxUpdate = DateTime.utc(2026, 7, 20);

      final data = await run();

      expect(data!.totalExpense, 123456);
      verify(() => recalc.call(
            userId: kUserId,
            year: 2026,
            baseCurrency: any(named: 'baseCurrency'),
            spaceId: null,
          )).called(1);
    });

    test('пустой кэш пересчитывается даже если свежий', () async {
      repo.seed(makeAggregate(
        userId: kUserId,
        dataJson: cachedJson(count: 0),
        lastCalculatedAt: DateTime.utc(2026, 7, 15),
      ));
      repo.lastTxUpdate = DateTime.utc(2026, 7, 10);

      expect((await run())!.transactionCount, 7);
    });

    test('кэша нет — пересчёт с базовой валютой из настроек', () async {
      final settings = await db.appSettingsDao.getForUser(kUserId);

      final data = await run();

      expect(data!.transactionCount, 7);
      final captured = verify(() => recalc.call(
            userId: kUserId,
            year: 2026,
            baseCurrency: captureAny(named: 'baseCurrency'),
            spaceId: null,
          )).captured;
      expect(captured.single, settings.baseCurrency);
    });

    test('семейный скоуп уходит и в чтение кэша, и в пересчёт', () async {
      await run(spaceId: kSpaceId);

      expect(repo.reads.single.spaceId, kSpaceId);
      verify(() => recalc.call(
            userId: kUserId,
            year: 2026,
            baseCurrency: any(named: 'baseCurrency'),
            spaceId: kSpaceId,
          )).called(1);
    });

    test('ошибка репозитория пробрасывается', () async {
      repo.error = Exception('db down');

      await expectLater(run(), throwsA(isA<Exception>()));
    });
  }, skip: skip);
}