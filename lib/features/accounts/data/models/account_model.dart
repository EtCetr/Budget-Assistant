// lib/features/accounts/data/models/account_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

// ✅ ОБЯЗАТЕЛЬНО обе part директивы
part 'account_model.freezed.dart';
part 'account_model.g.dart';

@freezed
abstract class AccountModel with _$AccountModel {
  const factory AccountModel({
    required String id,
    required String userId,
    String? spaceId,
    required String bankName,
    required String customName,
    String? cardNumberMask,
    required String accountType,
    required String currency,
    required int currentBalance,
    int? creditLimit,
    DateTime? gracePeriodEnd,
    int? minPaymentAmount,
    @Default(true) bool includeInPersonalBalance,
    @Default(false) bool includeInFamilyBalance,
    @Default(false) bool isSharedBalance,
    @Default(false) bool isSharedExpenses,
    @Default('total_only') String expenseDetailLevel,
    @Default(false) bool isSharedIncomes,
    @Default('total_only') String incomeDetailLevel,
    int? sortOrder,
    @Default(false) bool isArchived,
    @Default(false) bool isSystem,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('pending') String syncStatus,
  }) = _AccountModel;

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);
}