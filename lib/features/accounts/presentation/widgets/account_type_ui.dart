// lib/features/accounts/presentation/widgets/account_type_ui.dart
import 'package:flutter/material.dart';
import '../../domain/entities/account_types.dart';

/// Презентационная мета (label + иконка) для типов счетов.
class AccountTypeUiMeta {
  final String label;
  final IconData icon;
  const AccountTypeUiMeta(this.label, this.icon);
}

const Map<String, AccountTypeUiMeta> _accountTypeUi = {
  AccountTypes.debit: AccountTypeUiMeta('Debit Cards', Icons.credit_card),
  AccountTypes.credit: AccountTypeUiMeta('Credit Cards', Icons.credit_card),
  AccountTypes.cash: AccountTypeUiMeta('Cash', Icons.payments),
  AccountTypes.savings: AccountTypeUiMeta('Savings', Icons.savings),
  AccountTypes.safe: AccountTypeUiMeta('Safes', Icons.lock),
  AccountTypes.investmentBroker: AccountTypeUiMeta('Investments', Icons.candlestick_chart),
  AccountTypes.mortgage: AccountTypeUiMeta('Mortgages', Icons.home),
};

AccountTypeUiMeta accountTypeMeta(String type) =>
    _accountTypeUi[type] ?? const AccountTypeUiMeta('Other', Icons.account_balance_wallet);