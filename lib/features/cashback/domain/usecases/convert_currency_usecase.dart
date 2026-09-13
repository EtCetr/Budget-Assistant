import 'package:logger/logger.dart';
import '../repositories/exchange_rate_repository.dart';

/// Конвертация суммы в копейках из одной валюты в другую по курсу на дату
/// с fallback до 7 дней назад (ТОМ 4 §4.2).
/// Возвращает null, если курс не найден (вызывающий код решает, что делать).
class ConvertCurrencyUseCase {
  ConvertCurrencyUseCase({
    required ExchangeRateRepository rateRepository,
    required Logger logger,
  })  : _rateRepository = rateRepository,
        _logger = logger;

  final ExchangeRateRepository _rateRepository;
  final Logger _logger;

  Future<int?> call({
    required int amountKopecks,
    required String fromCurrency,
    required String toCurrency,
    required DateTime dateUtc,
  }) async {
    try {
      if (fromCurrency == toCurrency) return amountKopecks;
      final rate = await _rateRepository.getRate(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        dateUtc: dateUtc,
      );
      if (rate == null) {
        _logger.w(
          'No exchange rate for $fromCurrency -> $toCurrency on $dateUtc (fallback 7d exhausted)',
        );
        return null;
      }
      return (amountKopecks * rate).round();
    } catch (e, st) {
      _logger.e('ConvertCurrencyUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}