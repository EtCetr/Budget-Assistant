// lib/features/settings/presentation/widgets/settings_dropdown_item.dart
// Этап 21 (ТЗ 6.3.38): строка-дропдаун + универсальный BottomSheet опций.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';

class SettingsDropdownOption<T> {
  const SettingsDropdownOption({required this.label, required this.value});

  final String label;
  final T value;
}

class SettingsDropdownItem extends StatelessWidget {
  const SettingsDropdownItem({
    super.key,
    required this.icon,
    required this.label,
    required this.valueLabel,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String valueLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              valueLabel,
              style: const TextStyle(
                color: AppColors.colorTransfer,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

/// BottomSheet выбора опции (галочка на текущем значении).
Future<T?> showSettingsOptionsSheet<T>(
  BuildContext context, {
  required String title,
  required List<SettingsDropdownOption<T>> options,
  required T current,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: AppColors.surfaceCard,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          for (final o in options)
            InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.pop(ctx, o.value);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        o.label,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (o.value == current)
                      const Icon(
                        Icons.check,
                        color: AppColors.colorTransfer,
                      ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}