import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import '../debts_strings.dart';
import '../providers/create_debt_providers.dart';
import '../providers/debts_providers.dart';

/// Ручной ввод внешнего контрагента + офлайн-склонение (6.3.14.4, Б).
class ExternalCounterpartyInput extends ConsumerWidget {
  const ExternalCounterpartyInput({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(createDebtFormProvider);
    final declined = ref.watch(declineNameUseCaseProvider)(form.externalName);
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          maxLength: 50,
          decoration: const InputDecoration(
            labelText: DebtsStrings.externalLabel,
            hintText: DebtsStrings.externalHint,
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => ref
              .read(createDebtFormProvider.notifier)
              .setExternalName(value),
        ),
        if (form.externalName.trim().isNotEmpty) ...[
          Text(
            '${DebtsStrings.externalSavedAs} «${declined.dative}»',
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: AppColors.colorTransfer),
          ),
          if (!declined.success)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.spacing4),
              child: Text(
                DebtsStrings.externalDeclineFail,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppColors.colorWarning),
              ),
            ),
        ],
      ],
    );
  }
}