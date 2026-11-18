import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/receipts/domain/usecases/parse_fiscal_qr_usecase.dart';

/// Этап 24: разбор фискального QR ФНС (ТЗ 6.3.22.12).
/// t=yyyyMMddTHHmmss, s=сумма, fn/fp/i/n — фискальные признаки.
void main() {
  late ParseFiscalQrUseCase useCase;

  setUp(() {
    useCase = ParseFiscalQrUseCase(Logger(level: Level.off));
  });

  test('валидный QR: дата в UTC и сумма в копейках', () {
    final data = useCase('t=20260715T123000&s=1500.50');

    expect(data, isNotNull);
    expect(data!.dateUtc, DateTime.utc(2026, 7, 15, 12, 30, 0));
    expect(data.totalKop, 150050);
  });

  test('сумма с запятой как десятичным разделителем', () {
    final data = useCase('t=20260715T123000&s=1500,50');

    expect(data!.totalKop, 150050);
  });

  test('фискальные признаки собираются в JSON', () {
    final data = useCase(
      't=20260715T123000&s=100.00&fn=1234567890&fp=123456789&i=12345&n=1',
    );

    final fiscal = jsonDecode(data!.fiscalDataJson!) as Map<String, dynamic>;
    expect(fiscal['fn'], '1234567890');
    expect(fiscal['fp'], '123456789');
    expect(fiscal['i'], '12345');
    expect(fiscal['n'], '1');
  });

  test('без фискальных признаков JSON не создаётся', () {
    final data = useCase('t=20260715T123000&s=100.00');

    expect(data!.fiscalDataJson, isNull);
  });

  test('исходная строка сохраняется', () {
    const raw = 't=20260715T123000&s=100.00';
    expect(useCase(raw)!.raw, raw);
  });

  test('нет даты — null', () {
    expect(useCase('s=100.00&fn=123'), isNull);
  });

  test('нет суммы — null', () {
    expect(useCase('t=20260715T123000'), isNull);
  });

  test('битая дата — null', () {
    expect(useCase('t=abc&s=100.00'), isNull);
  });

  test('битая сумма — null', () {
    expect(useCase('t=20260715T123000&s=abc'), isNull);
  });

  test('ISO-дата разбирается фолбэком', () {
    final data = useCase('t=2026-07-15T12:30:00&s=100.00');

    expect(data, isNotNull);
    expect(data!.dateUtc.isUtc, isTrue);
    expect(data.totalKop, 10000);
  });

  test('URL-кодирование значения раскодируется', () {
    final data = useCase('t=20260715T123000&s=1500%2E50');

    expect(data!.totalKop, 150050);
  });

  test('параметр без знака равенства игнорируется', () {
    final data = useCase('garbage&t=20260715T123000&s=100.00');

    expect(data, isNotNull);
    expect(data!.totalKop, 10000);
  });
}