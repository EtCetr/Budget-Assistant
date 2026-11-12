import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:budget_assistant/core/enums/transaction_enums.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/formatting/privacy_formatter.dart';
import '../../../../features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/lookup_item.dart';
import '../../domain/entities/transaction_ui_model.dart';
import '../labels/transactions_log_labels.dart';
import '../providers/transactions_log_providers.dart';
import 'transaction_space_sheet.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/providers/transactions_trigger_provider.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';

/// Контекстное меню транзакции (long-press на TransactionRow).
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
        child: ListView(
          shrinkWrap: true,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                title,
                style: Theme.of(sheetContext).textTheme.titleMedium,
              ),
            ),

            // ✏️ Редактировать
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text(TransactionsLogLabels.edit),
              onTap: () {
                Navigator.of(sheetContext).pop();
                HapticFeedback.lightImpact();
                context.push('/transactions/edit/${transaction.id}');
              },
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

            // 💎 Крупная трата / снять пометку (контекстно)
            if (transaction.isLargeExpense)
              ListTile(
                leading: const Icon(Icons.diamond_outlined),
                title: const Text(TransactionsLogLabels.unmarkAsLargeExpense),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  HapticFeedback.lightImpact();

                  final result = await ref
                      .read(toggleLargeExpenseUseCaseProvider)
                      .call(transaction.id);

                  _invalidateAndNotify(messenger, ref, result);
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.diamond),
                title: const Text(TransactionsLogLabels.markAsLargeExpense),
                onTap: () async {
                  Navigator.of(sheetContext).pop();
                  HapticFeedback.lightImpact();

                  final result = await ref
                      .read(toggleLargeExpenseUseCaseProvider)
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

                        // ✂️ Разделить по категориям (только расходы)
            if (transaction.type == TransactionType.expense)
            ListTile(
                leading: const Icon(Icons.content_cut),
                title: const Text(TransactionsLogLabels.splitReceipt),
                onTap: () {
                    Navigator.of(sheetContext).pop();
                    HapticFeedback.lightImpact();
                    context.push('/transactions/split/${transaction.id}');
                },
            ),
            // 🤝 Создать долг из транзакции
            if (transaction.type != TransactionType.transfer)
            ListTile(
                leading: const Icon(Icons.handshake_outlined),
                title: const Text(TransactionsLogLabels.createDebt),
                onTap: () {
                    Navigator.of(sheetContext).pop();
                    HapticFeedback.lightImpact();
                    context.push('/debts/create?transaction_id=${transaction.id}');
                },
            ),
            if (transaction.receiptId == null || transaction.receiptId!.isEmpty)
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text(TransactionsLogLabels.attachReceipt),
                onTap: () {
                  Navigator.of(sheetContext).pop();
context.push('/receipts/scan?transaction_id=${transaction.id}');
                },
              )
            else
              ListTile(
                leading: const Icon(Icons.receipt_long),
                title: const Text(TransactionsLogLabels.viewReceipt),
                onTap: () {
                  Navigator.of(sheetContext).pop();
context.push('/receipts//preview');
                },
              ),

            // 🗑️ Удалить транзакцию (владелец: отдельная кнопка, не в редакторе).
        ListTile(
          leading: const Icon(Icons.workspaces_outlined),
              title: const Text('Пространство'),
              onTap: () {
                Navigator.of(sheetContext).pop();
                HapticFeedback.lightImpact();
                showTransactionSpaceSheet(
                  context: context,
                  ref: ref,
                  transactionId: transaction.id,
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline,
              color: AppColors.colorExpense),
          title: const Text(TransactionsLogLabels.delete),
          onTap: () {
            Navigator.of(sheetContext).pop();
            HapticFeedback.mediumImpact();
            _confirmDelete(context, ref, messenger, transaction);
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

/// Удаление транзакции с подтверждением (пункт long-press меню).
Future<void> _confirmDelete(
  BuildContext context,
  WidgetRef ref,
  ScaffoldMessengerState messenger,
  TransactionUiModel transaction,
) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text(TransactionsLogLabels.deleteTitle),
      content: const Text(TransactionsLogLabels.deleteSubtitle),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text(TransactionsLogLabels.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: const Text(TransactionsLogLabels.delete),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  final userId = ref.read(currentUserIdProvider);
  final result = await ref
      .read(deleteTransactionUseCaseProvider)
      .call(id: transaction.id, userId: userId);
  if (result.isSuccess) {
    ref.read(transactionsTriggerProvider.notifier).bump();
  }
  _invalidateAndNotify(messenger, ref, result);
}