import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/year_in_review/domain/models/yearly_aggregate.dart';
import 'package:budget_assistant/features/year_in_review/domain/usecases/get_available_years_usecase.dart';
import 'package:budget_assistant/features/year_in_review/domain/usecases/mark_year_in_review_as_viewed_usecase.dart';
import '../../../helpers/fake_yearly_aggregates_repository.dart';

/// Этап 24: список годов и отметка просмотра (ТЗ 6.3.37.7).
void main() {
  late FakeYearlyAggregatesRepository repo;
  late Logger logger;
  late GetAvailableYearsUseCase availableYears;
  late MarkYearInReviewAsViewedUseCase markViewed;

  setUp(() {
    repo = FakeYearlyAggregatesRepository();
    logger = Logger(level: Level.off);
    availableYears = GetAvailableYearsUseCase(
      repository: repo,
      logger: logger,
    );
    markViewed = MarkYearInReviewAsViewedUseCase(
      repository: repo,
      logger: logger,
    );
  });

  group('GetAvailableYearsUseCase', () {
    test('список годов приходит из репозитория', () async {
      repo.years = const [
        YearInReviewYearInfo(
          year: 2026,
          isCalculated: true,
          isViewed: true,
          transactionCount: 120,
        ),
        YearInReviewYearInfo(year: 2025, transactionCount: 80),
      ];

      final years = await availableYears(userId: 'u1');

      expect(years.map((y) => y.year).toList(), [2026, 2025]);
      expect(years.first.isCalculated, isTrue);
      expect(years.last.isCalculated, isFalse);
      expect(repo.calls, ['availableYears']);
    });

    test('нет данных — пустой список', () async {
      expect(await availableYears(userId: 'u1'), isEmpty);
    });

    test('ошибка репозитория пробрасывается', () async {
      repo.error = Exception('db down');

      await expectLater(
        availableYears(userId: 'u1'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('MarkYearInReviewAsViewedUseCase', () {
    test('личный скоуп передаёт spaceId = null', () async {
      await markViewed(userId: 'u1', year: 2026);

      expect(repo.viewed.single.year, 2026);
      expect(repo.viewed.single.userId, 'u1');
      expect(repo.viewed.single.spaceId, isNull);
    });

    test('семейный скоуп передаётся без изменений', () async {
      await markViewed(userId: 'u1', year: 2025, spaceId: 's1');

      expect(repo.viewed.single.spaceId, 's1');
      expect(repo.viewed.single.year, 2025);
    });

    test('ошибка репозитория пробрасывается', () async {
      repo.error = Exception('db down');

      await expectLater(
        markViewed(userId: 'u1', year: 2026),
        throwsA(isA<Exception>()),
      );
    });
  });
}