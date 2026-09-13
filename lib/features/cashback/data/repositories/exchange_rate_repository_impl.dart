import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import '../../domain/entities/exchange_rate_entry.dart';
import '../../domain/repositories/exchange_rate_repository.dart';
import '../datasources/exchange_rate_dao.dart';

class ExchangeRateRepositoryImpl implements ExchangeRateRepository {
  ExchangeRateRepositoryImpl({
    required AppDatabase db,
    required Logger logger,
    required Uuid uuid,
  })  : _db = db,
        _logger = logger,
        _uuid = uuid,
        _dao = ExchangeRateDao(db);

  final AppDatabase _db;
  final Logger _logger;
  final Uuid _uuid;
  final ExchangeRateDao _dao;

  static const int _fallbackDays = 7;

  @override
  Future<double?> getRate({
    required String fromCurrency,
    required String toCurrency,
    required DateTime dateUtc,
  }) async {
    try {
      if (fromCurrency == toCurrency) return 1.0;
      final upper = dateUtc;
      final lower = dateUtc.subtract(const Duration(days: _fallbackDays));
      return await _dao.getLatestRate(
        fromCurrency: fromCurrency,
        toCurrency: toCurrency,
        upperBoundUtc: upper,
        lowerBoundUtc: lower,
      );
    } catch (e, st) {
      _logger.e('ExchangeRateRepository.getRate failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> upsertRate({
    required String fromCurrency,
    required String toCurrency,
    required DateTime dateUtc,
    required double rate,
    required String source,
  }) async {
    try {
      // Нормализуем дату курса к полуночи UTC (уникальный констрейнт по дате).
      final normalized = DateTime.utc(dateUtc.year, dateUtc.month, dateUtc.day);
      await _db.transaction(() async {
        await _dao.deleteByCurrencyDate(
          fromCurrency: fromCurrency,
          toCurrency: toCurrency,
          dateUtc: normalized,
        );
        await _dao.insert(ExchangeRatesCompanion(
          id: Value(_uuid.v4()),
          fromCurrency: Value(fromCurrency),
          toCurrency: Value(toCurrency),
          date: Value(normalized),
          rate: Value(rate),
          source: Value(source),
          createdAt: Value(DateTime.now().toUtc()),
        ));
      });
    } catch (e, st) {
      _logger.e('ExchangeRateRepository.upsertRate failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<ExchangeRateEntry>> getRecent({int limit = 30}) async {
    try {
      final rows = await _dao.getRecent(limit);
      return rows.map(_map).toList();
    } catch (e, st) {
      _logger.e('ExchangeRateRepository.getRecent failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Stream<List<ExchangeRateEntry>> watchRecent({int limit = 30}) {
    return _dao.watchRecent(limit).map((rows) => rows.map(_map).toList());
  }

  @override
  Future<void> deleteRate(String id) async {
    try {
      await _dao.deleteById(id);
    } catch (e, st) {
      _logger.e('ExchangeRateRepository.deleteRate failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  ExchangeRateEntry _map(ExchangeRateDb r) {
    return ExchangeRateEntry(
      id: r.id,
      fromCurrency: r.fromCurrency,
      toCurrency: r.toCurrency,
      date: r.date,
      rate: r.rate,
      source: r.source,
      createdAt: r.createdAt,
    );
  }
}