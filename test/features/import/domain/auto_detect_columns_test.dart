import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/import/domain/entities/column_mapping.dart';
import 'package:budget_assistant/features/import/domain/usecases/auto_detect_columns_usecase.dart';

/// Этап 24: автоопределение колонок (ТЗ 6.3.25.13).
/// Уверенность >= 0.8 -> автозаполнение в мастере импорта.
void main() {
  late AutoDetectColumnsUseCase useCase;
  const base = ColumnMapping(
    dateColumnIndex: 0,
    amountColumnIndex: 1,
    merchantColumnIndex: 2,
  );

  setUp(() {
    useCase = AutoDetectColumnsUseCase(logger: Logger(level: Level.off));
  });

  List<List<String>> data(int count) => [
        for (var i = 0; i < count; i++)
          ['0${i + 1}.07.2026', '-1 500,00', 'Пятёрочка'],
      ];

  test('пустой файл — нулевая уверенность', () {
    final r = useCase(rawRows: const [], base: base);

    expect(r.confidence, 0);
    expect(r.mapping, base);
  });

  test('строки заголовков банка попадают в skipRows', () {
    final r = useCase(
      rawRows: [
        ['Банк', 'Выписка'],
        ['Период', '2026'],
        ...data(3),
      ],
      base: base,
    );

    expect(r.mapping.skipRows, 2);
    expect(r.confidence, 1.0);
    expect(r.mapping.dateColumnIndex, 0);
    expect(r.mapping.amountColumnIndex, 1);
    expect(r.mapping.merchantColumnIndex, 2);
    expect(r.mapping.dateFormat, 'dd.MM.yyyy');
    expect(r.mapping.expenseIsNegative, isTrue);
  });

  test('колонки в другом порядке определяются по содержимому', () {
    final r = useCase(
      rawRows: [
        for (var i = 0; i < 3; i++) ['Пятёрочка', '0${i + 1}.07.2026', '-100,00'],
      ],
      base: base,
    );

    expect(r.mapping.dateColumnIndex, 1);
    expect(r.mapping.amountColumnIndex, 2);
    expect(r.mapping.merchantColumnIndex, 0);
    expect(r.confidence, 1.0);
  });

  test('нет колонки суммы — нулевая уверенность', () {
    final r = useCase(
      rawRows: [
        ['01.07.2026', 'abc', 'Магазин'],
        ['02.07.2026', 'def', 'Магазин'],
      ],
      base: base,
    );

    expect(r.confidence, 0);
    expect(r.mapping.dateColumnIndex, base.dateColumnIndex);
  });

  test('меньше трёх колонок — нулевая уверенность', () {
    final r = useCase(
      rawRows: [
        ['01.07.2026', '-100,00'],
        ['02.07.2026', '-200,00'],
      ],
      base: base,
    );

    expect(r.confidence, 0);
  });

  test('ISO-дата распознаётся вместе с форматом', () {
    final r = useCase(
      rawRows: [
        for (var i = 0; i < 3; i++) ['2026-07-0${i + 1}', '-100,00', 'Магазин'],
      ],
      base: base,
    );

    expect(r.mapping.dateFormat, 'yyyy-MM-dd');
    expect(r.confidence, 1.0);
  });

  test('только положительные суммы не включают expenseIsNegative', () {
    final r = useCase(
      rawRows: [
        for (var i = 0; i < 3; i++) ['0${i + 1}.07.2026', '100,00', 'Магазин'],
      ],
      base: base.copyWith(expenseIsNegative: false),
    );

    expect(r.mapping.expenseIsNegative, isFalse);
  });

  test('уверенность = минимальная доля распознанных колонок', () {
    final rows = data(3);
    rows.add(['04.07.2026', '-100,00', '']);

    final r = useCase(rawRows: rows, base: base);

    expect(r.confidence, 0.75);
  });

  test('пропуск заголовков ограничен шестью строками', () {
    final r = useCase(
      rawRows: [
        for (var i = 0; i < 6; i++) ['Заголовок', 'банка', 'строка'],
        ['', '', ''],
        ...data(3),
      ],
      base: base,
    );

    expect(r.mapping.skipRows, 6);
    expect(r.confidence, 0.75);
  });
}