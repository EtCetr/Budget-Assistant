import 'package:freezed_annotation/freezed_annotation.dart';

part 'loyalty_card_form_draft.freezed.dart';
part 'loyalty_card_form_draft.g.dart';

/// Черновик формы добавления/редактирования карты
/// (автосейв каждые 5 сек, восстановление если младше 24 ч — ТЗ 6.3.20.13.10).
/// Хранится как JSON в loyalty_card_drafts (локальная таблица без sync).
@freezed
abstract class LoyaltyCardFormDraft with _$LoyaltyCardFormDraft {
  const factory LoyaltyCardFormDraft({
    /// NULL = новая карта, UUID = редактирование.
    String? cardId,
    @Default('') String storeName,

    /// имя BarcodeType.
    @Default('manual') String barcodeType,
    @Default('') String barcodeData,

    /// имя LoyaltyCardCategory.
    @Default('other') String category,
    String? brandColor,
    String? iconAsset,

    /// 'personal' | 'family'.
    @Default('personal') String visibility,
    required DateTime updatedAt,
  }) = _LoyaltyCardFormDraft;

  factory LoyaltyCardFormDraft.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyCardFormDraftFromJson(json);
}