import 'package:flutter/material.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';

/// Прогресс-бар лимита.
///
/// Цвет меняется в зависимости от процента использования:
/// - 0-50%: зелёный
/// - 50-80%: жёлтый
/// - 80-100%: оранжевый
/// - >100%: красный
class BudgetProgressIndicator extends StatelessWidget {
  final int percentUsed;
  final BalanceVisibilityMode privacyMode;

  const BudgetProgressIndicator({
    super.key,
    required this.percentUsed,
    required this.privacyMode,
  });

  @override
  Widget build(BuildContext context) {
    if (privacyMode == BalanceVisibilityMode.hidden) {
      return const LinearProgressIndicator(
        value: 0.5,
        backgroundColor: Colors.grey,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      );
    }

    final clampedPercent = percentUsed.clamp(0, 100).toDouble();
    final color = _getColor(percentUsed);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: clampedPercent / 100,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$percentUsed%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getColor(int percent) {
    if (percent > 100) return Colors.red;
    if (percent >= 80) return Colors.orange;
    if (percent >= 50) return Colors.amber;
    return Colors.green;
  }
}
