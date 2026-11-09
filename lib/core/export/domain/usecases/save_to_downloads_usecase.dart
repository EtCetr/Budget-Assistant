// lib/core/export/domain/usecases/save_to_downloads_usecase.dart
// Этап 21 (ТЗ 6.9.6): нативное сохранение в Downloads/BudgetAssistant
// через MediaStore (MethodChannel budget_assistant/clock, прецедент 12.8).
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:budget_assistant/core/logger.dart';

class SaveToDownloadsUseCase {
  const SaveToDownloadsUseCase();

  Future<String> call({required String path, required String mime}) async {
    try {
      final file = File(path);
      final name = file.uri.pathSegments.last;
      final bytes = await file.readAsBytes();
      const channel = MethodChannel('budget_assistant/clock');
      final uri = await channel.invokeMethod<String>(
        'saveToDownloads',
        {'fileName': name, 'bytes': bytes, 'mime': mime},
      );
      return uri ?? 'Downloads/BudgetAssistant/$name';
    } catch (e, st) {
      AppLogger.e('SaveToDownloads failed', e, st);
      rethrow;
    }
  }
}