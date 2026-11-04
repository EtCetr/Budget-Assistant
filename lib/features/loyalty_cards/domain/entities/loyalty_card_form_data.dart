import 'package:freezed_annotation/freezed_annotation.dart';
import 'loyalty_card.dart';

part 'loyalty_card_form_data.freezed.dart';

/// DTO формы добавления/редактирования карты (ТЗ 6.3.20.5).
/// Строится виджетами формы, валидируется ValidateLoyaltyCardFormUseCase,
/// в сущность превращается BuildLoyaltyCardDraftUseCase.
@freezed
abstract class LoyaltyCardFormData with _$LoyaltyCardFormData {
  const factory LoyaltyCardFormData({
    /// NULL = создание, UUID = редактирование.
    String? cardId,
    @Default('') String storeName,
    @Default(BarcodeType.manual) BarcodeType barcodeType,
    @Default('') String barcodeData,

    /// #RRGGBB или null.
    String? brandColor,
    String? iconAsset,
    @Default(LoyaltyCardCategory.other) LoyaltyCardCategory category,

    /// 'personal' | 'family'.
    @Default('personal') String visibility,
  }) = _LoyaltyCardFormData;
}