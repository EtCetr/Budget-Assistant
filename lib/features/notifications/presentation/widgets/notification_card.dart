import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/database/app_database.dart' as db;
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/models/notification_type.dart';
import '../providers/notifications_providers.dart';

/// Карточка уведомления (ТОМ 5). В hidden суммы маскируются.
class NotificationCard extends ConsumerWidget {
  const NotificationCard({super.key, required this.notification, this.onTap});
  final db.Notification notification;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(privacyModeProvider);
    final hidden = mode == BalanceVisibilityMode.hidden;
    final pf = ref.watch(privacyFormatterProvider);
    final type = NotificationType.fromDb(notification.type);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacing8),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
        border: Border.all(
          color: notification.isRead
              ? AppColors.borderDivider
              : AppColors.colorTransfer,
          width: notification.isRead ? 1 : 2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (!notification.isRead) {
              HapticFeedback.selectionClick();
              ref
                  .read(handleNotificationActionUseCaseProvider)
                  .markAsRead(notification.id);
            }
            onTap?.call();
          },
          borderRadius:
              const BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.spacing12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _color(type).withValues(alpha: 0.15),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(AppRadius.radiusSm)),
                  ),
                  child: Icon(_icon(type), color: _color(type), size: 20),
                ),
                const SizedBox(width: AppSpacing.spacing12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: notification.isRead
                              ? FontWeight.normal
                              : FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _body(hidden, pf, mode),
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            _time(notification.createdAt),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (notification.actionTaken != null) ...[
                            const SizedBox(width: 8),
                            Text(
                              notification.actionTaken == 'confirmed'
                                  ? '✔ подтверждено'
                                  : '✖ отклонено',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.colorTransfer,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _body(bool hidden, dynamic pf, BalanceVisibilityMode mode) {
    if (hidden) {
      return notification.body.replaceAll(
        RegExp(r'\d[\d\s.,]*₽'),
        pf.formatAmount(0, 'RUB', mode),
      );
    }
    return notification.body;
  }

  String _time(DateTime utc) {
    final local = utc.toLocal();
    final diff = DateTime.now().difference(local);
    if (diff.inMinutes < 1) return 'только что';
    if (diff.inMinutes < 60) return '${diff.inMinutes} мин назад';
    if (diff.inHours < 24) return '${diff.inHours} ч назад';
    if (diff.inDays < 7) return '${diff.inDays} дн назад';
    return DateFormat('dd.MM.yy').format(local);
  }

  Color _color(NotificationType t) => switch (t) {
        NotificationType.limitGlobalPercent ||
        NotificationType.limitGlobalAmount ||
        NotificationType.limitIndividual ||
        NotificationType.deficitForecastWarning ||
        NotificationType.savingsRateDrop ||
        NotificationType.debtOverdue =>
          AppColors.colorWarning,
        NotificationType.debtCreated ||
        NotificationType.debtClosed ||
        NotificationType.debtForgiven ||
        NotificationType.adminHeartbeatWarning ||
        NotificationType.memberActivity ||
        NotificationType.syncConflictManual =>
          AppColors.colorTransfer,
        NotificationType.unmatchedReceipt ||
        NotificationType.duplicateReceipt ||
        NotificationType.duplicateDetected ||
        NotificationType.transferDetected ||
        NotificationType.holdConfirmed ||
        NotificationType.bankStatementReminder ||
        NotificationType.recurringDetected ||
        NotificationType.goalMilestone ||
        NotificationType.investmentYieldReceived =>
          AppColors.colorIncome,
        NotificationType.reminderDue ||
        NotificationType.reminderSnoozeWarning ||
        NotificationType.holidaySecrecyStart ||
        NotificationType.giftPurchaseAlert ||
        NotificationType.goalDeadlineApproaching ||
        NotificationType.yearReviewReady =>
          AppColors.colorFAB,
      };

  IconData _icon(NotificationType t) => switch (t) {
        NotificationType.limitGlobalPercent ||
        NotificationType.limitGlobalAmount ||
        NotificationType.limitIndividual =>
          Icons.warning_amber,
        NotificationType.deficitForecastWarning => Icons.trending_down,
        NotificationType.savingsRateDrop => Icons.savings_outlined,
        NotificationType.debtCreated => Icons.handshake_outlined,
        NotificationType.debtClosed => Icons.check_circle_outline,
        NotificationType.debtForgiven => Icons.favorite_outline,
        NotificationType.debtOverdue => Icons.schedule,
        NotificationType.unmatchedReceipt => Icons.receipt_long,
        NotificationType.duplicateReceipt ||
        NotificationType.duplicateDetected =>
          Icons.copy_outlined,
        NotificationType.transferDetected => Icons.swap_horiz,
        NotificationType.holdConfirmed => Icons.pending_outlined,
        NotificationType.bankStatementReminder => Icons.download_outlined,
        NotificationType.reminderDue => Icons.notifications_active,
        NotificationType.reminderSnoozeWarning => Icons.snooze,
        NotificationType.recurringDetected => Icons.repeat,
        NotificationType.holidaySecrecyStart => Icons.visibility_off,
        NotificationType.giftPurchaseAlert => Icons.card_giftcard,
        NotificationType.goalMilestone => Icons.emoji_events,
        NotificationType.goalDeadlineApproaching => Icons.timer_outlined,
        NotificationType.investmentYieldReceived => Icons.trending_up,
        NotificationType.adminHeartbeatWarning => Icons.admin_panel_settings,
        NotificationType.memberActivity => Icons.group_outlined,
        NotificationType.syncConflictManual => Icons.sync_problem,
        NotificationType.yearReviewReady => Icons.auto_awesome,
      };
}