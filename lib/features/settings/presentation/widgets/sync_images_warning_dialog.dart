// lib/features/settings/presentation/widgets/sync_images_warning_dialog.dart
// Этап 21 (ТЗ 6.3.38.6): warning при включении sync_images_to_cloud.
import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';

Future<bool> showSyncImagesWarningDialog(BuildContext context) async {
  final res = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surfaceCard,
      title: const Text('⚠️ Синхронизация фото чеков'),
      content: const Text(
        'Загрузка изображений в облако увеличит расход трафика и памяти. '
        'Для просмотра фото на других устройствах потребуется полная '
        'загрузка и расшифровка .enc файла. '
        'Рекомендуется только при наличии безлимитного интернета.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Отмена'),
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