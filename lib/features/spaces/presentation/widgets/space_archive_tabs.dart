// lib/features/spaces/presentation/widgets/space_archive_tabs.dart
// Этап 21 (ТЗ 6.3.52.4): 4 таба архива пространства.
import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';

enum SpaceArchiveTab { accounts, transactions, goals, debts }

class SpaceArchiveTabs extends StatelessWidget {
  const SpaceArchiveTabs({
    super.key,
    required this.current,
    required this.onChanged,
  });

  final SpaceArchiveTab current;
  final ValueChanged<SpaceArchiveTab> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Row(
        children: [
          for (final tab in SpaceArchiveTab.values)
            Expanded(
              child: InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                onTap: () => onChanged(tab),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: tab == current
                        ? AppColors.surfaceElevated
                        : Colors.transparent,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(
                    _label(tab),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          tab == current ? FontWeight.w700 : FontWeight.w400,
                      color: tab == current
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _label(SpaceArchiveTab tab) => switch (tab) {
        SpaceArchiveTab.accounts => '💳 Счета',
        SpaceArchiveTab.transactions => '📋 Транзакции',
        SpaceArchiveTab.goals => '🎯 Цели',
        SpaceArchiveTab.debts => '💰 Долги',
      };
}