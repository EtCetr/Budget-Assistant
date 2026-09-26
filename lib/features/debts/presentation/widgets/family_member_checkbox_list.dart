import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/formatting/money_input_parser.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../debts_strings.dart';
import '../providers/create_debt_providers.dart';
import 'debt_card.dart';

/// Чекбокс-лист членов семьи с предпросмотром доли (6.3.14.4, вариант А).
class FamilyMemberCheckboxList extends ConsumerWidget {
  const FamilyMemberCheckboxList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(createDebtFormProvider);
    final membersAsync = ref.watch(familyMembersProvider);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final theme = Theme.of(context);
    return membersAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.all(AppSpacing.spacing16),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (members) {
        if (members.isEmpty) {
          return Text(
            DebtsStrings.familyEmptyList,
            style: theme.textTheme.bodyMedium
                ?.copyWith(color: AppColors.textSecondary),
          );
        }
        final total = MoneyInputParser.parseKopecks(form.amountText);
        final count = form.selectedMemberIds.isEmpty
            ? 1
            : form.selectedMemberIds.length;
        final perPerson = total == null ? null : total ~/ count;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final member in members)
              CheckboxListTile(
                value: form.selectedMemberIds.contains(member.userId),
                onChanged: form.isEdit
                    ? null
                    : (value) {
                        HapticFeedback.selectionClick();
                        ref
                            .read(createDebtFormProvider.notifier)
                            .toggleMember(member.userId);
                      },
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                secondary: CircleAvatar(
                  backgroundColor: mode == BalanceVisibilityMode.hidden
                      ? AppColors.surfaceElevated
                      : kDebtFamilyPalette[member.userId.hashCode.abs() %
                          kDebtFamilyPalette.length],
                  child: Text(
                    member.displayName.isEmpty
                        ? '?'
                        : member.displayName.substring(0, 1).toUpperCase(),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
                title: Text(
                  formatter.formatName(member.displayName, mode),
                  style: theme.textTheme.titleMedium,
                ),
                subtitle: perPerson == null
                    ? null
                    : Text(
                        '${form.debtType == 'receivable' ? DebtsStrings.memberWillOwe : DebtsStrings.memberWillOweMe} '
                        '${formatter.formatAmount(perPerson, form.currency, mode)}',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: AppColors.textSecondary),
                      ),
              ),
            const SizedBox(height: AppSpacing.spacing4),
            Text(
              DebtsStrings.familyMultiHint,
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: AppColors.textSecondary),
            ),
            if (form.isEdit)
              Text(
                DebtsStrings.editMultiMembersNote,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: AppColors.colorWarning),
              ),
          ],
        );
      },
    );
  }
}