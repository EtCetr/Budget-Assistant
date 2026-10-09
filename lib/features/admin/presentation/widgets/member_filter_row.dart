import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';

enum MemberFilter { all, active, suspended, admins }

class MemberFilterRow extends StatelessWidget {
  const MemberFilterRow({super.key, required this.selected, required this.onChanged});
  final MemberFilter selected;
  final ValueChanged<MemberFilter> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing8),
      child: Row(children: MemberFilter.values.map((f) {
        final isSelected = f == selected;
        return Padding(
          padding: const EdgeInsets.only(right: AppSpacing.spacing8),
          child: FilterChip(
            label: Text(_label(f)),
            selected: isSelected,
            onSelected: (_) => onChanged(f),
            selectedColor: AppColors.colorFAB.withValues(alpha: 0.2),
            labelStyle: TextStyle(
              color: isSelected ? AppColors.colorFAB : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            side: BorderSide(color: isSelected ? AppColors.colorFAB : AppColors.borderDivider),
          ),
        );
      }).toList()),
    );
  }

  String _label(MemberFilter f) => switch (f) {
        MemberFilter.all => 'Все',
        MemberFilter.active => 'Активные',
        MemberFilter.suspended => 'Приостановлены',
        MemberFilter.admins => 'Админы',
      };
}