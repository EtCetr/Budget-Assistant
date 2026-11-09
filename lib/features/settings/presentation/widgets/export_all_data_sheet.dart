// lib/features/settings/presentation/widgets/export_all_data_sheet.dart
// Этап 21 (ТЗ 6.9.0.2): пайплайн экспорта всех данных:
// privacy-check -> PIN (require_pin_for_sensitive) -> usecase -> назначение.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/export/presentation/widgets/export_destination_dialog.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import 'package:budget_assistant/features/settings/presentation/providers/settings_providers.dart';

class ExportAllDataFlow {
  const ExportAllDataFlow._();

  static Future<void> run(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final mode = ref.read(privacyModeProvider);
    if (mode == BalanceVisibilityMode.hidden) {
      messenger.showSnackBar(
        const SnackBar(content: Text('🔒 Экспорт недоступен в скрытом режиме')),
      );
      return;
    }
    final s = ref.read(appSettingsRowProvider).value;
    if (s != null && s.requirePinForSensitive && s.enablePinCode) {
      final ok = await context.push('/security/pin-entry?mode=verify');
      if (ok != true || !context.mounted) return;
    }
    HapticFeedback.mediumImpact();
    messenger.showSnackBar(
      const SnackBar(content: Text('⏳ Генерируем файл...')),
    );
    try {
      final path = await ref.read(exportAllDataUseCaseProvider).call();
      if (!context.mounted) return;
      await showExportDestinationDialog(
        context,
        path: path,
        shareText: '📊 Мои финансовые данные из Budget Assistant',
        mime: 'application/vnd.openxmlformats-officedocument'
            '.spreadsheetml.sheet',
      );
    } catch (e) {
      if (context.mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('❌ Ошибка экспорта: $e')),
        );
      }
    }
  }
}