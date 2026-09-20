import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../providers/savings_analytics_providers.dart';
import '../savings_goals_strings.dart';

/// BottomSheet экспорта аналитики (ТЗ 6.3.18.13): XLSX / CSV / PNG.
/// В hidden-режиме экспорт полностью заблокирован.
/// Флоу: формат → генерация файла → диалог «Сохранить / Поделиться»
/// (всё это ПОКА шит открыт и context жив) → закрытие шита → выполнение
/// действия через захваченные messenger/usecase (context уже не нужен).
Future<void> showExportBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    builder: (_) => const ExportBottomSheet(),
  );
}

class ExportBottomSheet extends ConsumerWidget {
  const ExportBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(privacyModeProvider);
    if (mode == BalanceVisibilityMode.hidden) {
      return const SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            SavingsGoalsStrings.exportBlocked,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.grid_on),
            title: const Text(SavingsGoalsStrings.exportXlsx),
            subtitle: const Text(SavingsGoalsStrings.exportXlsxSub),
            onTap: () => _run(context, ref, 'xlsx'),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text(SavingsGoalsStrings.exportCsv),
            subtitle: const Text(SavingsGoalsStrings.exportCsvSub),
            onTap: () => _run(context, ref, 'csv'),
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text(SavingsGoalsStrings.exportPng),
            subtitle: const Text(SavingsGoalsStrings.exportPngSub),
            onTap: () => _run(context, ref, 'png'),
          ),
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text(SavingsGoalsStrings.cancel),
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _run(BuildContext context, WidgetRef ref, String kind) async {
    HapticFeedback.lightImpact();
    final messenger = ScaffoldMessenger.of(context);
    final useCase = ref.read(exportSavingsAnalyticsUseCaseProvider);
    final chartKey = ref.read(chartRepaintBoundaryKeyProvider);
    var sheetPopped = false;
    try {
      final String path;
      if (kind == 'png') {
        path = await useCase.exportPng(chartKey);
      } else {
        final goals = await ref.read(analyticsAllGoalsProvider.future);
        if (kind == 'csv') {
          path = await useCase.exportCsv(goals: goals);
        } else {
          final txns = await ref.read(analyticsSavingsTxnsProvider.future);
          path = await useCase.exportXlsx(goals: goals, transactions: txns);
        }
      }
      if (!context.mounted) return;
      final name = File(path).uri.pathSegments.last;
      final choice = await showDialog<String>(
        context: context,
        builder: (d) => AlertDialog(
          title: Text(name),
          content: const Text(SavingsGoalsStrings.exportChooseDestination),
          actions: [
            FilledButton.icon(
              icon: const Icon(Icons.save_outlined),
              label: const Text(SavingsGoalsStrings.exportSaveToDevice),
              onPressed: () => Navigator.of(d).pop('save'),
            ),
            FilledButton.icon(
              icon: const Icon(Icons.share),
              label: const Text(SavingsGoalsStrings.exportShare),
              onPressed: () => Navigator.of(d).pop('share'),
            ),
            TextButton(
              onPressed: () => Navigator.of(d).pop(),
              child: const Text(SavingsGoalsStrings.cancel),
            ),
          ],
        ),
      );
      if (!context.mounted) return;
      Navigator.of(context).pop();
      sheetPopped = true;
      if (choice == null) return;
      if (choice == 'save') {
        final uri = await useCase.saveToDownloads(path, _mimeFor(kind));
        messenger.showSnackBar(
          SnackBar(content: Text('${SavingsGoalsStrings.exportSavedTo} $uri')),
        );
      } else {
        await useCase.share(path);
      }
      HapticFeedback.mediumImpact();
    } catch (e) {
      HapticFeedback.vibrate();
      if (!sheetPopped && context.mounted) {
        Navigator.of(context).pop();
      }
      messenger.showSnackBar(
        SnackBar(content: Text('${SavingsGoalsStrings.exportFailed}: $e')),
      );
    }
  }

  String _mimeFor(String kind) {
    switch (kind) {
      case 'csv':
        return 'text/csv';
      case 'png':
        return 'image/png';
      default:
        return 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
    }
  }
}