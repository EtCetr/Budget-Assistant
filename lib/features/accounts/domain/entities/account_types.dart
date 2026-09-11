/// Типы счетов по ТЗ 6.0 (ТОМ 2, разд. 3).
/// Единственный источник правды для бизнес-логики и UI.
/// lib/features/accounts/domain/entities/account_types.dart
abstract class AccountTypes {
  static const debit = 'debit';
  static const credit = 'credit';
  static const cash = 'cash';
  static const savings = 'savings';
  static const safe = 'safe';
  static const investmentBroker = 'investment_broker';
  static const mortgage = 'mortgage';

  static const all = [
    debit,
    credit,
    cash,
    savings,
    safe,
    investmentBroker,
    mortgage,
  ];

  static bool isValid(String type) => all.contains(type);
}