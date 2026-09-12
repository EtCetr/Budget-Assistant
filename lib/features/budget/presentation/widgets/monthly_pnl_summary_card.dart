import 'package:flutter/material.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import '../../domain/entities/monthly_pnl.dart';

class MonthlyPnlSummaryCard extends StatelessWidget {
  final MonthlyPnl? pnl;
  final BalanceVisibilityMode privacyMode;
  final PrivacyFormatter formatter;

  const MonthlyPnlSummaryCard({
    super.key,
    required this.pnl,
    required this.privacyMode,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    if (pnl == null) {
      return const Card(
        margin: EdgeInsets.all(16),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Text('Нет данных за текущий месяц')),
        ),
      );
    }

    final income = formatter.formatAmount(pnl!.totalIncome, 'RUB', privacyMode);
    final expense = formatter.formatAmount(pnl!.totalExpense, 'RUB', privacyMode);
    final savingsRate = privacyMode == BalanceVisibilityMode.hidden
        ? '•••'
        : '${pnl!.savingsRate}%';

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Итоги месяца',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildRow('Доходы', income, Colors.green),
            const SizedBox(height: 8),
            _buildRow('Расходы', expense, Colors.red),
            const Divider(height: 24),
            _buildRow('Норма сбережений', savingsRate, Colors.blue),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 14)),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}