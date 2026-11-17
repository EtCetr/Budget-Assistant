import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/import/domain/entities/parsed_row.dart';
import 'package:budget_assistant/features/import/domain/entities/secrecy_candidate.dart';
import 'package:budget_assistant/features/import/domain/usecases/build_secrecy_calendar_usecase.dart';
import 'package:budget_assistant/features/import/domain/usecases/preview_import_data_usecase.dart';

/// Этап 24: предпросмотр файла (буквенные колонки) и календарь секретности.
SecrecyCandidate _candidate({
  required String id,
  required DateTime holiday,
  DateTime? txDate,
}) =>
    SecrecyCandidate(
      id: id,
      transaction: ParsedRow(
        rowIndex: 0,
        date: txDate ?? DateTime(2026, 7, 14),
        amountKopecks: -500000,
        merchantName: 'Золотое яблоко',
      ),
      relatedHolidayId: 'h1',
      relatedHolidayName: 'День рождения',
      relatedHolidayDate: holiday,
      confidence: 0.5,
    );

void main() {
  group('PreviewImportDataUseCase', () {
    late PreviewImportDataUseCase useCase;

    setUp(() {
      useCase = PreviewImportDataUseCase();
    });

    test('пустой файл — пустая матрица', () {
      final r = useCase(const []);

      expect(r.columnLabels, isEmpty);
      expect(r.rows, isEmpty);
    });

    test('буквенные заголовки как в Excel', () {
      final r = useCase([
        ['a', 'b', 'c'],
      ]);

      expect(r.columnLabels, ['A', 'B', 'C']);
    });

    test('лимит строк соблюдается', () {
      final r = useCase(
        [
          for (var i = 0; i < 15; i++) ['x', 'y', 'z'],
        ],
        limit: 10,
      );

      expect(r.rows.length, 10);
    });

    test('27 колонок: последняя AA', () {
      final r = useCase([
        [for (var i = 0; i < 27; i++) 'x'],
      ]);

      expect(r.columnLabels.length, 27);
      expect(r.columnLabels[25], 'Z');
      expect(r.columnLabels[26], 'AA');
    });

    test('ширина матрицы по самой длинной строке', () {
      final r = useCase([
        ['a'],
        ['a', 'b', 'c', 'd'],
      ]);

      expect(r.columnLabels.length, 4);
    });
  });

  group('BuildSecrecyCalendarUseCase', () {
    late BuildSecrecyCalendarUseCase useCase;

    setUp(() {
      useCase = BuildSecrecyCalendarUseCase(logger: Logger(level: Level.off));
    });

    test('месяц без кандидатов — все дни обычные', () {
      final days = useCase(
        year: 2026,
        month: 7,
        candidates: const [],
        secrecyDaysBefore: 3,
      );

      expect(days.length, 31);
      expect(days.every((d) => d.type == SecrecyDayType.none), isTrue);
      expect(days.every((d) => !d.hasCandidates), isTrue);
    });

    test('день праздника помечен и подписан', () {
      final days = useCase(
        year: 2026,
        month: 7,
        candidates: [_candidate(id: 'c1', holiday: DateTime(2026, 7, 15))],
        secrecyDaysBefore: 3,
      );

      final holiday = days.firstWhere((d) => d.date.day == 15);
      expect(holiday.type, SecrecyDayType.holiday);
      expect(holiday.holidayName, 'День рождения');
    });

    test('период секретности строго между границей и праздником', () {
      final days = useCase(
        year: 2026,
        month: 7,
        candidates: [_candidate(id: 'c1', holiday: DateTime(2026, 7, 15))],
        secrecyDaysBefore: 3,
      );

      SecrecyDayType typeOf(int day) =>
          days.firstWhere((d) => d.date.day == day).type;

      expect(typeOf(12), SecrecyDayType.none);
      expect(typeOf(13), SecrecyDayType.secrecyPeriod);
      expect(typeOf(14), SecrecyDayType.secrecyPeriod);
      expect(typeOf(15), SecrecyDayType.holiday);
      expect(typeOf(16), SecrecyDayType.none);
    });

    test('день с покупкой помечается hasCandidates', () {
      final days = useCase(
        year: 2026,
        month: 7,
        candidates: [
          _candidate(
            id: 'c1',
            holiday: DateTime(2026, 7, 15),
            txDate: DateTime(2026, 7, 14),
          ),
        ],
        secrecyDaysBefore: 3,
      );

      expect(days.firstWhere((d) => d.date.day == 14).hasCandidates, isTrue);
      expect(days.firstWhere((d) => d.date.day == 13).hasCandidates, isFalse);
    });

    test('февраль невисокосного года — 28 дней', () {
      final days = useCase(
        year: 2026,
        month: 2,
        candidates: const [],
        secrecyDaysBefore: 3,
      );

      expect(days.length, 28);
    });
  });
}