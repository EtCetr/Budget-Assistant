// lib/features/security/presentation/widgets/security_dialogs.dart
// Этап 21 (ТЗ 6.3.28): warning-диалоги и BottomSheet-выборы экрана безопасности.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';

Future<void> showShakeInfoDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surfaceCard,
      title: const Text('📱 Как работает встряхивание?'),
      content: const Text(
        'Встряхните телефон, чтобы мгновенно скрыть все финансовые данные '
        '(балансы, суммы транзакций, имена). Данные вернутся через 30 секунд '
        'или после повторного встряхивания.',
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Понятно'),
        ),
      ],
    ),
  );
}

Future<void> showSecrecyInfoDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surfaceCard,
      title: const Text('🎁 Как работает режим секретности?'),
      content: const Text(
        'Транзакции за N дней до праздника будут автоматически помечаться как '
        '«Скрытые (Праздник)». Они показываются как «🎁 Скрытая операция» в '
        'истории, но суммы учитываются в балансе. После даты праздника '
        'транзакции автоматически открываются.',
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Понятно'),
        ),
      ],
    ),
  );
}

Future<bool> showFlagSecureOffWarning(BuildContext context) async {
  final res = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surfaceCard,
      title: const Text('⚠️ Отключить защиту от скриншотов?'),
      content: const Text(
        'Без FLAG_SECURE ваши финансовые данные могут быть зафиксированы через '
        'скриншоты, запись экрана или зловредные приложения. Рекомендуется '
        'оставить включённым.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Оставить включённым'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Всё равно отключить'),
        ),
      ],
    ),
  );
  return res == true;
}

Future<bool> showLockScreenOnWarning(BuildContext context) async {
  final res = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surfaceCard,
      title: const Text('⚠️ Включить балансы на Lock screen?'),
      content: const Text(
        'Финансовые данные будут видны на заблокированном экране. Убедитесь, '
        'что ваш телефон защищён надёжным PIN/отпечатком.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Отменить'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Включить'),
        ),
      ],
    ),
  );
  return res == true;
}

/// BottomSheet таймаута автоскрытия (ТЗ 6.3.28.6): 0/10/30/60/300 сек.
Future<int?> showAutoHideTimeoutSheet(BuildContext context, int current) {
  const options = <MapEntry<int, String>>[
    MapEntry(0, 'Выключено'),
    MapEntry(10, '10 секунд'),
    MapEntry(30, '30 секунд'),
    MapEntry(60, '1 минута'),
    MapEntry(300, '5 минут'),
  ];
  return showModalBottomSheet<int>(
    context: context,
    backgroundColor: AppColors.surfaceCard,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Автоматически скрывать через',
              style: TextStyle(
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
                Navigator.pop(ctx, o.key);
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
                        o.value,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (o.key == current)
                      const Icon(Icons.check, color: AppColors.colorTransfer),
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

/// BottomSheet дней секретности (ТЗ 6.3.28.13): 3/7/14/30 + настраиваемый.
Future<int?> showSecrecyDaysSheet(BuildContext context, int current) async {
  const presets = <int>[3, 7, 14, 30];
  final res = await showModalBottomSheet<int>(
    context: context,
    backgroundColor: AppColors.surfaceCard,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Дней до праздника',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          for (final d in presets)
            InkWell(
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.pop(ctx, d);
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
                        '$d дней',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (d == current)
                      const Icon(Icons.check, color: AppColors.colorTransfer),
                  ],
                ),
              ),
            ),
          InkWell(
            onTap: () {
              HapticFeedback.selectionClick();
              Navigator.pop(ctx, -1);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Настраиваемый (1-90)',
                      style: TextStyle(
                        color: AppColors.colorTransfer,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  Icon(Icons.edit_outlined, color: AppColors.colorTransfer),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
  if (res == null || res != -1) return res;
  if (!context.mounted) return null;
  return _customDaysDialog(context, current);
}

Future<int?> _customDaysDialog(BuildContext context, int current) {
  final controller = TextEditingController(text: '$current');
  return showDialog<int>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surfaceCard,
      title: const Text('Настраиваемый период'),
      content: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: 'Дней (1-90)'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: () {
            final v = int.tryParse(controller.text.trim());
            if (v == null || v < 1 || v > 90) return;
            Navigator.pop(ctx, v);
          },
          child: const Text('Сохранить'),
        ),
      ],
    ),
  );
}