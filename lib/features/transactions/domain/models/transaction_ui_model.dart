import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:budget_assistant/core/enums/transaction_enums.dart';

part 'transaction_ui_model.freezed.dart';

/// Презентационная модель.
///
/// Используется списком транзакций, календарём, виджетами.
/// Содержит только данные, нужные экрану.
@freezed
abstract class TransactionUiModel with _$TransactionUiModel {
  const factory TransactionUiModel({
    required String id,
    required DateTime date,

    /// Копейки.
    required int amount,

    required TransactionType type,

    String? merchantName,
    String? comment,

    required bool isPendingSync,
    required bool isSyncLocked,
    required bool isHidden,

    String? categoryName,
    String? categoryEmoji,
    String? categoryColorHex,
    String? accountName,
  }) = _TransactionUiModel;
}
