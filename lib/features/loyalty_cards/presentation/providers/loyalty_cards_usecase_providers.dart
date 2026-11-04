import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/providers/util_providers.dart';
import '../../domain/usecases/auto_detect_barcode_type_usecase.dart';
import '../../domain/usecases/build_loyalty_card_draft_usecase.dart';
import '../../domain/usecases/create_loyalty_card_usecase.dart';
import '../../domain/usecases/delete_loyalty_card_usecase.dart';
import '../../domain/usecases/format_card_number_for_display_usecase.dart';
import '../../domain/usecases/get_loyalty_card_by_id_usecase.dart';
import '../../domain/usecases/get_loyalty_cards_stats_usecase.dart';
import '../../domain/usecases/loyalty_card_draft_usecases.dart';
import '../../domain/usecases/toggle_loyalty_card_favorite_usecase.dart';
import '../../domain/usecases/toggle_loyalty_card_shared_usecase.dart';
import '../../domain/usecases/update_loyalty_card_preferred_orientation_usecase.dart';
import '../../domain/usecases/update_loyalty_card_sort_order_usecase.dart';
import '../../domain/usecases/update_loyalty_card_usecase.dart';
import '../../domain/usecases/validate_loyalty_card_form_usecase.dart';
import '../../domain/usecases/watch_loyalty_cards_usecase.dart';
import 'loyalty_cards_repository_providers.dart';

final Logger _logger = Logger();

final watchLoyaltyCardsUseCaseProvider =
    Provider<WatchLoyaltyCardsUseCase>((ref) {
  return WatchLoyaltyCardsUseCase(
    repo: ref.watch(loyaltyCardsRepositoryProvider),
    logger: _logger,
  );
});

final getLoyaltyCardsStatsUseCaseProvider =
    Provider<GetLoyaltyCardsStatsUseCase>((ref) {
  return GetLoyaltyCardsStatsUseCase(
    repo: ref.watch(loyaltyCardsRepositoryProvider),
    logger: _logger,
  );
});

final getLoyaltyCardByIdUseCaseProvider =
    Provider<GetLoyaltyCardByIdUseCase>((ref) {
  return GetLoyaltyCardByIdUseCase(
    repo: ref.watch(loyaltyCardsRepositoryProvider),
    logger: _logger,
  );
});

final createLoyaltyCardUseCaseProvider =
    Provider<CreateLoyaltyCardUseCase>((ref) {
  return CreateLoyaltyCardUseCase(
    repo: ref.watch(loyaltyCardsRepositoryProvider),
    logger: _logger,
  );
});

final updateLoyaltyCardUseCaseProvider =
    Provider<UpdateLoyaltyCardUseCase>((ref) {
  return UpdateLoyaltyCardUseCase(
    repo: ref.watch(loyaltyCardsRepositoryProvider),
    logger: _logger,
  );
});

final deleteLoyaltyCardUseCaseProvider =
    Provider<DeleteLoyaltyCardUseCase>((ref) {
  return DeleteLoyaltyCardUseCase(
    repo: ref.watch(loyaltyCardsRepositoryProvider),
    logger: _logger,
  );
});

final updateLoyaltyCardSortOrderUseCaseProvider =
    Provider<UpdateLoyaltyCardSortOrderUseCase>((ref) {
  return UpdateLoyaltyCardSortOrderUseCase(
    repo: ref.watch(loyaltyCardsRepositoryProvider),
    logger: _logger,
  );
});

final toggleLoyaltyCardFavoriteUseCaseProvider =
    Provider<ToggleLoyaltyCardFavoriteUseCase>((ref) {
  return ToggleLoyaltyCardFavoriteUseCase(
    repo: ref.watch(loyaltyCardsRepositoryProvider),
    logger: _logger,
  );
});

final toggleLoyaltyCardSharedUseCaseProvider =
    Provider<ToggleLoyaltyCardSharedUseCase>((ref) {
  return ToggleLoyaltyCardSharedUseCase(
    repo: ref.watch(loyaltyCardsRepositoryProvider),
    logger: _logger,
  );
});

final validateLoyaltyCardFormUseCaseProvider =
    Provider<ValidateLoyaltyCardFormUseCase>((ref) {
  return ValidateLoyaltyCardFormUseCase(logger: _logger);
});

final buildLoyaltyCardDraftUseCaseProvider =
    Provider<BuildLoyaltyCardDraftUseCase>((ref) {
  return BuildLoyaltyCardDraftUseCase(
    uuid: ref.watch(uuidProvider),
    logger: _logger,
  );
});

final autoDetectBarcodeTypeUseCaseProvider =
    Provider<AutoDetectBarcodeTypeUseCase>((ref) {
  return AutoDetectBarcodeTypeUseCase(logger: _logger);
});

final formatCardNumberForDisplayUseCaseProvider =
    Provider<FormatCardNumberForDisplayUseCase>((ref) {
  return FormatCardNumberForDisplayUseCase(logger: _logger);
});

final updateLoyaltyCardPreferredOrientationUseCaseProvider =
    Provider<UpdateLoyaltyCardPreferredOrientationUseCase>((ref) {
  return UpdateLoyaltyCardPreferredOrientationUseCase(
    repo: ref.watch(loyaltyCardsRepositoryProvider),
    logger: _logger,
  );
});

final saveLoyaltyCardDraftUseCaseProvider =
    Provider<SaveLoyaltyCardDraftUseCase>((ref) {
  return SaveLoyaltyCardDraftUseCase(
    repo: ref.watch(loyaltyCardsRepositoryProvider),
    logger: _logger,
  );
});

final restoreLoyaltyCardDraftUseCaseProvider =
    Provider<RestoreLoyaltyCardDraftUseCase>((ref) {
  return RestoreLoyaltyCardDraftUseCase(
    repo: ref.watch(loyaltyCardsRepositoryProvider),
    logger: _logger,
  );
});

final clearLoyaltyCardDraftUseCaseProvider =
    Provider<ClearLoyaltyCardDraftUseCase>((ref) {
  return ClearLoyaltyCardDraftUseCase(
    repo: ref.watch(loyaltyCardsRepositoryProvider),
    logger: _logger,
  );
});