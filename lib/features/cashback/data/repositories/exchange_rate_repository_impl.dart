import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import '../../domain/entities/exchange_rate_entry.dart';
import '../../domain/repositories/exchange_rate_repository.dart';
import '../datasources/exchange_rate_dao.dart';
import '../remote/cbr_rate_remote_source.dart';

/// Реализация репозитория курсов с цепочкой приоритетов (Этап 10):
/// 1) ручное исключение ровно на дату;
/// 2) официальный кэш (кросс через RUB) за дату и окно D-1..D-7;
/// 3) ленивая загрузка с ЦБ за дату + повторная попытка;
/// 4) ручное исключение в окне 7 дней;
/// 5) последний официальный курс любой даты (чтобы офлайн не блокировал);
/// 6) null — вызывающий код показывает понятную ошибку.
class ExchangeRateRepositoryImpl implements ExchangeRateRepository {
  ExchangeRateRepositoryImpl({
    required AppDatabase db,
    required Logger logger,
    required Uuid uuid,
    required CbrRateRemoteSource remote,
  })  : _db = db,
        _logger = logger,
        _uuid = uuid,
        _remote = remote,
        _dao = ExchangeRateDao(db);

  final AppDatabase _db;
  final Logger _logger;
  final Uuid _uuid;
  final CbrRateRemoteSource _remote;
  final ExchangeRateDao _dao;

  static const int _fallbackDays = 7;

  /// Даты, по которым ЦБ уже ответил ошибкой за эту сессию.
  /// Защита от спама HTTP-запросов при офлайне.
  final Set<DateTime> _failedDates = <DateTime>{};

  @override
  Future<double?> getRate({
    required String fromCurrency,
    required String toCurrency,
    required DateTime dateUtc,
  }) async {
    try {
      if (fromCurrency == toCurrency) return 1.0;
      final day = DateTime.utc(dateUtc.year, dateUtc.month, dateUtc.day);
      final lower = day.subtract(const Duration(days: _fallbackDays));

      // 1) Ручное исключение ровно на дату.
      final manual = await _dao.getManualRateOnDate(fromCurrency, toCurrency, day);
      if (manual != null) return manual;

      // 2) Официальный кэш (кросс через RUB) в окне 7 дней.
      final cached = await _officialCross(fromCurrency, toCurrency, day, lower);
      if (cached != null) return cached;

      // 3) Ленивая загрузка с ЦБ и повторная попытка.
      if (await _tryLoadFromCbr(day)) {
        final loaded =
            await _officialCross(fromCurrency, toCurrency, day, lower);
        if (loaded != null) return loaded;
      }

      // 4) Ручное исключение в окне 7 дней.
      final manualWindow =
          await _dao.getManualRateInRange(fromCurrency, toCurrency, day, lower);
      if (manualWindow != null) return manualWindow;

      // 5) Последний официальный курс любой даты.
      final stale = await _staleCross(fromCurrency, toCurrency);
      if (stale != null) {
        _logger.w(
          'Using stale official rate for $fromCurrency->$toCurrency on $dateUtc',
        );
        return stale;
      }

      _logger.w('No exchange rate at all for $fromCurrency->$toCurrency on $dateUtc');
      return null;
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

  // ═══════════════════════════════════════════════════════════
  // Helpers
  // ═══════════════════════════════════════════════════════════

  /// Кросс-курс через RUB из официального кэша в окне дат.
  Future<double?> _officialCross(
    String from,
    String to,
    DateTime upper,
    DateTime lower,
  ) async {
    final rubFrom = from == 'RUB' ? 1.0 : await _dao.getOfficialRubPer(from, upper, lower);
    if (rubFrom == null) return null;
    final rubTo = to == 'RUB' ? 1.0 : await _dao.getOfficialRubPer(to, upper, lower);
    if (rubTo == null || rubTo == 0) return null;
    return rubFrom / rubTo;
  }

  /// Кросс-курс через RUB по последним официальным курсам любой даты.
  Future<double?> _staleCross(String from, String to) async {
    final rubFrom = from == 'RUB' ? 1.0 : await _dao.getLatestOfficialRubPer(from);
    if (rubFrom == null) return null;
    final rubTo = to == 'RUB' ? 1.0 : await _dao.getLatestOfficialRubPer(to);
    if (rubTo == null || rubTo == 0) return null;
    return rubFrom / rubTo;
  }

  /// Ленивая загрузка даты с ЦБ. false — если уже пытались и не вышло.
  Future<bool> _tryLoadFromCbr(DateTime day) async {
    if (_failedDates.contains(day)) return false;
    final rates = await _remote.fetchRubRates(day);
    if (rates == null) {
      _failedDates.add(day);
      return false;
    }
    await _dao.cacheOfficialRates(day, rates);
    return true;
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