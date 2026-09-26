import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:budget_assistant/core/formatting/money_formatter.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../../domain/entities/debt.dart';
import '../debts_strings.dart';
import '../providers/debts_providers.dart';

/// BottomSheet действий для долга ex-члена семьи (6.3.13.8):
/// 1) погашенный (resolved); 2) списать (forgiven, только кредитор);
/// 3) напомнить (Share Sheet с шаблоном).
Future<void> showExMemberDebtActionsSheet({
  required BuildContext context,
  required Debt debt,
}) async {
  await showModalBottomSheet(
    context: context,
    builder: (sheetContext) => _ExMemberSheet(debt: debt, sheetContext: sheetContext),
  );
}

class _ExMemberSheet extends ConsumerWidget {
  const _ExMemberSheet({required this.debt, required this.sheetContext});

  final Debt debt;
  final BuildContext sheetContext;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final me = ref.watch(currentUserIdProvider);
    final isCreditor = debt.creditorId == me;
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.check_circle_outline),
            title: const Text(DebtsStrings.exMemberMarkResolved),
            onTap: () {
              Navigator.of(sheetContext).pop();
              _resolve(ref, context, debt, 'resolved');
            },
          ),
          if (isCreditor)
            ListTile(
              leading: const Icon(Icons.delete_sweep_outlined),
              title: const Text(DebtsStrings.exMemberWriteOff),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _resolve(ref, context, debt, 'forgiven');
              },
            ),
          ListTile(
            leading: const Icon(Icons.sms_outlined),
            title: const Text(DebtsStrings.exMemberRemind),
            onTap: () {
              Navigator.of(sheetContext).pop();
              HapticFeedback.lightImpact();
              final amount =
                  MoneyFormatter.formatKopecks(debt.amount, debt.currency);
              SharePlus.instance.share(ShareParams(
                text: '${DebtsStrings.remindTemplate}: $amount',
              ));
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Future<void> _resolve(
    WidgetRef ref,
    BuildContext context,
    Debt debt,
    String status,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(resolveDebtUseCaseProvider)(
        debtId: debt.id,
        status: status,
        actorUserId: ref.read(currentUserIdProvider),
      );
      HapticFeedback.mediumImpact();
      messenger.showSnackBar(const SnackBar(content: Text(DebtsStrings.debtResolved)));
    } catch (_) {
      HapticFeedback.vibrate();
      messenger.showSnackBar(const SnackBar(content: Text(DebtsStrings.operationFailed)));
    }
  }
}