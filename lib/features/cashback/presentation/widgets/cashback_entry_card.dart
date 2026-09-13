import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/cashback_category_summary.dart';
import '../providers/cashback_providers.dart';

/// Карточка категории кэшбэка.
///
/// Все суммы проходят через PrivacyFormatter (ТОМ 6 §6.6).
/// Чип статуса переключает potential <-> approved тапом.
class CashbackEntryCard extends ConsumerWidget {
  const CashbackEntryCard({super.key, required this.summary, this.onDelete});

  final CashbackCategorySummary summary;
  final VoidCallback? onDelete;

  String get _lifetimeLabel =>
      summary.lifetimeType == 'weekly' ? 'Недельный' : 'Месячный';

  double get _percent => summary.percentBps / 100;

  bool get _approved => summary.status == 'approved';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(privacyFormatterProvider);
    final mode = ref.watch(privacyModeProvider);

    String money(int kopecks) =>
        formatter.formatAmount(kopecks, summary.currency, mode);

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
                Chip(label: Text('$_lifetimeLabel ${_percent.toStringAsFixed(1)}%')),
                const SizedBox(width: 4),
                ActionChip(
                  avatar: Icon(
                    _approved ? Icons.verified : Icons.hourglass_bottom,
                    size: 14,
                    color: _approved ? Colors.green : Colors.orange,
                  ),
                  label: Text(_approved ? 'Подтверждён' : 'Начислен'),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _toggleStatus(context, ref),
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
            _row('Возвраты', '- ${money(summary.refundKopecks)}'),
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

  Future<void> _toggleStatus(BuildContext context, WidgetRef ref) async {
    final next = _approved ? 'potential' : 'approved';
    try {
      final result = await ref.read(updateCashbackEntryStatusUseCaseProvider)(
        entryId: summary.entryId,
        status: next,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.isSuccess
                ? (next == 'approved'
                    ? 'Кэшбэк подтверждён'
                    : 'Возвращено в «Начислен»')
                : 'Не удалось изменить статус',
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось изменить статус')),
      );
    }
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