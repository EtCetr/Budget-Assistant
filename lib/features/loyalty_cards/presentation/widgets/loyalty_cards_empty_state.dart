import 'package:flutter/material.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import '../loyalty_cards_strings.dart';

/// Empty states экрана карт (ТЗ 6.3.19.12): 4 варианта, статичные иконки.
class LoyaltyCardsEmptyState extends StatelessWidget {
  const LoyaltyCardsEmptyState({
    super.key,
    required this.kind,
    this.onAdd,
    this.onResetFilters,
    this.onRetry,
  });

  /// 'no_cards' | 'filter' | 'family' | 'error'
  final String kind;
  final VoidCallback? onAdd;
  final VoidCallback? onResetFilters;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    switch (kind) {
      case 'filter':
        return EmptyStateWidget(
          icon: Icons.search_off,
          title: LoyaltyCardsStrings.emptyFilterTitle,
          subtitle: LoyaltyCardsStrings.emptyFilterSubtitle,
          primaryAction: onResetFilters == null
              ? null
              : EmptyStateAction(
                  label: LoyaltyCardsStrings.emptyFilterCta,
                  onPressed: onResetFilters!,
                  isPrimary: false,
                ),
        );
      case 'family':
        return EmptyStateWidget(
          icon: Icons.family_restroom,
          title: LoyaltyCardsStrings.emptyFamilyTitle,
          subtitle: LoyaltyCardsStrings.emptyFamilySubtitle,
          primaryAction: onAdd == null
              ? null
              : EmptyStateAction(
                  label: LoyaltyCardsStrings.emptyFamilyCta,
                  onPressed: onAdd!,
                ),
        );
      case 'error':
        return EmptyStateWidget(
          icon: Icons.error_outline,
          title: LoyaltyCardsStrings.errorTitle,
          subtitle: LoyaltyCardsStrings.errorSubtitle,
          primaryAction: onRetry == null
              ? null
              : EmptyStateAction(
                  label: LoyaltyCardsStrings.errorRetry,
                  onPressed: onRetry!,
                ),
        );
      default:
        return EmptyStateWidget(
          icon: Icons.wallet_outlined,
          title: LoyaltyCardsStrings.emptyNoCardsTitle,
          subtitle: LoyaltyCardsStrings.emptyNoCardsSubtitle,
          primaryAction: onAdd == null
              ? null
              : EmptyStateAction(
                  label: LoyaltyCardsStrings.emptyNoCardsCta,
                  onPressed: onAdd!,
                ),
        );
    }
  }
}