import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:budget_assistant/features/cashback/domain/repositories/exchange_rate_repository.dart';
import 'package:budget_assistant/features/cashback/domain/usecases/convert_currency_usecase.dart';

class _MockRates extends Mock implements ExchangeRateRepository {}

/// Этап 24: конвертация суммы в копейках по курсу на дату (ТОМ 4 §4.2).
///
/// Курсы в тестах подобраны точными в двоичной плавающей точке (2.5, 1.006
/// даёт 100.6): иначе произведение вида 100 * 1.005 = 100.4999... округлится
/// вниз, и тест проверял бы артефакт double, а не логику UseCase.
void main() {
  late _MockRates rates;
  late ConvertCurrencyUseCase useCase;
  final day = DateTime.utc(2026, 7, 15);

  setUpAll(() {
    registerFallbackValue(DateTime.utc(2026));
  });

  setUp(() {
    rates = _MockRates();
    useCase = ConvertCurrencyUseCase(
      rateRepository: rates,
      logger: Logger(level: Level.off),
    );
  });

  test('одна и та же валюта: сумма не меняется, курс не запрашивается',
      () async {
    final result = await useCase(
      amountKopecks: 123456,
      fromCurrency: 'RUB',
      toCurrency: 'RUB',
      dateUtc: day,
    );

    expect(result, 123456);
    verifyNever(() => rates.getRate(
          fromCurrency: any(named: 'fromCurrency'),
          toCurrency: any(named: 'toCurrency'),
          dateUtc: any(named: 'dateUtc'),
        ));
  });

  test('конвертация по курсу с округлением до копеек', () async {
    when(() => rates.getRate(
          fromCurrency: 'USD',
          toCurrency: 'RUB',
          dateUtc: day,
        )).thenAnswer((_) async => 95.5);

    final result = await useCase(
      amountKopecks: 10000,
      fromCurrency: 'USD',
      toCurrency: 'RUB',
      dateUtc: day,
    );

    expect(result, 955000);
  });

  test('половина копейки округляется вверх: 3 * 2.5 = 7.5 -> 8', () async {
    when(() => rates.getRate(
          fromCurrency: 'USD',
          toCurrency: 'RUB',
          dateUtc: day,
        )).thenAnswer((_) async => 2.5);

    final result = await useCase(
      amountKopecks: 3,
      fromCurrency: 'USD',
      toCurrency: 'RUB',
      dateUtc: day,
    );

    expect(result, 8);
  });

  test('дробный курс: результат округляется до целых копеек', () async {
    when(() => rates.getRate(
          fromCurrency: 'USD',
          toCurrency: 'RUB',
          dateUtc: day,
        )).thenAnswer((_) async => 1.006);

    final result = await useCase(
      amountKopecks: 100,
      fromCurrency: 'USD',
      toCurrency: 'RUB',
      dateUtc: day,
    );

    expect(result, 101);
  });

  test('курса нет — возвращается null, вызывающий код решает', () async {
    when(() => rates.getRate(
          fromCurrency: any(named: 'fromCurrency'),
          toCurrency: any(named: 'toCurrency'),
          dateUtc: any(named: 'dateUtc'),
        )).thenAnswer((_) async => null);

    final result = await useCase(
      amountKopecks: 10000,
      fromCurrency: 'USD',
      toCurrency: 'RUB',
      dateUtc: day,
    );

    expect(result, isNull);
  });

  test('ошибка репозитория пробрасывается', () async {
    when(() => rates.getRate(
          fromCurrency: any(named: 'fromCurrency'),
          toCurrency: any(named: 'toCurrency'),
          dateUtc: any(named: 'dateUtc'),
        )).thenThrow(Exception('network'));

    await expectLater(
      useCase(
        amountKopecks: 10000,
        fromCurrency: 'USD',
        toCurrency: 'RUB',
        dateUtc: day,
      ),
      throwsA(isA<Exception>()),
    );
  });
}