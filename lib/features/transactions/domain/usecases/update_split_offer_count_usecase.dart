import 'package:logger/logger.dart';
import '../services/split_offer_settings_port.dart';

/// Защита от спама предложений разделения чека (ТЗ 6.3.48.8):
/// согласие сбрасывает счётчик, отказ инкрементирует; >= 3 отказов
/// подряд отключают автопредложение.
class UpdateSplitOfferCountUseCase {
  UpdateSplitOfferCountUseCase({
    required SplitOfferSettingsPort settings,
    required Logger logger,
  })  : _settings = settings,
        _logger = logger;

  final SplitOfferSettingsPort _settings;
  final Logger _logger;

  Future<void> call({
    required String userId,
    required bool accepted,
  }) async {
    try {
      await _settings.updateSplitOfferCount(userId: userId, accepted: accepted);
    } catch (e, st) {
      _logger.e('UpdateSplitOfferCountUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}