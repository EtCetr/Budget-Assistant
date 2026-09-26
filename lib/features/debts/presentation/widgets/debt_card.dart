import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/pending_sync_indicator.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/debt.dart';
import '../debts_strings.dart';
import '../providers/debts_providers.dart';
import '../providers/debts_screen_providers.dart';
import 'debt_long_press_menu.dart';
import 'debt_type_badge.dart';

/// Детерминированная палитра цветов семьи (member_colors появится в
/// Этапе 17; пока цвет из hashCode, как предусмотрено ТЗ 6.3.14).
const List<Color> kDebtFamilyPalette = [
  Color(0xFF60A5FA),
  Color(0xFFF472B6),
  Color(0xFF34D399),
  Color(0xFFFBBF24),
  Color(0xFFA78BFA),
  Color(0xFF22D3EE),
  Color(0xFFFB7185),
  Color(0xFF4ADE80),
  Color(0xFFE879F9),
  Color(0xFF38BDF8),
  Color(0xFFFACC15),
  Color(0xFF94A3B8),
];

/// Карточка долга (6.3.13.6): имя в дательном падеже, сумма, бейджи,
/// срок/просрочка, ex-member, индикаторы sync. Privacy-aware.
class DebtCard extends ConsumerWidget {
  const DebtCard({super.key, required this.debt});

  final Debt debt;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final me = ref.watch(currentUserIdProvider);
    final theme = Theme.of(context);
    final now = DateTime.now().toUtc();

    final direction = debt.directionFor(me);
    final isPayable = direction == DebtDirection.payable;
    final counterpartyId = debt.isExternal
        ? null
        : (debt.debtorId == me ? debt.creditorId : debt.debtorId);
    final nameAsync = counterpartyId == null
        ? null
        : ref.watch(debtCounterpartyNameProvider(counterpartyId));

    final rawName = ref.watch(formatDebtTitleUseCaseProvider)(
      debt: debt,
      familyDisplayName: nameAsync?.value,
    );
    final name = rawName.isEmpty
        ? DebtsStrings.nameLoading
        : formatter.formatName(rawName, mode);
    final description = formatter.formatName(debt.description ?? '', mode);
    final amountText = formatter.formatAmount(debt.amount, debt.currency, mode);
    final amountColor = debt.isActive
        ? (isPayable ? AppColors.colorExpense : AppColors.colorIncome)
        : AppColors.textSecondary;
    final overdue = debt.isOverdueAt(now);
    final familyColor = (mode == BalanceVisibilityMode.hidden ||
            counterpartyId == null)
        ? AppColors.surfaceElevated
        : kDebtFamilyPalette[counterpartyId.hashCode.abs() %
            kDebtFamilyPalette.length];

    return GestureDetector(
      onLongPress: () {
        HapticFeedback.mediumImpact();
        showDebtLongPressMenu(context: context, ref: ref, debt: debt);
      },
      child: Opacity(
        opacity: debt.isActive ? 1.0 : 0.5,
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: BorderRadius.circular(AppRadius.radiusLg),
            border: Border.all(color: AppColors.borderDivider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: familyColor,
                    child: Text(
                      debt.isExternal ? '👤' : _initials(rawName),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spacing12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (description.isNotEmpty)
                          Text(
                            description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (debt.originalTransactionId != null)
                    const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(Icons.link, size: 16, color: AppColors.colorTransfer),
                    ),
                  if (debt.splitId != null)
                    const Padding(
                      padding: EdgeInsets.only(right: 6),
                      child: Icon(Icons.content_cut, size: 16, color: AppColors.colorWarning),
                    ),
                  if (debt.syncStatus == SyncStatus.pending)
                    const PendingSyncIndicator(),
                  if (debt.syncStatus == SyncStatus.conflict)
                    const Icon(Icons.warning_amber, size: 16, color: AppColors.colorExpense),
                  const SizedBox(width: AppSpacing.spacing8),
                  Text(
                    amountText,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: amountColor,
                      decoration:
                          debt.isActive ? null : TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spacing8),
              Row(
                children: [
                  DebtTypeBadge(debt: debt),
                  if (debt.isExMemberDebt) ...[
                    const SizedBox(width: AppSpacing.spacing8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.textSecondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        '👤 Ex-member',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                  if (debt.dueDate != null && debt.isActive) ...[
                    const SizedBox(width: AppSpacing.spacing8),
                    Expanded(
                      child: Text(
                        _dueText(debt, now),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: overdue
                              ? AppColors.colorExpense
                              : AppColors.textSecondary,
                          fontWeight: overdue ? FontWeight.w700 : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              if (debt.isExMemberDebt && debt.isActive) ...[
                const SizedBox(height: AppSpacing.spacing4),
                Text(
                  '⚠️ ${DebtsStrings.exMemberWarning}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.colorWarning,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _dueText(Debt debt, DateTime now) {
    final due = debt.dueDate!;
    final days = due.toLocal().difference(now.toLocal()).inDays;
    final dateText = DateFormat('d MMMM', 'ru').format(due.toLocal());
    if (days < 0) {
      final abs = days.abs();
      return '⚠️ ${DebtsStrings.overduePrefix} $abs ${DebtsStrings.daysWord(abs)}';
    }
    return '${DebtsStrings.duePrefix} $dateText · $days '
        '${DebtsStrings.daysWord(days)} ${DebtsStrings.daysLeftSuffix}';
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    return parts.first.substring(0, 1).toUpperCase();
  }
}