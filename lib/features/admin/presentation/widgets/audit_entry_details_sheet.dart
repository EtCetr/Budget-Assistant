import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/admin/domain/usecases/audit_log_usecases.dart';

/// BottomSheet полной детализации записи (ТЗ 6.3.35.6): описание, metadata, ID.
Future<void> showAuditEntryDetailsSheet(
  BuildContext context,
  FormattedAuditEntry item,
) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surfaceCard,
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacing16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(item.icon, color: item.iconColor, size: 24),
                const SizedBox(width: AppSpacing.spacing12),
                Expanded(
                  child: Text(
                    item.title,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.spacing12),
            Text(
              item.description,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
            ),
            const SizedBox(height: AppSpacing.spacing8),
            Text(
              '${item.time}${item.additionalInfo == null ? '' : ' · ${item.additionalInfo}'}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: AppSpacing.spacing12),
            Text(
              'metadata: ${item.entry.metadataJson}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
            ),
            Text(
              'ID: ${item.entry.id}',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
            ),
            const SizedBox(height: AppSpacing.spacing16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Закрыть'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}