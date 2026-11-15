import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/cashback/domain/usecases/get_cashback_cycle_bounds_usecase.dart';

/// Этап 24: Правило 5 — циклы в локальном поясе, границы в UTC.
/// Неделя обнуляется в ПОНЕДЕЛЬНИК 00:00, месяц — 1-го числа 00:00.
void main() {
  late GetCashbackCycleBoundsUseCase useCase;

  setUp(() {
    useCase = GetCashbackCycleBoundsUseCase(logger: Logger(level: Level.off));
  });

  group('Недельный цикл', () {
    test('среда откатывается к понедельнику 00:00', () {
      final now = DateTime(2026, 7, 15, 14, 30); // среда
      final b = useCase(now: now, lifetimeType: 'weekly');
      final start = b.startUtc.toLocal();

      expect(start.weekday, DateTime.monday);
      expect(start.day, 13);
      expect(start.hour, 0);
      expect(start.minute, 0);
    });

    test('понедельник остаётся собой', () {
      final b = useCase(
        now: DateTime(2026, 7, 13, 10),
        lifetimeType: 'weekly',
      );

      expect(b.startUtc.toLocal().day, 13);
    });

    test('воскресенье относится к прошлой неделе', () {
      final b = useCase(
        now: DateTime(2026, 7, 19, 23, 59),
        lifetimeType: 'weekly',
      );

      expect(b.startUtc.toLocal().day, 13);
    });

    test('переход через границу месяца', () {
      final b = useCase(
        now: DateTime(2026, 3, 4, 9), // среда
        lifetimeType: 'weekly',
      );
      final start = b.startUtc.toLocal();

      expect(start.month, 3);
      expect(start.day, 2);
      expect(start.weekday, DateTime.monday);
    });

    test('длина недели ровно 7 дней', () {
      final b = useCase(
        now: DateTime(2026, 7, 15),
        lifetimeType: 'weekly',
      );

      expect(b.endUtc.difference(b.startUtc), const Duration(days: 7));
    });
  });

  group('Месячный цикл', () {
    test('середина месяца откатывается к 1-му числу', () {
      final b = useCase(
        now: DateTime(2026, 7, 15, 14, 30),
        lifetimeType: 'monthly',
      );
      final start = b.startUtc.toLocal();
      final end = b.endUtc.toLocal();

      expect(start.day, 1);
      expect(start.month, 7);
      expect(start.hour, 0);
      expect(end.month, 8);
      expect(end.day, 1);
    });

    test('декабрь переходит на январь следующего года', () {
      final b = useCase(
        now: DateTime(2026, 12, 20),
        lifetimeType: 'monthly',
      );
      final end = b.endUtc.toLocal();

      expect(end.year, 2027);
      expect(end.month, 1);
      expect(end.day, 1);
    });

    test('1-е число остаётся собой', () {
      final b = useCase(
        now: DateTime(2026, 7, 1, 8),
        lifetimeType: 'monthly',
      );

      expect(b.startUtc.toLocal().day, 1);
    });

    test('неизвестный тип цикла трактуется как месячный', () {
      final now = DateTime(2026, 7, 15);
      final unknown = useCase(now: now, lifetimeType: 'quarterly');
      final monthly = useCase(now: now, lifetimeType: 'monthly');

      expect(unknown.startUtc, monthly.startUtc);
      expect(unknown.endUtc, monthly.endUtc);
    });
  });

  test('границы возвращаются в UTC', () {
    final b = useCase(now: DateTime(2026, 7, 15), lifetimeType: 'monthly');

    expect(b.startUtc.isUtc, isTrue);
    expect(b.endUtc.isUtc, isTrue);
  });
}