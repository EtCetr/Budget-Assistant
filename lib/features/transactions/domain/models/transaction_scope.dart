import 'package:freezed_annotation/freezed_annotation.dart';
part 'transaction_scope.freezed.dart';

/// Состав группы копий транзакции (Этап 23.6).
@freezed
abstract class TransactionGroupScopes with _$TransactionGroupScopes {
  const factory TransactionGroupScopes({
    required bool personal,
    required Set<String> spaceIds,
    String? groupId,
  }) = _TransactionGroupScopes;
}