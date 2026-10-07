import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipt_offer_settings.freezed.dart';

/// Спам-защита и настройки чеков (проекция app_settings, ТЗ 6.3.49.4).
@freezed
abstract class ReceiptOfferSettings with _$ReceiptOfferSettings {
  const factory ReceiptOfferSettings({
    required bool autoOfferNaming,
    required int offerNamingCount,
    required bool autoOfferSplit,
    required int offerSplitCount,
    required bool syncImagesToCloud,
  }) = _ReceiptOfferSettings;
}