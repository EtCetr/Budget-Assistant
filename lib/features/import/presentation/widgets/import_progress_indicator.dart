import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';

/// Индикатор прогресса wizard'а: 4 сегмента (ТЗ 6.3.25.4).
class ImportProgressIndicator extends StatelessWidget {
  const ImportProgressIndicator({super.key, required this.step});

  final int step;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(4, (i) {
        final done = i + 1 < step;
        final active = i + 1 == step;
        return Expanded(
          child: Container(
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
            decoration: BoxDecoration(
              color: done || active
                  ? AppColors.colorFAB
                  : AppColors.borderDivider,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}