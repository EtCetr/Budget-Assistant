import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/features/year_in_review/domain/models/year_in_review_data.dart';
import 'package:budget_assistant/features/year_in_review/domain/models/yearly_aggregate.dart';

/// Этап 24: DTO годовых итогов (ТЗ 6.3.37).
/// Все суммы — целые копейки в базовой валюте; JSON пишется в
/// yearly_aggregates.data_json (локально открыт, E2E только при sync).
void main() {
  test('пустой YearInReviewData даёт безопасные нули', () {
    const data = YearInReviewData();

    expect(data.year, 0);
    expect(data.isFamily, isFalse);
    expect(data.totalIncome, 0);
    expect(data.totalExpense, 0);
    expect(data.topCategories, isEmpty);
    expect(data.cashbackTop, isEmpty);
    expect(data.transactionCount, 0);
    expect(data.hasStaleRates, isFalse);
  });

  test('JSON round-trip сохраняет все поля и вложенные категории', () {
    const data = YearInReviewData(
      year: 2026,
      isFamily: true,
      baseCurrency: 'RUB',
      totalIncome: 120000000,
      totalExpense: 90000000,
      incomeGrowthPercent: 15,
      mostGenerousMonth: 7,
      mostGenerousDay: '2026-07-15',
      mostGenerousDayAmount: 500000,
      topCategories: [
        YearCategoryStat(
          name: 'Продукты',
          amount: 30000000,
          percent: 33,
          color: '#FF0000',
          emoji: '🛒',
        ),
        YearCategoryStat(name: 'Транспорт', amount: 10000000, percent: 11),
      ],
      hasStaleRates: true,
      netInvested: 5000000,
      totalSaved: 20000000,
      goalsCompleted: 2,
      goalsTotal: 5,
      cashbackTotal: 150000,
      cashbackBestCategory: 'Продукты',
      cashbackTop: [YearCategoryStat(name: 'Продукты', amount: 90000)],
      familyTotalExpense: 90000000,
      familyMyPercent: 60,
      familySecretTotal: 1000000,
      subscriptionsTotal: 300000,
      subscriptionsMostExpensive: 'netflix com',
      savingsRate: 25,
      transactionCount: 321,
      firstBudgetMonth: 1,
    );

    final restored = YearInReviewData.fromJson(data.toJson());

    expect(restored, data);
    expect(restored.topCategories.length, 2);
    expect(restored.topCategories.first.emoji, '🛒');
    expect(restored.cashbackTop.single.amount, 90000);
  });

  test('необязательные поля остаются null после round-trip', () {
    const data = YearInReviewData(year: 2026, transactionCount: 10);

    final restored = YearInReviewData.fromJson(data.toJson());

    expect(restored.incomeGrowthPercent, isNull);
    expect(restored.mostGenerousMonth, isNull);
    expect(restored.mostGenerousDay, isNull);
    expect(restored.cashbackBestCategory, isNull);
    expect(restored.subscriptionsMostExpensive, isNull);
    expect(restored.firstBudgetMonth, isNull);
  });

  test('YearCategoryStat: amount и percent по умолчанию нули', () {
    const stat = YearCategoryStat(name: 'Без категории');

    expect(stat.amount, 0);
    expect(stat.percent, 0);
    expect(stat.color, isNull);
    expect(YearCategoryStat.fromJson(stat.toJson()), stat);
  });

  test('YearInReviewYearInfo: год без кэша не просмотрен', () {
    const info = YearInReviewYearInfo(year: 2025, transactionCount: 42);

    expect(info.isCalculated, isFalse);
    expect(info.isViewed, isFalse);
    expect(info.transactionCount, 42);
  });

  test('YearlyAggregate хранит скоуп: null = личная статистика', () {
    final personal = makePersonal();
    final family = personal.copyWith(spaceId: 's1');

    expect(personal.spaceId, isNull);
    expect(family.spaceId, 's1');
    expect(family.copyWith(isViewed: true).isViewed, isTrue);
  });
}

YearlyAggregate makePersonal() => YearlyAggregate(
      id: 'ya1',
      userId: 'u1',
      spaceId: null,
      year: 2026,
      dataJson: '{}',
      isViewed: false,
      lastCalculatedAt: DateTime.utc(2026, 7, 15),
      syncStatus: 'pending',
    );