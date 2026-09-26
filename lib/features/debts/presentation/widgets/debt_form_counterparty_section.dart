import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/providers/security_providers.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import '../debts_strings.dart';
import '../providers/create_debt_providers.dart';
import 'debt_form_type_section.dart';
import 'external_counterparty_input.dart';
import 'family_member_checkbox_list.dart';

/// Секция «Контрагент»: член семьи (чекбоксы) / внешний человек (6.3.14.4).
class DebtFormCounterpartySection extends ConsumerWidget {
  const DebtFormCounterpartySection({super.key, required this.externalController});

  final TextEditingController externalController;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(createDebtFormProvider);
    final canUseFamily = ref.watch(currentSpaceIdProvider) != null;
    final isFamily = form.counterpartyType == 'family_member';
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DebtsStrings.formSectionCounterparty,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.spacing12),
        Row(
          children: [
            Expanded(
              child: DebtFormChoiceButton(
                label: DebtsStrings.counterpartyFamily,
                isActive: isFamily,
                enabled: canUseFamily && !form.isEdit,
                onTap: () {
                  HapticFeedback.selectionClick();
                  ref
                      .read(createDebtFormProvider.notifier)
                      .setCounterpartyType('family_member');
                },
              ),
            ),
            const SizedBox(width: AppSpacing.spacing8),
            Expanded(
              child: DebtFormChoiceButton(
                label: DebtsStrings.counterpartyExternal,
                isActive: !isFamily,
                activeColor: AppColors.colorWarning,
                enabled: !form.isEdit,
                onTap: () {
                  HapticFeedback.selectionClick();
                  ref
                      .read(createDebtFormProvider.notifier)
                      .setCounterpartyType('external');
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.spacing4),
        if (!canUseFamily)
          Text(
            DebtsStrings.familyUnavailable,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: AppColors.textSecondary),
          ),
        const SizedBox(height: AppSpacing.spacing12),
        if (isFamily)
          const FamilyMemberCheckboxList()
        else
          ExternalCounterpartyInput(controller: externalController),
      ],
    );
  }
}