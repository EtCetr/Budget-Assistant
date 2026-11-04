import 'package:flutter/material.dart';
import '../loyalty_cards_strings.dart';

/// Временная заглушка маршрута показа карты кассиру.
/// TODO(20.5): заменить LoyaltyCardDisplayStubScreen на
///   LoyaltyCardDisplayScreen (файл loyalty_card_display_screen.dart, спека 6.3.21).
class LoyaltyCardDisplayStubScreen extends StatelessWidget {
  const LoyaltyCardDisplayStubScreen({super.key, required this.cardId});

  final String cardId;

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text(LoyaltyCardsStrings.stubDisplay)),
    );
  }
}