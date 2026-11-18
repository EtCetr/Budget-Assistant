import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/features/receipts/domain/dtos/parsed_item_draft.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/validate_receipt_form_usecase.dart';

/// Этап 24: валидация формы чека перед confirm (ТЗ 6.3.23.8).
/// Сумма позиций должна точно сходиться с итогом (копейки, int).
/// Проверяем errorCodes напрямую: isValid — расширение из файла DTO,
/// его пришлось бы импортировать отдельно.
ParsedItemDraft _item({
  String name = 'Молоко',
  int total = 5000,
  double qty = 1,
}) =>
    ParsedItemDraft(
      name: name,
      quantity: qty,
      unitPriceKop: total,
      totalPriceKop: total,
    );

void main() {
  late ValidateReceiptFormUseCase useCase;
  final past = DateTime.utc(2026, 7, 15, 12);

  setUp(() {
    useCase = ValidateReceiptFormUseCase();
  });

  test('валидная форма проходит', () {
    final r = useCase(
      storeName: 'Пятёрочка',
      dateUtc: past,
      totalKop: 10000,
      items: [_item(), _item(name: 'Хлеб')],
    );

    expect(r.errorCodes, isEmpty);
  });

  test('пустой магазин', () {
    final r = useCase(
      storeName: '   ',
      dateUtc: past,
      totalKop: 5000,
      items: [_item()],
    );

    expect(r.errorCodes, contains('store_name_empty'));
  });

  test('дата в будущем отклоняется', () {
    final r = useCase(
      storeName: 'Магазин',
      dateUtc: DateTime.now().toUtc().add(const Duration(hours: 1)),
      totalKop: 5000,
      items: [_item()],
    );

    expect(r.errorCodes, contains('date_future'));
  });

  test('дата в прошлом допустима', () {
    final r = useCase(
      storeName: 'Магазин',
      dateUtc: past,
      totalKop: 5000,
      items: [_item()],
    );

    expect(r.errorCodes, isNot(contains('date_future')));
  });

  test('нулевой итог отклоняется', () {
    final r = useCase(
      storeName: 'Магазин',
      dateUtc: past,
      totalKop: 0,
      items: const [],
    );

    expect(r.errorCodes, contains('total_nonpositive'));
  });

  test('позиция с пустым названием', () {
    final r = useCase(
      storeName: 'Магазин',
      dateUtc: past,
      totalKop: 5000,
      items: [_item(name: '  ')],
    );

    expect(r.errorCodes, contains('item_name_empty'));
  });

  test('позиция с нулевой суммой', () {
    final r = useCase(
      storeName: 'Магазин',
      dateUtc: past,
      totalKop: 5000,
      items: [_item(total: 0)],
    );

    expect(r.errorCodes, contains('item_price_nonpositive'));
  });

  test('сумма позиций не сходится с итогом', () {
    final r = useCase(
      storeName: 'Магазин',
      dateUtc: past,
      totalKop: 9999,
      items: [_item()],
    );

    expect(r.errorCodes, contains('sum_mismatch'));
  });

  test('без позиций расхождение не проверяется', () {
    final r = useCase(
      storeName: 'Магазин',
      dateUtc: past,
      totalKop: 5000,
      items: const [],
    );

    expect(r.errorCodes, isEmpty);
  });

  test('несколько ошибок собираются вместе', () {
    final r = useCase(
      storeName: '',
      dateUtc: past,
      totalKop: 0,
      items: [_item(name: '', total: 0)],
    );

    expect(r.errorCodes, isNotEmpty);
    expect(
      r.errorCodes,
      containsAll(<String>[
        'store_name_empty',
        'total_nonpositive',
        'item_name_empty',
        'item_price_nonpositive',
      ]),
    );
  });
}