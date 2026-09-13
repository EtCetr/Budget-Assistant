/// Минимальная ссылка на счёт для колонок матрицы выгоды.
///
/// Доменная модель без JSON: только id, имя для UI и валюта.
class CashbackAccountRef {
  const CashbackAccountRef({
    required this.id,
    required this.name,
    required this.currency,
  });

  final String id;
  final String name;
  final String currency;
}