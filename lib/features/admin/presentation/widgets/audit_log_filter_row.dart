import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import '../providers/audit_log_providers.dart';

/// Чипы фильтров действий (ТЗ 6.3.35.5). В hidden все чипы серые.
class AuditLogFilterRow extends StatelessWidget {
  const AuditLogFilterRow({
    super.key,
    required this.selected,
    required this.totalCount,
    required this.onChanged,
    this.hidden = false,
  });
  final AuditLogFilter selected;
  final int totalCount;
  final ValueChanged<AuditLogFilter> onChanged;
  final bool hidden;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing8),
      child: Row(
        children: [
          for (final f in AuditLogFilter.values)
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.spacing8),
              child: FilterChip(
                label: Text(_label(f)),
                selected: f == selected,
                onSelected: (_) {
                  HapticFeedback.selectionClick();
                  onChanged(f);
                },
                selectedColor: _chipColor(f).withValues(alpha: 0.2),
                labelStyle: TextStyle(
                  color: f == selected
                      ? (hidden ? Colors.grey : _chipColor(f))
                      : (hidden ? Colors.grey : AppColors.textSecondary),
                  fontWeight: f == selected ? FontWeight.w600 : FontWeight.normal,
                ),
                side: BorderSide(
                  color: f == selected
                      ? (hidden ? Colors.grey : _chipColor(f))
                      : (hidden ? Colors.grey : AppColors.borderDivider),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _label(AuditLogFilter f) =>
      f == AuditLogFilter.all ? 'Все ($totalCount)' : f.label;

  Color _chipColor(AuditLogFilter f) => switch (f) {
        AuditLogFilter.invitations => AppColors.colorIncome,
        AuditLogFilter.removals => AppColors.colorExpense,
        AuditLogFilter.roles => AppColors.colorTransfer,
        AuditLogFilter.admin => AppColors.colorWarning,
        AuditLogFilter.dissolved => AppColors.colorExpense,
        AuditLogFilter.all => AppColors.textSecondary,
      };
}