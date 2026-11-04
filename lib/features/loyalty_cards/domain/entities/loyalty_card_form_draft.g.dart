// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_card_form_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoyaltyCardFormDraft _$LoyaltyCardFormDraftFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_LoyaltyCardFormDraft', json, ($checkedConvert) {
  final val = _LoyaltyCardFormDraft(
    cardId: $checkedConvert('cardId', (v) => v as String?),
    storeName: $checkedConvert('storeName', (v) => v as String? ?? ''),
    barcodeType: $checkedConvert(
      'barcodeType',
      (v) => v as String? ?? 'manual',
    ),
    barcodeData: $checkedConvert('barcodeData', (v) => v as String? ?? ''),
    category: $checkedConvert('category', (v) => v as String? ?? 'other'),
    brandColor: $checkedConvert('brandColor', (v) => v as String?),
    iconAsset: $checkedConvert('iconAsset', (v) => v as String?),
    visibility: $checkedConvert(
      'visibility',
      (v) => v as String? ?? 'personal',
    ),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$LoyaltyCardFormDraftToJson(
  _LoyaltyCardFormDraft instance,
) => <String, dynamic>{
  'cardId': instance.cardId,
  'storeName': instance.storeName,
  'barcodeType': instance.barcodeType,
  'barcodeData': instance.barcodeData,
  'category': instance.category,
  'brandColor': instance.brandColor,
  'iconAsset': instance.iconAsset,
  'visibility': instance.visibility,
  'updatedAt': instance.updatedAt.toIso8601String(),
};
