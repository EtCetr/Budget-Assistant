import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';
import 'package:budget_assistant/features/admin/domain/usecases/members_activity_usecases.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';
import 'family_colors.dart';

/// Детализация дня по тапу на столбик (ТЗ 6.3.34.5): список по участникам
/// + кнопка «Открыть в календаре».
Future<void> showActivityDayDetailsSheet(
  BuildContext context, {
  required ChartDayData day,
  required Map<String, MemberInfo> membersById,
  required bool hidden,
  required PrivacyFormatter pf,
  required BalanceVisibilityMode mode,
}) {
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
            Text(
              '📅 ${day.day} · операций: ${day.total}',
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.spacing12),
            if (day.perUser.isEmpty)
              const Text(
                'Нет операций за этот день',
                style: TextStyle(color: AppColors.textSecondary),
              )
            else
              for (final e in day.perUser.entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.spacing8),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundColor:
                            hidden ? Colors.grey : familyColorFor(e.key),
                      ),
                      const SizedBox(width: AppSpacing.spacing8),
                      Expanded(
                        child: Text(
                          pf.formatName(
                            membersById[e.key]?.displayName ?? 'Неизвестный',
                            mode,
                          ),
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Text(
                        '${e.value} оп.',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
            const SizedBox(height: AppSpacing.spacing8),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.push('/calendar/day?date=${day.day}T12:00:00');
                },
                child: const Text('Открыть в календаре'),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}