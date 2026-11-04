import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../entities/loyalty_card.dart';
import '../entities/loyalty_card_form_data.dart';

/// Сборка доменной карты из DTO формы (ТЗ 6.3.20.13: построение DTO — не в UI).
///
/// [existing] передаётся при редактировании: сохраняются id, createdAt,
/// sortOrder и preferred_orientation ([LOCAL]-поля).
class BuildLoyaltyCardDraftUseCase {
  BuildLoyaltyCardDraftUseCase({
    required Uuid uuid,
    required Logger logger,
  })  : _uuid = uuid,
        _logger = logger;

  final Uuid _uuid;
  final Logger _logger;

  LoyaltyCard call({
    required LoyaltyCardFormData form,
    required String userId,
    String? currentSpaceId,
    LoyaltyCard? existing,
  }) {
    try {
      final now = DateTime.now().toUtc();
      final data = form.barcodeData.trim();
      final isFamily = form.visibility == 'family';
      return LoyaltyCard(
        id: existing?.id ?? _uuid.v4(),
        userId: userId,
        spaceId: isFamily ? currentSpaceId : null,
        storeName: form.storeName.trim(),
        cardNumber:
            form.barcodeType == BarcodeType.manual ? data : null,
        barcodeType: form.barcodeType,
        barcodeData: data,
        brandColor: form.brandColor,
        iconAsset: form.iconAsset,
        category: form.category,
        isFavorite: existing?.isFavorite ?? false,
        isShared: isFamily ? true : (existing?.isShared ?? true),
        sortOrder: existing?.sortOrder,
        preferredOrientation: existing?.preferredOrientation,
        createdAt: existing?.createdAt ?? now,
        updatedAt: now,
        syncStatus: SyncStatus.pending,
      );
    } catch (e, st) {
      _logger.e('BuildLoyaltyCardDraft failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}