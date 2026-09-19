import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/usecases/export_savings_analytics_usecase.dart';
import '../providers/savings_analytics_providers.dart';
import '../savings_goals_strings.dart';

/// BottomSheet экспорта аналитики (ТЗ 6.3.18.13): XLSX / CSV / PNG.
/// В hidden-режиме экспорт полностью заблокирован.
class ExportBottomSheet extends ConsumerWidget {
  const ExportBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(privacyModeProvider);
    if (mode == BalanceVisibilityMode.hidden) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
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
            title: const Text('Excel (.xlsx)'),
            subtitle: const Text('Цели + пополнения (2 листа)'),
            onTap: () => _run(context, ref, 'xlsx'),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('CSV (.csv)'),
            subtitle: const Text('Таблица целей'),
            onTap: () => _run(context, ref, 'csv'),
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('PNG (график)'),
            subtitle: const Text('Скриншот графика накопления'),
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
    Navigator.of(context).pop();
    final messenger = ScaffoldMessenger.of(context);
    final usecase = ExportSavingsAnalyticsUseCase();
    try {
      String path;
      if (kind == 'png') {
        path = await usecase.exportPng();
      } else {
        final goals = await ref.read(analyticsAllGoalsProvider.future);
        if (kind == 'xlsx') {
          final tx = await ref.read(analyticsSavingsTxnsProvider.future);
          path = await usecase.exportXlsx(goals: goals, transactions: tx);
        } else {
          path = await usecase.exportCsv(goals: goals);
        }
      }
      await usecase.share(path);
      HapticFeedback.mediumImpact();
    } catch (e) {
      HapticFeedback.vibrate();
      messenger.showSnackBar(SnackBar(content: Text('${SavingsGoalsStrings.operationFailed}: $e')));
    }
  }
}

Future<void> showExportBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    builder: (_) => const ExportBottomSheet(),
  );
}