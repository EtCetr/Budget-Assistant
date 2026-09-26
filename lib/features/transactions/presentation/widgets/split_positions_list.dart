import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import '../providers/split_transaction_form_providers.dart';
import '../split_strings.dart';
import 'split_empty_state.dart';
import 'split_position_card.dart';

/// ReorderableListView позиций разделения + кнопка добавления (6.3.15.5).
class SplitPositionsList extends ConsumerWidget {
  const SplitPositionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(splitTransactionFormProvider);
    if (state.positions.isEmpty) {
      return SplitEmptyState(
        onAdd: () {
          HapticFeedback.mediumImpact();
          ref.read(splitTransactionFormProvider.notifier).addPosition();
        },
      );
    }
    return Column(
      children: [
        Expanded(
          child: ReorderableListView.builder(
            padding: const EdgeInsets.all(AppSpacing.spacing16),
            itemCount: state.positions.length,
            // onReorder остаётся: семантика newIndex (+ корректировка в
            // нотификаторе) проверена; onReorderItem деприкейт-замена
            // меняет контракт индексов.
            // ignore: deprecated_member_use
            onReorder: (oldIndex, newIndex) {
              HapticFeedback.selectionClick();
              ref
                  .read(splitTransactionFormProvider.notifier)
                  .reorder(oldIndex, newIndex);
            },
            itemBuilder: (context, index) => SplitPositionCard(
              key: ValueKey(state.positions[index].id),
              position: state.positions[index],
              index: index,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacing16,
          ),
          child: FilledButton.icon(
            onPressed: () {
              HapticFeedback.mediumImpact();
              ref.read(splitTransactionFormProvider.notifier).addPosition();
            },
            icon: const Icon(Icons.add),
            label: const Text(SplitStrings.addPosition),
          ),
        ),
        const SizedBox(height: AppSpacing.spacing8),
      ],
    );
  }
}