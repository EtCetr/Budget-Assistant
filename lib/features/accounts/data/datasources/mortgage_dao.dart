// lib/features/accounts/data/datasources/mortgage_dao.dart
import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../models/mortgage_model.dart';

part 'mortgage_dao.g.dart';

@DriftAccessor(tables: [Mortgages])
class MortgageDao extends DatabaseAccessor<AppDatabase>
    with _$MortgageDaoMixin {
  MortgageDao(super.db);

  Future<MortgageModel?> getMortgageByAccountId(String accountId) async {
    try {
      final query = select(mortgages)
        ..where((t) => t.accountId.equals(accountId));
      final result = await query.getSingleOrNull();

      if (result == null) return null;

      return MortgageModel(
        id: result.id,
        accountId: result.accountId,
        initialLoanAmount: result.initialLoanAmount,
        propertyValue: result.propertyValue,
        interestRateBps: result.interestRateBps,
        remainingTermMonths: result.remainingTermMonths,
        monthlyPayment: result.monthlyPayment,
        nextPaymentDate: result.nextPaymentDate,
        createdAt: result.createdAt,
        updatedAt: result.updatedAt,
        syncStatus: result.syncStatus,
      );
    } catch (e) {
      throw Exception('Failed to get mortgage: $e');
    }
  }

  Future<void> insertMortgage(MortgageModel mortgage) async {
    try {
      await into(mortgages).insert(
        MortgagesCompanion(
          id: Value(mortgage.id),
          accountId: Value(mortgage.accountId),
          initialLoanAmount: Value(mortgage.initialLoanAmount),
          propertyValue: Value(mortgage.propertyValue),
          interestRateBps: Value(mortgage.interestRateBps),
          remainingTermMonths: Value(mortgage.remainingTermMonths),
          monthlyPayment: Value(mortgage.monthlyPayment),
          nextPaymentDate: Value(mortgage.nextPaymentDate),
          createdAt: Value(mortgage.createdAt),
          updatedAt: Value(mortgage.updatedAt),
          syncStatus: Value(mortgage.syncStatus),
        ),
      );
    } catch (e) {
      throw Exception('Failed to insert mortgage: $e');
    }
  }
}
