import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import '../../domain/entities/loyalty_card.dart';
import '../loyalty_cards_strings.dart';
import 'loyalty_cards_category_ui.dart';

/// Редакторы формы: тип кода, категория, цвет, эмодзи, видимость.
abstract final class LoyaltyCardEditors {
  static String typeLabel(BarcodeType t) => switch (t) {
        BarcodeType.ean13 => LoyaltyCardsStrings.typeEan13,
        BarcodeType.code128 => LoyaltyCardsStrings.typeCode128,
        BarcodeType.qr => LoyaltyCardsStrings.typeQr,
        BarcodeType.pdf417 => LoyaltyCardsStrings.typePdf417,
        BarcodeType.manual => LoyaltyCardsStrings.typeManual,
      };

  static const List<String> emojiPresets = [
    '💳', '🛒', '', '👕', '⛽', '🎬',
    '🍔', '', '🐾', '📚', '️', '🎁',
  ];
}

class BarcodeTypeChips extends StatelessWidget {
  const BarcodeTypeChips({super.key, required this.selected, required this.onChanged});

  final BarcodeType selected;
  final ValueChanged<BarcodeType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.spacing8,
      children: [
        for (final t in BarcodeType.values)
          ChoiceChip(
            label: Text(LoyaltyCardEditors.typeLabel(t)),
            selected: selected == t,
            selectedColor: AppColors.colorFAB,
            labelStyle: TextStyle(
              color: selected == t ? Colors.white : AppColors.textPrimary,
            ),
            backgroundColor: AppColors.surfaceCard,
            side: const BorderSide(color: AppColors.borderDivider),
            onSelected: (_) {
              MotionTokens.selection();
              onChanged(t);
            },
          ),
      ],
    );
  }
}

class CategoryChips extends StatelessWidget {
  const CategoryChips({super.key, required this.selected, required this.onChanged});

  final LoyaltyCardCategory selected;
  final ValueChanged<LoyaltyCardCategory> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.spacing8,
      children: [
        for (final c in LoyaltyCardCategory.values)
          ChoiceChip(
            label: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LoyaltyCardCategoryUi.icon(c), size: 16),
                const SizedBox(width: AppSpacing.spacing4),
                Text(LoyaltyCardCategoryUi.label(c)),
              ],
            ),
            selected: selected == c,
            selectedColor: LoyaltyCardCategoryUi.color(c),
            showCheckmark: false,
            labelStyle: TextStyle(
              color: selected == c ? Colors.white : AppColors.textPrimary,
            ),
            backgroundColor: AppColors.surfaceCard,
            side: const BorderSide(color: AppColors.borderDivider),
            onSelected: (_) {
              MotionTokens.selection();
              onChanged(c);
            },
          ),
      ],
    );
  }
}

class BrandColorGrid extends StatelessWidget {
  const BrandColorGrid({super.key, required this.selected, required this.onChanged});

  final String? selected;
  final ValueChanged<String?> onChanged;

  static const List<String> presets = [
    '#E30613', '#FF0000', '#FF6600', '#0057A6',
    '#E60000', '#22B246', '#00A3E1', '#E4002B',
    '#000000', '#E50010', '#E31E24', '#0079C2',
  ];

  Color _parse(String hex) {
    final v = int.tryParse(hex.substring(1), radix: 16);
    return v == null ? AppColors.surfaceCard : Color(0xFF000000 | v);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.spacing8,
      runSpacing: AppSpacing.spacing8,
      children: [
        _swatch(null),
        for (final hex in presets) _swatch(hex),
      ],
    );
  }

  Widget _swatch(String? hex) {
    final active = selected == hex;
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      onTap: () {
        MotionTokens.selection();
        onChanged(hex);
      },
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: hex == null ? AppColors.surfaceElevated : _parse(hex),
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          border: Border.all(
            color: active ? AppColors.colorFAB : AppColors.borderDivider,
            width: active ? 2 : 1,
          ),
        ),
        child: hex == null
            ? const Icon(Icons.block, size: 16, color: AppColors.textSecondary)
            : (active
                ? const Icon(Icons.check, size: 16, color: Colors.white)
                : null),
      ),
    );
  }
}

class EmojiGrid extends StatelessWidget {
  const EmojiGrid({super.key, required this.selected, required this.onChanged});

  final String? selected;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.spacing8,
      runSpacing: AppSpacing.spacing8,
      children: [
        for (final e in LoyaltyCardEditors.emojiPresets)
          InkWell(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            onTap: () {
              MotionTokens.selection();
              onChanged(selected == e ? null : e);
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                  color: selected == e
                      ? AppColors.colorFAB
                      : AppColors.borderDivider,
                  width: selected == e ? 2 : 1,
                ),
              ),
              child: Center(
                child: Text(e, style: const TextStyle(fontSize: 20)),
              ),
            ),
          ),
      ],
    );
  }
}

class VisibilityToggle extends StatelessWidget {
  const VisibilityToggle({
    super.key,
    required this.visibility,
    required this.familyAvailable,
    required this.onChanged,
  });

  /// 'personal' | 'family'
  final String visibility;
  final bool familyAvailable;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              MotionTokens.selection();
              onChanged('personal');
            },
            style: OutlinedButton.styleFrom(
              backgroundColor: visibility == 'personal'
                  ? AppColors.colorTransfer
                  : AppColors.surfaceCard,
              foregroundColor: visibility == 'personal'
                  ? Colors.white
                  : AppColors.textPrimary,
              side: const BorderSide(color: AppColors.borderDivider),
            ),
            icon: const Icon(Icons.lock_outline, size: 18),
            label: const Text(LoyaltyCardsStrings.visibilityPersonal),
          ),
        ),
        const SizedBox(width: AppSpacing.spacing8),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: familyAvailable
                ? () {
                    MotionTokens.selection();
                    onChanged('family');
                  }
                : null,
            style: OutlinedButton.styleFrom(
              backgroundColor: visibility == 'family'
                  ? AppColors.colorIncome
                  : AppColors.surfaceCard,
              foregroundColor: visibility == 'family'
                  ? Colors.white
                  : AppColors.textPrimary,
              side: const BorderSide(color: AppColors.borderDivider),
            ),
            icon: const Icon(Icons.family_restroom, size: 18),
            label: const Text(LoyaltyCardsStrings.visibilityFamily),
          ),
        ),
      ],
    );
  }
}