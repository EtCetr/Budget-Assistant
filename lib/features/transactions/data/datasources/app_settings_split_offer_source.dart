import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/daos/app_settings_dao.dart';
import '../../domain/services/split_offer_settings_port.dart';

/// Реализация порта счётчиков спама на локальных app_settings.
class AppSettingsSplitOfferSource implements SplitOfferSettingsPort {
  AppSettingsSplitOfferSource({
    required AppSettingsDao dao,
    required Logger logger,
  })  : _dao = dao,
        _logger = logger;

  final AppSettingsDao _dao;
  final Logger _logger;

  @override
  Future<void> updateSplitOfferCount({
    required String userId,
    required bool accepted,
  }) async {
    try {
      if (accepted) {
        await _dao.updateForUser(
          userId,
          const AppSettingsCompanion(
            offerReceiptSplitCount: Value(0),
            autoOfferReceiptSplit: Value(true),
          ),
        );
        return;
      }
      final settings = await _dao.getForUser(userId);
      final newCount = settings.offerReceiptSplitCount + 1;
      await _dao.updateForUser(
        userId,
        AppSettingsCompanion(
          offerReceiptSplitCount: Value(newCount),
          // 3 отказа подряд -> автопредложение выключается (ТЗ 6.3.48.8).
          autoOfferReceiptSplit: Value(newCount < 3),
        ),
      );
    } catch (e, st) {
      _logger.e('updateSplitOfferCount failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}