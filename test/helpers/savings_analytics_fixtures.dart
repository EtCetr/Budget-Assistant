import 'package:mocktail/mocktail.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account_types.dart';
import 'package:budget_assistant/features/cashback/domain/usecases/convert_currency_usecase.dart';
import 'package:budget_assistant/features/savings_goals/domain/entities/savings_goal.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';

/// Этап 24: фикстуры аналитики целей.
/// Деньги — целые копейки. Даты транзакций задаются явно (локальный пояс),
/// чтобы бакеты по дням были детерминированными.
class MockConvertCurrency extends Mock implements ConvertCurrencyUseCase {}

/// Мок конвертации: одна валюта — без изменений, другая — по курсу [rate].
/// rate == null имитирует отсутствие курса (устаревшие курсы).
MockConvertCurrency buildConvert({double? rate = 90}) {
  registerFallbackValue(DateTime.utc(2026));
  final mock = MockConvertCurrency();
  when(() => mock(
        amountKopecks: any(named: 'amountKopecks'),
        fromCurrency: any(named: 'fromCurrency'),
        toCurrency: any(named: 'toCurrency'),
        dateUtc: any(named: 'dateUtc'),
      )).thenAnswer((inv) async {
    final amount = inv.namedArguments[#amountKopecks] as int;
    final from = inv.namedArguments[#fromCurrency] as String;
    final to = inv.namedArguments[#toCurrency] as String;
    if (from == to) return amount;
    final r = rate;
    if (r == null) return null;
    return (amount * r).round();
  });
  return mock;
}

SavingsGoal analyticsGoal({
  required String id,
  int target = 10000000,
  int current = 0,
  String currency = 'RUB',
  String status = SavingsGoalStatus.active,
  bool isArchived = false,
  DateTime? createdAt,
  String? linkedAccountId,
}) {
  final created = createdAt ?? DateTime.utc(2026, 1, 1);
  return SavingsGoal(
    id: id,
    userId: 'u1',
    name: 'Цель $id',
    targetAmount: target,
    currentAmount: current,
    currency: currency,
    status: status,
    isArchived: isArchived,
    linkedAccountId: linkedAccountId,
    createdAt: created,
    updatedAt: created,
  );
}

Account analyticsAccount({required String id, String currency = 'RUB'}) {
  return Account(
    id: id,
    userId: 'u1',
    bankName: 'Банк',
    customName: 'Счёт $id',
    accountType: AccountTypes.debit,
    currency: currency,
    currentBalance: 0,
    createdAt: DateTime.utc(2026),
    updatedAt: DateTime.utc(2026),
  );
}

Transaction savingsTx({
  required String id,
  required int amount,
  required DateTime date,
  String accountId = 'a1',
  bool isWithdrawal = false,
  AuditStatus auditStatus = AuditStatus.verified,
  String? goalId = 'g1',
}) {
  return Transaction(
    id: id,
    accountId: accountId,
    userId: 'u1',
    date: date,
    amount: amount,
    type: isWithdrawal ? TransactionType.income : TransactionType.expense,
    savingsGoalId: goalId,
    isWithdrawal: isWithdrawal,
    auditStatus: auditStatus,
    createdAt: date,
    updatedAt: date,
  );
}