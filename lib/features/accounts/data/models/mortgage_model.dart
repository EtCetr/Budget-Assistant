// lib/features/accounts/data/models/mortgage_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'mortgage_model.freezed.dart';
part 'mortgage_model.g.dart';

@freezed
abstract class MortgageModel with _$MortgageModel {
  const factory MortgageModel({
    required String id,
    required String accountId,
    required int initialLoanAmount,
    required int propertyValue,
    required int interestRateBps,
    required int remainingTermMonths,
    required int monthlyPayment,
    DateTime? nextPaymentDate,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('pending') String syncStatus,
  }) = _MortgageModel;

  factory MortgageModel.fromJson(Map<String, dynamic> json) =>
      _$MortgageModelFromJson(json);
}
