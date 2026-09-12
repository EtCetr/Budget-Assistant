import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';

import '../../../../core/formatting/color_parser.dart';
import '../../../../core/formatting/privacy_formatter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/pending_sync_indicator.dart';
import '../../../../features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../../privacy/domain/models/balance_visibility_mode.dart';
import '../../../auth/presentation/providers/current_user_provider.dart';
import '../../domain/entities/transaction_ui_model.dart';
import 'transaction_long_press_menu.dart';

class TransactionRow extends ConsumerWidget {
  const TransactionRow({super.key, required this.transaction});

  final TransactionUiModel transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final privacyMode = ref.watch(privacyModeProvider);
    final currentUserId = ref.watch(currentUserIdProvider);
    final formatter = PrivacyFormatter();

    final isFamilyMember = transaction.userId != currentUserId;
    final showFamilyAttributes =
        isFamilyMember && privacyMode != BalanceVisibilityMode.hidden;

    final merchant = formatter.text(
      transaction.merchantName,
      privacyMode,
      fallback: transaction.categoryName,
    );

    final subtitle = formatter.text(
      '${transaction.categoryName} • ${DateFormat.Hm().format(transaction.date.toLocal())}',
      privacyMode,
    );

    final hasPendingSync = transaction.syncStatus == SyncStatus.pending;
    final hasSyncError = transaction.syncStatus == SyncStatus.conflict;
    final isHold = transaction.auditStatus == AuditStatus.pending;
    final amountText = formatter.amount(
      kopecks: transaction.type == TransactionType.expense
          ? -transaction.amountKopecks
          : transaction.amountKopecks,
      currencyCode: transaction.currencyCode,
      mode: privacyMode,
      showSign: transaction.type != TransactionType.transfer,
    );    
    final amountColor = switch (transaction.type) {
      TransactionType.expense => AppColors.colorExpense,
      TransactionType.income => AppColors.colorIncome,
      TransactionType.transfer => AppColors.colorTransfer,
    };

    return InkWell(
      onLongPress: () {
        HapticFeedback.mediumImpact();
        showTransactionLongPressMenu(
          context: context,
          ref: ref,
          transaction: transaction,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(12),
          border: hasSyncError
              ? Border.all(color: AppColors.colorExpense, width: 2)
              : null,
        ),
        child: Row(
          children: [
            if (showFamilyAttributes)
              Container(
                width: 4,
                height: 48,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: ColorParser.fromHex(
                    transaction.memberColorHex ?? '#60A5FA',
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            CircleAvatar(
              radius: 20,
              backgroundColor: ColorParser.fromHex(
                transaction.categoryColorHex,
              ),
              child: const Icon(Icons.category, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    merchant,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (showFamilyAttributes && transaction.memberDisplayName != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: ColorParser.fromHex(
                    transaction.memberColorHex ?? '#60A5FA',
                  ),
                  child: Text(
                    _initials(transaction.memberDisplayName!),
                    style: const TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ),
            if (transaction.isSplit &&
                privacyMode == BalanceVisibilityMode.visible)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Text(
                  'Split',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.colorWarning,
                  ),
                ),
              ),
            if (transaction.receiptId != null)
              const Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.receipt_long,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
                
              ),
            if (transaction.receiptId != null)
              const Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.receipt_long,
                  size: 16,
                  color: AppColors.textSecondary,
                ),
              ),
            if (transaction.isLargeExpense)
              const Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.diamond,
                  size: 16,
                  color: Color(0xFF8B5CF6), // фиолетовый
                ),
              ),
            if (isHold)
              const Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.hourglass_bottom,
                  size: 16,
                  color: AppColors.colorWarning,
                ),
              ),
            if (hasPendingSync)
              const Padding(
                padding: EdgeInsets.only(right: 6),
                child: PendingSyncIndicator(),
              ),
            if (hasSyncError)
              const Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.warning_amber,
                  size: 16,
                  color: AppColors.colorExpense,
                ),
              ),
            Text(
              amountText,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: amountColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '';

    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }

    return '${parts[0].substring(0, 1)}${parts[1].substring(0, 1)}'
        .toUpperCase();
  }
}
