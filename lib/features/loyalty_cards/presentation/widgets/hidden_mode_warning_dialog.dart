import 'package:flutter/material.dart';
import '../loyalty_cards_strings.dart';

/// Предупреждение при попытке открыть показ в hidden (ТЗ 6.3.21.9).
class HiddenModeWarningDialog extends StatelessWidget {
  const HiddenModeWarningDialog({super.key});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => const HiddenModeWarningDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(LoyaltyCardsStrings.hiddenWarningTitle),
      content: const Text(LoyaltyCardsStrings.hiddenWarningText),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text(LoyaltyCardsStrings.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text(LoyaltyCardsStrings.hiddenWarningSwitch),
        ),
      ],
    );
  }
}