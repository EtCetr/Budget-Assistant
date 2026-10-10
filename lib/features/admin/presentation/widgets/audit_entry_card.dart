import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/pending_sync_indicator.dart';
import 'package:budget_assistant/features/admin/domain/usecases/audit_log_usecases.dart';

/// Карточка одной записи аудита (ТЗ 6.3.35.6).
class AuditEntryCard extends StatelessWidget {
  const AuditEntryCard({super.key, required this.item, required this.onTap});
  final FormattedAuditEntry item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacing8),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: const BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.spacing12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(item.icon, color: item.iconColor, size: 20),
                const SizedBox(width: AppSpacing.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            item.time,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          ),
                          if (item.additionalInfo != null) ...[
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                '· ${item.additionalInfo}',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (item.entry.syncStatus == 'pending')
                  const Padding(
                    padding: EdgeInsets.only(left: AppSpacing.spacing8),
                    child: PendingSyncIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}