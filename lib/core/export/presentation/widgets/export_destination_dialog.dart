// lib/core/export/presentation/widgets/export_destination_dialog.dart
// Этап 21 (прецедент 12.8): диалог назначения экспорта —
// «Сохранить в память» (MediaStore) или «Поделиться» (Share Sheet).
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:budget_assistant/core/export/domain/usecases/save_to_downloads_usecase.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';

Future<void> showExportDestinationDialog(
  BuildContext context, {
  required String path,
  required String shareText,
  required String mime,
}) async {
  final messenger = ScaffoldMessenger.of(context);
  final save = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surfaceCard,
      title: const Text('📁 Файл готов'),
      content: const Text(
        'Сохранить в память устройства (Загрузки) '
        'или поделиться через системное меню?',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Поделиться'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Сохранить в память'),
        ),
      ],
    ),
  );
  if (save == null) return;
  try {
    if (save) {
      await const SaveToDownloadsUseCase().call(path: path, mime: mime);
      messenger.showSnackBar(
        const SnackBar(content: Text('✅ Файл сохранён в Загрузки')),
      );
    } else {
      await SharePlus.instance.share(
        ShareParams(files: [XFile(path)], text: shareText),
      );
    }
  } catch (e) {
    messenger.showSnackBar(SnackBar(content: Text('❌ Ошибка: $e')));
  }
}