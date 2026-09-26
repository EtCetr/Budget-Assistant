import '../entities/split_position_draft.dart';

/// Валидация формы разделения транзакции (ТЗ 6.3.15.7):
/// 1) минимум 2 позиции; 2) все суммы > 0; 3) у всех позиций категория;
/// 4) сумма позиций ТОЧНО равна сумме транзакции (копейки).
/// Возвращает текст ошибки или null, если форма валидна.
class ValidateSplitFormUseCase {
  String? call({
    required int transactionAmountKopecks,
    required List<SplitPositionDraft> positions,
  }) {
    if (positions.length < 2) {
      return 'Разделение требует минимум две позиции';
    }
    var total = 0;
    for (final p in positions) {
      if (p.amount <= 0) {
        return 'Сумма каждой позиции должна быть больше нуля';
      }
      final categoryId = p.categoryId;
      if (categoryId == null || categoryId.isEmpty) {
        return 'Выберите категорию для всех позиций';
      }
      total += p.amount;
    }
    if (total != transactionAmountKopecks) {
      return 'Сумма позиций не совпадает с суммой транзакции';
    }
    return null;
  }
}