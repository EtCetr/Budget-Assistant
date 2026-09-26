import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import '../providers/split_transaction_form_providers.dart';
import '../split_strings.dart';

/// Action bar сохранения разделения (6.3.15.7): активна при валидности.
class SplitActionBar extends ConsumerWidget {
  const SplitActionBar({super.key, required this.onSave, required this.saving});

  final VoidCallback onSave;
  final bool saving;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final validation = ref.watch(splitFormValidationProvider);
    final state = ref.watch(splitTransactionFormProvider);
    final enabled = validation == null && state.positions.length >= 2;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      child: FilledButton(
        onPressed: enabled && !saving
            ? () {
                HapticFeedback.mediumImpact();
                onSave();
              }
            : null,
        child: saving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                validation ?? SplitStrings.actionSave,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
      ),
    );
  }
}