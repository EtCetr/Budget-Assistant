import 'package:budget_assistant/core/logger.dart';
import '../entities/debt_form_draft.dart';

/// Построение DTO формы долга перед валидацией/сохранением (6.3.14.13).
class BuildDebtDraftUseCase {
  DebtFormDraft call({
    String? debtId,
    required String debtType,
    required String counterpartyType,
    required List<String> selectedMemberIds,
    required String externalName,
    int? amountKopecks,
    required String currency,
    String? categoryId,
    required String description,
    DateTime? dueDate,
    String? originalTransactionId,
    String? splitId,
    required bool autoResolve,
  }) {
    try {
      return DebtFormDraft(
        debtId: debtId,
        debtType: debtType,
        counterpartyType: counterpartyType,
        selectedMemberIds: selectedMemberIds,
        externalNameDative: externalName.trim(),
        amount: amountKopecks,
        currency: currency,
        categoryId: categoryId,
        description: description.trim(),
        dueDate: dueDate,
        originalTransactionId: originalTransactionId,
        splitId: splitId,
        autoResolveOnLink: autoResolve,
        updatedAt: DateTime.now().toUtc(),
      );
    } catch (e, st) {
      AppLogger.e('BuildDebtDraftUseCase failed: $e', e, st);
      rethrow;
    }
  }
}