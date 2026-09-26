import '../entities/debt.dart';
import 'decline_name_usecase.dart';

/// Дательный падеж контрагента для карточки долга (6.3.13.6):
/// внешний контрагент — сохранённое counterpartyNameDative [E2E],
/// член семьи — склонение display_name через DeclineNameUseCase.
class FormatDebtTitleUseCase {
  FormatDebtTitleUseCase({required DeclineNameUseCase declineName})
      : _declineName = declineName;

  final DeclineNameUseCase _declineName;

  /// [familyDisplayName] — display_name члена семьи (если долг семейный).
  /// Возвращает пустую строку, если данных нет (UI покажет плейсхолдер).
  String call({required Debt debt, String? familyDisplayName}) {
    if (debt.isExternal) {
      return (debt.counterpartyNameDative ?? '').trim();
    }
    final base = (familyDisplayName ?? '').trim();
    if (base.isEmpty) return '';
    return _declineName(base).dative;
  }
}