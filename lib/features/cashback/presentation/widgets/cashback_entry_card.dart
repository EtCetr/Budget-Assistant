import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/cashback_category_summary.dart';

/// Карточка категории кэшбэка.
///
/// Все суммы проходят через PrivacyFormatter (ТОМ 6 §6.6):
/// в режимах partial/hidden вместо сумм отображается маскировка.
/// Хардкод маски в виджете запрещён — только через formatter.
class CashbackEntryCard extends ConsumerWidget {
  const CashbackEntryCard({super.key, required this.summary, this.onDelete});

  final CashbackCategorySummary summary;
  final VoidCallback? onDelete;

  String get _lifetimeLabel =>
      summary.lifetimeType == 'weekly' ? 'Недельный' : 'Месячный';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(privacyFormatterProvider);
    final mode = ref.watch(privacyModeProvider);

    String money(int kopecks) =>
        formatter.formatAmount(kopecks, summary.currency, mode);
    final percentLabel = formatter.formatPercentBps(summary.percentBps, mode);

    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(summary.categoryName,
                      style: theme.textTheme.titleMedium),
                ),
                Chip(
                  label: Text(percentLabel.isEmpty
                      ? _lifetimeLabel
                      : '$_lifetimeLabel $percentLabel'),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            _row('Траты (брутто)', money(summary.grossExpenseKopecks)),
            _row('Возвраты (вычитаются)', money(summary.refundKopecks)),
            _row('NET-база', money(summary.netExpenseKopecks)),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Кэшбэк', style: theme.textTheme.titleSmall),
                Text(
                  money(summary.cashbackKopecks),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(value)],
      ),
    );
  }
}