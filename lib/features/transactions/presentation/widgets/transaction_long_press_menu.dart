import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:budget_assistant/core/enums/transaction_enums.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/formatting/privacy_formatter.dart';
import '../../../../features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/lookup_item.dart';
import '../../domain/entities/transaction_ui_model.dart';
import '../labels/transactions_log_labels.dart';
import '../providers/transactions_log_providers.dart';

/// Контекстное меню транзакции (long-press на TransactionRow).
/// Действия-«переключатели»: подарок и сторно обратимы —
/// пункт меню меняется на противоположный в зависимости от состояния записи.
Future<void> showTransactionLongPressMenu({
  required BuildContext context,
  required WidgetRef ref,
  required TransactionUiModel transaction,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final privacyMode = ref.read(privacyModeProvider);
  final formatter = PrivacyFormatter();

  final title = formatter.text(
    transaction.merchantName,
    privacyMode,
    fallback: transaction.categoryName,
  );

  await showModalBottomSheet(
    context: context,
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                style: Theme.of(sheetContext).textTheme.titleMedium,
              ),
            ),

            // 🎁 Подарок / отмена подарка (контекстно)
            if (transaction.isHiddenByCalendar)
              ListTile(
                leading: const Icon(Icons.visibility),
                title: const Text(TransactionsLogLabels.unhideGift),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  HapticFeedback.lightImpact();

                  final result = await ref
                      .read(unhideTransactionAsGiftUseCaseProvider)
                      .call(transaction.id);

                  _invalidateAndNotify(messenger, ref, result);
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.card_giftcard),
                title: const Text(TransactionsLogLabels.hideAsGift),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  HapticFeedback.lightImpact();

                  final result = await ref
                      .read(hideTransactionAsGiftUseCaseProvider)
                      .call(transaction.id);

                  _invalidateAndNotify(messenger, ref, result);
                },
              ),

            // 🚫 Сторно / возврат в учёт (контекстно)
            if (transaction.auditStatus == AuditStatus.ignored)
              ListTile(
                leading: const Icon(Icons.restore_from_trash),
                title: const Text(TransactionsLogLabels.restoreFromIgnored),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  HapticFeedback.lightImpact();

                  final result = await ref
                      .read(restoreTransactionUseCaseProvider)
                      .call(transaction.id);

                  _invalidateAndNotify(messenger, ref, result);
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.block),
                title: const Text(TransactionsLogLabels.ignore),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  HapticFeedback.lightImpact();

                  final result = await ref
                      .read(ignoreTransactionUseCaseProvider)
                      .call(transaction.id);

                  _invalidateAndNotify(messenger, ref, result);
                },
              ),

            // ↩️ Компенсирующая операция (только для расходов)
            if (transaction.type == TransactionType.expense)
              ListTile(
                leading: const Icon(Icons.undo),
                title: const Text(TransactionsLogLabels.refund),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  HapticFeedback.lightImpact();

                  final result = await ref
                      .read(markAsRefundUseCaseProvider)
                      .call(transaction);

                  _invalidateAndNotify(messenger, ref, result);
                },
              ),

            // 🏷️ Изменить категорию
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text(TransactionsLogLabels.changeCategory),
              onTap: () {
                Navigator.of(sheetContext).pop();
                _showCategoryPicker(context, ref, messenger, transaction);
              },
            ),

            // 📸 / 🧾 Чек (контекстно). TODO(Этап 16): роуты /receipts/scan и /receipts/:id
            if (transaction.receiptId == null)
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text(TransactionsLogLabels.attachReceipt),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.receipt_long),
                title: const Text(TransactionsLogLabels.viewReceipt),
                onTap: () {
                  Navigator.of(sheetContext).pop();
                },
              ),

            const SizedBox(height: 16),
          ],
        ),
      );
    },
  );
}

void _invalidateAndNotify(
  ScaffoldMessengerState messenger,
  WidgetRef ref,
  Result<void> result,
) {
  ref.invalidate(transactionsLogProvider);
  ref.invalidate(hasPendingSyncProvider);

  messenger.showSnackBar(
    SnackBar(
      content: Text(
        result.isSuccess
            ? TransactionsLogLabels.actionDone
            : TransactionsLogLabels.actionFailed,
      ),
    ),
  );
}

Future<void> _showCategoryPicker(
  BuildContext context,
  WidgetRef ref,
  ScaffoldMessengerState messenger,
  TransactionUiModel transaction,
) async {
  final lookupAsync = ref.read(transactionCategoryLookupProvider);

  await showModalBottomSheet(
    context: context,
    builder: (sheetContext) {
      return lookupAsync.when(
        loading: () => const SizedBox(
          height: 200,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => const SizedBox(
          height: 200,
          child: Center(child: Icon(Icons.error_outline)),
        ),
        data: (items) {
          return SafeArea(
            child: ListView(
              children: items.map((LookupItem item) {
                return ListTile(
                  title: Text(item.name),
                  onTap: () async {
                    Navigator.of(sheetContext).pop();
                    HapticFeedback.lightImpact();

                    final result = await ref
                        .read(updateTransactionCategoryUseCaseProvider)
                        .call(
                          transactionId: transaction.id,
                          categoryId: item.id,
                        );

                    _invalidateAndNotify(messenger, ref, result);
                  },
                );
              }).toList(),
            ),
          );
        },
      );
    },
  );
}
