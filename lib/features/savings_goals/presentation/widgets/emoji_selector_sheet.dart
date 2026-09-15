import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../savings_goals_strings.dart';

/// Палитра эмодзи для визуальной идентификации цели (ТЗ 6.3.17.3).
const List<String> kSavingsEmojiPalette = [
  '✈️', '🎯', '🏖️', '🏠', '🚗', '🎓', '💍', '👶',
  '🎁', '📱', '💻', '🎮', '🏋️', '⚽', '🎸', '📚',
  '🐶', '🐱', '🌴', '⛷️', '🚴', '🧘', '💼', '📈',
  '💎', '👗', '🍽️', '☕', '🎂', '💊', '🩺', '✂️',
  '🧳', '🛋️', '🖼️', '🎨', '📷', '🎬', '🎤', '🌟',
  '🔥', '💪', '🧠', '❤️', '🍀', '🎉', '🪙', '🏦',
];

/// BottomSheet с палитрой эмодзи.
Future<void> showEmojiSelectorSheet(
  BuildContext context, {
  required String selected,
  required ValueChanged<String> onSelected,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (_) => _EmojiSelectorSheet(
      selected: selected,
      onSelected: onSelected,
    ),
  );
}

class _EmojiSelectorSheet extends StatelessWidget {
  const _EmojiSelectorSheet({
    required this.selected,
    required this.onSelected,
  });

  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              SavingsGoalsStrings.emojiTooltip,
              style: theme.textTheme.titleMedium,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.block),
            title: const Text(SavingsGoalsStrings.emojiNone),
            selected: selected.isEmpty,
            onTap: () {
              HapticFeedback.selectionClick();
              onSelected('');
              Navigator.of(context).pop();
            },
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: kSavingsEmojiPalette.length,
              itemBuilder: (context, index) {
                final emoji = kSavingsEmojiPalette[index];
                return InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    onSelected(emoji);
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected == emoji
                          ? theme.colorScheme.surfaceContainerHighest
                          : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 24)),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}