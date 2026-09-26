/// Порт домена: счётчики защиты от спама предложений разделения чека
/// (app_settings.offer_receipt_split_count / auto_offer_receipt_split,
/// ТЗ 6.3.15.12 п.5 / 6.3.48.8). Реализация — в data-слое (AppSettingsDao).
abstract interface class SplitOfferSettingsPort {
  /// accepted = true: сброс счётчика и включение автопредложения.
  /// accepted = false: count++; при count >= 3 автопредложение выключается.
  Future<void> updateSplitOfferCount({
    required String userId,
    required bool accepted,
  });
}