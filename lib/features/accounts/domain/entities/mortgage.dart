// lib/features/accounts/domain/entities/mortgage.dart
import '../../data/models/mortgage_model.dart';

class Mortgage {
  final String id;
  final String accountId;
  final int initialLoanAmount;
  final int propertyValue;
  final int interestRateBps;
  final int remainingTermMonths;
  final int monthlyPayment;
  final DateTime? nextPaymentDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String syncStatus;

  Mortgage({
    required this.id,
    required this.accountId,
    required this.initialLoanAmount,
    required this.propertyValue,
    required this.interestRateBps,
    required this.remainingTermMonths,
    required this.monthlyPayment,
    this.nextPaymentDate,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = 'pending',
  });

  factory Mortgage.fromModel(MortgageModel model) {
    return Mortgage(
      id: model.id,
      accountId: model.accountId,
      initialLoanAmount: model.initialLoanAmount,
      propertyValue: model.propertyValue,
      interestRateBps: model.interestRateBps,
      remainingTermMonths: model.remainingTermMonths,
      monthlyPayment: model.monthlyPayment,
      nextPaymentDate: model.nextPaymentDate,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
      syncStatus: model.syncStatus,
    );
  }

  MortgageModel toModel() {
    return MortgageModel(
      id: id,
      accountId: accountId,
      initialLoanAmount: initialLoanAmount,
      propertyValue: propertyValue,
      interestRateBps: interestRateBps,
      remainingTermMonths: remainingTermMonths,
      monthlyPayment: monthlyPayment,
      nextPaymentDate: nextPaymentDate,
      createdAt: createdAt,
      updatedAt: updatedAt,
      syncStatus: syncStatus,
    );
  }

  Mortgage copyWith({
    String? id,
    String? accountId,
    int? initialLoanAmount,
    int? propertyValue,
    int? interestRateBps,
    int? remainingTermMonths,
    int? monthlyPayment,
    DateTime? nextPaymentDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? syncStatus,
  }) {
    return Mortgage(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      initialLoanAmount: initialLoanAmount ?? this.initialLoanAmount,
      propertyValue: propertyValue ?? this.propertyValue,
      interestRateBps: interestRateBps ?? this.interestRateBps,
      remainingTermMonths: remainingTermMonths ?? this.remainingTermMonths,
      monthlyPayment: monthlyPayment ?? this.monthlyPayment,
      nextPaymentDate: nextPaymentDate ?? this.nextPaymentDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      syncStatus: syncStatus ?? this.syncStatus,
    );
  }

  /// Net Worth contribution = property_value - current_loan_balance
  int calculateNetWorthContribution(int currentLoanBalance) {
    return propertyValue - currentLoanBalance;
  }
}
