import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/debts/presentation/debts_strings.dart';
import 'package:budget_assistant/features/debts/presentation/providers/debts_providers.dart';

/// Секция «Долги» для ProfileScreen (ТЗ 6.3.13.16 п.18).
///
/// ProfileScreen появится в Этапе 21 — до этого виджет не встроен
/// ни в один экран (точка входа: роут /debts).
class DebtsSection extends ConsumerWidget {
  const DebtsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(debtsStatsProvider);
    final badgeCount = stats.overdueCount;
    return ListTile(
      leading: const Icon(Icons.handshake_outlined, color: AppColors.colorTransfer),
      title: const Text(DebtsStrings.screenTitle),
      subtitle: Text(
        badgeCount > 0
            ? '$badgeCount ${DebtsStrings.statsOverdueSuffix}'
            : '${DebtsStrings.tabPayable} / ${DebtsStrings.tabReceivable}',
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        HapticFeedback.lightImpact();
        context.push('/debts');
      },
    );
  }
}