import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';

/// BottomSheet выбора формата экспорта (ТЗ 6.3.35.7). Возвращает 'csv' или null.
Future<String?> showAuditExportSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: AppColors.surfaceCard,
    builder: (_) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(AppSpacing.spacing16),
            child: Text(
              '📥 Экспорт журнала аудита',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.description, color: AppColors.colorTransfer),
            title: const Text(
              'CSV (.csv)',
              style: TextStyle(color: AppColors.textPrimary),
            ),
            subtitle: const Text(
              'Таблица всех действий за выбранный период',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            onTap: () => Navigator.of(context).pop('csv'),
          ),
          ListTile(
            leading: const Icon(Icons.close, color: AppColors.textSecondary),
            title: const Text(
              'Отмена',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    ),
  );
}