import 'package:logger/logger.dart';
import '../entities/cashback_cycle_bounds.dart';

/// Рассчитывает границы цикла кэшбэка в ЛОКАЛЬНОМ часовом поясе,
/// затем конвертирует в UTC (ТОМ 4, Правило 5).
///
/// Обнуление недельного: Понедельник 00:00 (локальное).
/// Обнуление месячного:  1-е число 00:00 (локальное).
///
/// Пакет flutter_timezone не используется: DateTime в Dart уже работает
/// в локальном поясе устройства, а .toUtc() даёт корректную UTC-границу.
class GetCashbackCycleBoundsUseCase {
  GetCashbackCycleBoundsUseCase({required Logger logger}) : _logger = logger;

  final Logger _logger;

  CashbackCycleBounds call({required DateTime now, required String lifetimeType}) {
    try {
      final local = now.toLocal();
      if (lifetimeType == 'weekly') {
        // Понедельник = 1. Откатываемся к ближайшему прошедшему понедельнику.
        final daysSinceMonday = local.weekday - 1;
        final startLocal = DateTime(local.year, local.month, local.day - daysSinceMonday);
        final endLocal = startLocal.add(const Duration(days: 7));
        return CashbackCycleBounds(
          startUtc: startLocal.toUtc(),
          endUtc: endLocal.toUtc(),
        );
      }
      final startLocal = DateTime(local.year, local.month, 1);
      final endLocal = DateTime(local.year, local.month + 1, 1);
      return CashbackCycleBounds(
        startUtc: startLocal.toUtc(),
        endUtc: endLocal.toUtc(),
      );
    } catch (e, st) {
      _logger.e('GetCashbackCycleBoundsUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}