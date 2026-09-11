// lib/features/accounts/domain/entities/account.dart
import '../../data/models/account_model.dart';

class Account {
  final String id;
  final String userId;
  final String? spaceId;
  final String bankName;
  final String customName;
  final String? cardNumberMask;
  final String accountType;
  final String currency;
  final int currentBalance;
  final int? creditLimit;
  final DateTime? gracePeriodEnd;
  final int? minPaymentAmount;
  final bool includeInPersonalBalance;
  final bool includeInFamilyBalance;
  final bool isSharedBalance;
  final bool isSharedExpenses;
  final String expenseDetailLevel;
  final bool isSharedIncomes;
  final String incomeDetailLevel;
  final int? sortOrder;
  final bool isArchived;
  final bool isSystem;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;

  Account({
    required this.id,
    required this.userId,
    this.spaceId,
    required this.bankName,
    required this.customName,
    this.cardNumberMask,
    required this.accountType,
    required this.currency,
    required this.currentBalance,
    this.creditLimit,
    this.gracePeriodEnd,
    this.minPaymentAmount,
    this.includeInPersonalBalance = true,
    this.includeInFamilyBalance = false,
    this.isSharedBalance = false,
    this.isSharedExpenses = false,
    this.expenseDetailLevel = 'total_only',
    this.isSharedIncomes = false,
    this.incomeDetailLevel = 'total_only',
    this.sortOrder,
    this.isArchived = false,
    this.isSystem = false,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = 'pending',
  });

  factory Account.fromModel(AccountModel model) {
    return Account(
      id: model.id,
      userId: model.userId,
      spaceId: model.spaceId,
      bankName: model.bankName,
      customName: model.customName,
      cardNumberMask: model.cardNumberMask,
      accountType: model.accountType,
      currency: model.currency,
      currentBalance: model.currentBalance,
      creditLimit: model.creditLimit,
      gracePeriodEnd: model.gracePeriodEnd,
      minPaymentAmount: model.minPaymentAmount,
      includeInPersonalBalance: model.includeInPersonalBalance,
      includeInFamilyBalance: model.includeInFamilyBalance,
      isSharedBalance: model.isSharedBalance,
      isSharedExpenses: model.isSharedExpenses,
      expenseDetailLevel: model.expenseDetailLevel,
      isSharedIncomes: model.isSharedIncomes,
      incomeDetailLevel: model.incomeDetailLevel,
      sortOrder: model.sortOrder,
      isArchived: model.isArchived,
      isSystem: model.isSystem,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      syncStatus: model.syncStatus,
    );
  }

  AccountModel toModel() {
    return AccountModel(
      id: id,
      userId: userId,
      spaceId: spaceId,
      bankName: bankName,
      customName: customName,
      cardNumberMask: cardNumberMask,
      accountType: accountType,
      currency: currency,
      currentBalance: currentBalance,
      creditLimit: creditLimit,
      gracePeriodEnd: gracePeriodEnd,
      minPaymentAmount: minPaymentAmount,
      includeInPersonalBalance: includeInPersonalBalance,
      includeInFamilyBalance: includeInFamilyBalance,
      isSharedBalance: isSharedBalance,
      isSharedExpenses: isSharedExpenses,
      expenseDetailLevel: expenseDetailLevel,
      isSharedIncomes: isSharedIncomes,
      incomeDetailLevel: incomeDetailLevel,
      sortOrder: sortOrder,
      isArchived: isArchived,
      isSystem: isSystem,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
    );
  }

  Account copyWith({
    String? id,
    String? userId,
    String? spaceId,
    String? bankName,
    String? customName,
    String? cardNumberMask,
    String? accountType,
    String? currency,
    int? currentBalance,
    int? creditLimit,
    DateTime? gracePeriodEnd,
    int? minPaymentAmount,
    bool? includeInPersonalBalance,
    bool? includeInFamilyBalance,
    bool? isSharedBalance,
    bool? isSharedExpenses,
    String? expenseDetailLevel,
    bool? isSharedIncomes,
    String? incomeDetailLevel,
    int? sortOrder,
    bool? isArchived,
    bool? isSystem,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
  }) {
    return Account(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      spaceId: spaceId ?? this.spaceId,
      bankName: bankName ?? this.bankName,
      customName: customName ?? this.customName,
      cardNumberMask: cardNumberMask ?? this.cardNumberMask,
      accountType: accountType ?? this.accountType,
      currency: currency ?? this.currency,
      currentBalance: currentBalance ?? this.currentBalance,
      creditLimit: creditLimit ?? this.creditLimit,
      gracePeriodEnd: gracePeriodEnd ?? this.gracePeriodEnd,
      minPaymentAmount: minPaymentAmount ?? this.minPaymentAmount,
      includeInPersonalBalance:
          includeInPersonalBalance ?? this.includeInPersonalBalance,
      includeInFamilyBalance:
          includeInFamilyBalance ?? this.includeInFamilyBalance,
      isSharedBalance: isSharedBalance ?? this.isSharedBalance,
      isSharedExpenses: isSharedExpenses ?? this.isSharedExpenses,
      expenseDetailLevel: expenseDetailLevel ?? this.expenseDetailLevel,
      isSharedIncomes: isSharedIncomes ?? this.isSharedIncomes,
      incomeDetailLevel: incomeDetailLevel ?? this.incomeDetailLevel,
      sortOrder: sortOrder ?? this.sortOrder,
      isArchived: isArchived ?? this.isArchived,
      isSystem: isSystem ?? this.isSystem,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }
}
