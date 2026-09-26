import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:budget_assistant/core/formatting/money_formatter.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account.dart';
import 'package:budget_assistant/features/accounts/presentation/providers/account_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../../domain/entities/debt.dart';
import '../debts_strings.dart';
import '../providers/debts_providers.dart';

/// Long-press меню карточки долга (6.3.13.9): выполнить / редактировать /
/// продлить срок / напомнить / удалить (только создатель).
Future<void> showDebtLongPressMenu({
  required BuildContext context,
  required WidgetRef ref,
  required Debt debt,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final me = ref.read(currentUserIdProvider);
  final isCreator = debt.createdBy == me;
  final now = DateTime.now().toUtc();
  final overdue = debt.isOverdueAt(now);

  await showModalBottomSheet(
    context: context,
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (debt.isActive)
              ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: const Text(DebtsStrings.menuMarkResolved),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _confirmResolve(context, ref, messenger, debt);
                },
              ),
            if (isCreator)
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text(DebtsStrings.menuEdit),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  HapticFeedback.lightImpact();
                  context.push('/debts/create?id=${debt.id}');
                },
              ),
            if (debt.isActive && overdue)
              ListTile(
                leading: const Icon(Icons.event_available),
                title: const Text(DebtsStrings.menuExtendDueDate),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  await _extendDueDate(context, ref, messenger, debt);
                },
              ),
            if (debt.isExMemberDebt && debt.isActive)
              ListTile(
                leading: const Icon(Icons.sms_outlined),
                title: const Text(DebtsStrings.menuRemindViaSms),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  HapticFeedback.lightImpact();
                  _remind(debt);
                },
              ),
            if (isCreator)
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text(DebtsStrings.menuDelete),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                  _confirmDelete(context, ref, messenger, debt);
                },
              ),
            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}

Future<void> _confirmResolve(
  BuildContext context,
  WidgetRef ref,
  ScaffoldMessengerState messenger,
  Debt debt,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text(DebtsStrings.confirmResolveTitle),
      content: const Text(DebtsStrings.confirmResolveText),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text(DebtsStrings.confirmCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text(DebtsStrings.confirmYes),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;
  final accountId = await _pickAccount(context, ref);
  if (accountId == null || !context.mounted) return;
  final me = ref.read(currentUserIdProvider);
  try {
    await ref.read(closeDebtUseCaseProvider)(
      debtId: debt.id,
      actorUserId: me,
      compensationAccountId: accountId,
    );
    HapticFeedback.mediumImpact();
    messenger.showSnackBar(
      const SnackBar(content: Text(DebtsStrings.debtResolved)),
    );
  } catch (_) {
    HapticFeedback.vibrate();
    messenger.showSnackBar(
      const SnackBar(content: Text(DebtsStrings.operationFailed)),
    );
  }
}

/// Выбор счёта для компенсирующих транзакций закрытия долга.
Future<String?> _pickAccount(BuildContext context, WidgetRef ref) async {
  final me = ref.read(currentUserIdProvider);
  final accounts = ref.read(accountsListProvider(me)).value ?? const <Account>[];
  if (accounts.isEmpty) return null;
  if (!context.mounted) return null;
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text(DebtsStrings.pickAccountTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(
              DebtsStrings.pickAccountHint,
              style: Theme.of(dialogContext).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            for (final account in accounts)
              ListTile(
                dense: true,
                title: Text(account.customName.isNotEmpty
                    ? account.customName
                    : account.bankName),
                onTap: () => Navigator.of(dialogContext).pop(account.id),
              ),
          ],
        ),
      ),
    ),
  );
}

Future<void> _extendDueDate(
  BuildContext context,
  WidgetRef ref,
  ScaffoldMessengerState messenger,
  Debt debt,
) async {
  final now = DateTime.now();
  final picked = await showDatePicker(
    context: context,
    initialDate: now.add(const Duration(days: 30)),
    firstDate: now,
    lastDate: DateTime(now.year + 5),
  );
  if (picked == null || !context.mounted) return;
  final me = ref.read(currentUserIdProvider);
  try {
    await ref.read(extendDebtDueDateUseCaseProvider)(
      debtId: debt.id,
      newDueDateUtc: picked.toUtc(),
      actorUserId: me,
    );
    HapticFeedback.mediumImpact();
    messenger.showSnackBar(
      const SnackBar(content: Text(DebtsStrings.dueDateExtended)),
    );
  } catch (_) {
    HapticFeedback.vibrate();
    messenger.showSnackBar(
      const SnackBar(content: Text(DebtsStrings.operationFailed)),
    );
  }
}

Future<void> _confirmDelete(
  BuildContext context,
  WidgetRef ref,
  ScaffoldMessengerState messenger,
  Debt debt,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text(DebtsStrings.confirmDeleteTitle),
      content: const Text(DebtsStrings.confirmDeleteText),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: const Text(DebtsStrings.confirmCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: const Text(DebtsStrings.confirmYes),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;
  final me = ref.read(currentUserIdProvider);
  try {
    await ref.read(deleteDebtUseCaseProvider)(
      debtId: debt.id,
      actorUserId: me,
    );
    HapticFeedback.mediumImpact();
    messenger.showSnackBar(
      const SnackBar(content: Text(DebtsStrings.debtDeleted)),
    );
  } catch (_) {
    HapticFeedback.vibrate();
    messenger.showSnackBar(
      const SnackBar(content: Text(DebtsStrings.operationFailed)),
    );
  }
}

/// Напоминание должнику: системный Share Sheet с шаблоном текста
/// (url_launcher нет в pubspec — отклонение D13-5).
void _remind(Debt debt) {
  final amount = MoneyFormatter.formatKopecks(debt.amount, debt.currency);
  final what = debt.description == null ? '' : ' (${debt.description})';
  SharePlus.instance.share(ShareParams(
    text: '${DebtsStrings.remindTemplate}: $amount$what',
  ));
}