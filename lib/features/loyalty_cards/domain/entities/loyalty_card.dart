import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';

part 'loyalty_card.freezed.dart';

/// Типы штрих-кодов (ТЗ 6.3.20.5 / 6.3.21.13.4).
enum BarcodeType { ean13, code128, qr, pdf417, manual }

/// Категории карт (ТЗ 6.3.19.5).
enum LoyaltyCardCategory { grocery, pharmacy, clothing, fuel, other }

/// Область отображения списка (ТЗ 6.3.19.3).
enum LoyaltyCardsScope { personal, family }

/// Фильтр по категории (ТЗ 6.3.19.5): одиночный выбор,
/// повторный тап по активному чипу сбрасывает в «Все» (Правило 20).
enum LoyaltyCardCategoryFilter { all, grocery, pharmacy, clothing, fuel, other }

/// Доменная модель скидочной карты.
///
/// E2E-поля (storeName, cardNumber, barcodeData) локально открыты
/// (генерация кодов без расшифровки); AES-256-GCM — только sync-пейлоад
/// (Этап 25). Прецедент — Этап 16 (чеки).
@freezed
abstract class LoyaltyCard with _$LoyaltyCard {
  const factory LoyaltyCard({
    required String id,
    required String userId,

    /// NULL = личная, UUID = семейная.
    String? spaceId,
    required String storeName,
    String? cardNumber,
    required BarcodeType barcodeType,
    required String barcodeData,

    /// #RRGGBB или null.
    String? brandColor,

    /// Эмодзи/ассет.
    String? iconAsset,
    @Default(LoyaltyCardCategory.other) LoyaltyCardCategory category,
    @Default(false) bool isFavorite,
    @Default(true) bool isShared,

    /// [LOCAL] не синхронизируется.
    int? sortOrder,

    /// [LOCAL] 'portrait' | 'landscape' | null.
    String? preferredOrientation,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(SyncStatus.pending) SyncStatus syncStatus,
  }) = _LoyaltyCard;
}

/// Сводка экрана карт (ТЗ 6.3.19.6).
@freezed
abstract class LoyaltyCardsStats with _$LoyaltyCardsStats {
  const factory LoyaltyCardsStats({
    required int total,
    required int favorites,
    required int family,
  }) = _LoyaltyCardsStats;
}