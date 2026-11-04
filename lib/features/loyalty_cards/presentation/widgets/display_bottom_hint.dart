import 'package:flutter/material.dart';
import '../loyalty_cards_strings.dart';

/// Подсказка внизу экрана, автоскрывается вместе с Top Bar (ТЗ 6.3.21.8).
class DisplayBottomHint extends StatelessWidget {
  const DisplayBottomHint({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xB3000000),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('💳', style: TextStyle(fontSize: 18)),
          SizedBox(width: 8),
          Text(
            LoyaltyCardsStrings.displayHint,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}