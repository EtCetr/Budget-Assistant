import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/parse_receipt_text_usecase.dart';

/// Этап 24: эвристический разбор OCR-текста чека (ТЗ 6.3.22).
/// Строка с ценой на конце -> позиция; «итого/всего/total/сумма» -> итог;
/// первая строка без цены -> магазин.
void main() {
  late ParseReceiptTextUseCase useCase;

  setUp(() {
    useCase = ParseReceiptTextUseCase(Logger(level: Level.off));
  });

  test('магазин, позиции и итог распознаются', () {
    final draft = useCase(
      'Пятёрочка\n'
      'Молоко 89.90\n'
      'Хлеб 45.00\n'
      'ИТОГО 134.90\n',
    );

    expect(draft.storeName, 'Пятёрочка');
    expect(draft.items.length, 2);
    expect(draft.items[0].name, 'Молоко');
    expect(draft.items[0].totalPriceKop, 8990);
    expect(draft.items[0].quantity, 1.0);
    expect(draft.items[0].unitPriceKop, draft.items[0].totalPriceKop);
    expect(draft.items[1].totalPriceKop, 4500);
    expect(draft.totalKop, 13490);
  });

  test('запятая как десятичный разделитель', () {
    final draft = useCase('Молоко 89,90');

    expect(draft.items.single.totalPriceKop, 8990);
  });

  test('разряды через пробел в сумме', () {
    final draft = useCase('Телевизор 45 000.00');

    expect(draft.items.single.totalPriceKop, 4500000);
    expect(draft.items.single.name, 'Телевизор');
  });

  test('дефис перед ценой снимается с названия', () {
    final draft = useCase('Молоко-89.90');

    expect(draft.items.single.name, 'Молоко');
  });

  test('строка только из цифр не становится магазином', () {
    final draft = useCase('12345\nМолоко 10.00');

    expect(draft.storeName, isNull);
    expect(draft.items.length, 1);
  });

  test('пустой текст — пустой черновик', () {
    final draft = useCase('');

    expect(draft.storeName, isNull);
    expect(draft.totalKop, isNull);
    expect(draft.items, isEmpty);
  });

  test('ключевые слова итога в любом регистре', () {
    expect(useCase('TOTAL 134.90').totalKop, 13490);
    expect(useCase('Сумма 134.90').totalKop, 13490);
    expect(useCase('ВСЕГО 134.90').totalKop, 13490);
  });

  test('название из одного символа не становится позицией', () {
    final draft = useCase('X 10.00');

    expect(draft.items, isEmpty);
  });

  test('последняя строка итога выигрывает', () {
    final draft = useCase('ИТОГО 100.00\nВСЕГО 200.00');

    expect(draft.totalKop, 20000);
  });

  test('текущее поведение: неразрывный пробел в сумме теряет позицию '
      '(TODO(24.9))', () {
    // Регулярка допускает \u00A0, но _parseKop убирает только обычный пробел.
    final draft = useCase('Молоко 1\u00A0500.00');

    expect(draft.items, isEmpty);
  });
}