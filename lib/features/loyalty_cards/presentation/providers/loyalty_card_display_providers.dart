import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/loyalty_card.dart';
import 'loyalty_cards_usecase_providers.dart';

/// Карта для полноэкранного показа кассиру.
/// Read-only: watch-провайдер не нужен (6.3.21.13.13 — загрузка один раз).
final loyaltyCardDisplayProvider =
    FutureProvider.autoDispose.family<LoyaltyCard?, String>((ref, cardId) async {
  final result =
      await ref.watch(getLoyaltyCardByIdUseCaseProvider).call(cardId);
  return result.valueOrNull;
});