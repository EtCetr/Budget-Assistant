import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

/// Источник официальных курсов ЦБ РФ (открытое зеркало, без API-ключа).
///
/// Возвращает курсы валют к RUB в формате { 'USD': 92.5345, ... }
/// (рублей за 1 единицу валюты, Nominal уже учтён).
///
/// Offline-First: любая сетевая ошибка возвращает null, а не исключение —
/// вызывающий код уходит в fallback-цепочку (кэш / manual / старый курс).
class CbrRateRemoteSource {
  CbrRateRemoteSource({required Logger logger, Dio? dio})
      : _logger = logger,
        _dio = dio ??
            Dio(BaseOptions(
              connectTimeout: const Duration(seconds: 6),
              receiveTimeout: const Duration(seconds: 6),
            ));

  final Logger _logger;
  final Dio _dio;

  static const String _baseUrl = 'https://www.cbr-xml-daily.ru/daily_json.js';

  /// Курсы на дату [dateUtc]. Зеркало поддерживает параметр date=YYYY-MM-DD.
  Future<Map<String, double>?> fetchRubRates(DateTime dateUtc) async {
    final result = await _get(_dateStr(dateUtc));
    if (result != null) return result;
    // Страховка: если зеркало не отдает дату параметром — для сегодняшнего
    // дня пробуем запрос без параметра (там всегда актуальный дневной курс).
    final today = DateTime.now().toUtc();
    final todayUtc = DateTime.utc(today.year, today.month, today.day);
    final dayUtc = DateTime.utc(dateUtc.year, dateUtc.month, dateUtc.day);
    if (todayUtc == dayUtc) {
      return await _get(null);
    }
    return null;
  }

  Future<Map<String, double>?> _get(String? dateStr) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: dateStr == null ? null : {'date': dateStr},
      );
      dynamic raw = response.data;
      if (raw is String) {
        try {
          raw = jsonDecode(raw);
        } catch (_) {
          _logger.w('CBR response is not valid JSON for date=$dateStr');
          return null;
        }
      }
      if (raw is! Map) {
        _logger.w('CBR response is not a Map for date=$dateStr');
        return null;
      }
      final valute = raw['Valute'];
      if (valute is! Map) {
        _logger.w('CBR response has no Valute map for date=$dateStr');
        return null;
      }
      final result = <String, double>{};
      for (final entry in valute.entries) {
        final item = entry.value;
        if (item is! Map) continue;
        final charCode = item['CharCode'];
        final nominal = item['Nominal'];
        final value = item['Value'];
        if (charCode is! String || nominal is! num || value is! num) continue;
        if (nominal <= 0) continue;
        result[charCode.toUpperCase()] = value.toDouble() / nominal.toDouble();
      }
      if (result.isEmpty) {
        _logger.w('CBR returned empty Valute for date=$dateStr');
        return null;
      }
      return result;
    } catch (e) {
      _logger.w('CBR fetch failed for date=$dateStr: $e');
      return null;
    }
  }

  String _dateStr(DateTime d) {
    return '${d.year.toString().padLeft(4, '0')}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }
}