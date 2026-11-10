import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/providers/member_color_providers.dart';
import 'package:budget_assistant/features/settings/presentation/providers/settings_providers.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';
import '../../domain/entities/loyalty_card.dart';
import 'loyalty_cards_category_ui.dart';

/// Карточка карты в сетке (ТЗ 6.3.19.7).
///
/// Privacy: имя магазина и номер — только через PrivacyFormatter
/// (hidden: имя •••, номер ••••); бейджи категории/избранного остаются
/// (метаданные), бейдж создателя скрывается в hidden.
/// Этап 22: добавлена семантика для TalkBack.
class LoyaltyCardTile extends ConsumerWidget {
  const LoyaltyCardTile({
    super.key,
    required this.card,
    required this.mode,
    required this.formatter,
    required this.currentUserId,
  });

  final LoyaltyCard card;
  final BalanceVisibilityMode mode;
  final PrivacyFormatter formatter;
  final String currentUserId;

  Color get _brandColor {
    final hex = card.brandColor;
    if (hex == null || hex.length != 7) return AppColors.surfaceCard;
    final value = int.tryParse(hex.substring(1), radix: 16);
    if (value == null) return AppColors.surfaceCard;
    return Color(0xFF000000 | value);
  }

  String _maskedNumber() {
    if (mode == BalanceVisibilityMode.hidden) {
      return formatter.formatCardNumber(card.barcodeData, mode);
    }
    final digits =
        (card.cardNumber ?? card.barcodeData).replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return '';
    final tail = digits.length <= 4 ? digits : digits.substring(digits.length - 4);
    return '*$tail';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brand = _brandColor;
    final onBrand = brand != AppColors.surfaceCard;
    final titleColor =
        onBrand ? Colors.white : AppColors.textPrimary;
    final subColor = onBrand
        ? Colors.white.withValues(alpha: 0.7)
        : AppColors.textSecondary;
    final storeName = formatter.formatMerchant(card.storeName, mode);
    final semanticLabel = '$storeName, карта лояльности'
        '${card.isFavorite ? ', избранная' : ''}';

    return Semantics(
      label: semanticLabel,
      child: Container(
        decoration: BoxDecoration(
          color: brand,
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          border: card.syncStatus == SyncStatus.conflict
              ? Border.all(color: AppColors.colorExpense, width: 2)
              : null,
        ),
        padding: const EdgeInsets.all(AppSpacing.spacing16),
        child: Stack(
          children: [
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      card.iconAsset ?? '💳',
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: AppSpacing.spacing8),
                    Text(
                      storeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: titleColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.spacing4),
                    Text(
                      _maskedNumber(),
                      style: TextStyle(color: subColor, letterSpacing: 2),
                    ),
                    const SizedBox(height: AppSpacing.spacing8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (card.isFavorite)
                          const Icon(Icons.star,
                              size: 16, color: AppColors.colorWarning),
                        if (card.isFavorite)
                          const SizedBox(width: AppSpacing.spacing8),
                        Icon(
                          LoyaltyCardCategoryUi.icon(card.category),
                          size: 16,
                          color: LoyaltyCardCategoryUi.color(card.category),
                        ),
                        if (card.userId != currentUserId &&
                            formatter.shouldShowFamilyColors(mode) &&
                            (ref.watch(appSettingsRowProvider).value
                                    ?.showFamilyColorsInTransactions ??
                                true)) ...[
                          const SizedBox(width: AppSpacing.spacing8),
                          Icon(Icons.person_outline,
                              size: 16,
                              color: ref.watch(
                                  memberColorInCurrentSpaceProvider(card.userId))),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (card.syncStatus == SyncStatus.pending)
              const Positioned(
                top: 0,
                right: 0,
                child: Icon(Icons.cloud_off,
                    size: 16, color: AppColors.colorPendingSync),
              ),
          ],
        ),
      ),
    );
  }
}