import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../providers/savings_analytics_providers.dart';
import '../savings_goals_strings.dart';

/// BottomSheet экспорта аналитики (ТЗ 6.3.18.13): XLSX / CSV / PNG.
/// В hidden-режиме экспорт полностью заблокирован.
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
            onTap: () => _run(ref, 'xlsx'),
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text(SavingsGoalsStrings.exportCsv),
            subtitle: const Text(SavingsGoalsStrings.exportCsvSub),
            onTap: () => _run(ref, 'csv'),
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text(SavingsGoalsStrings.exportPng),
            subtitle: const Text(SavingsGoalsStrings.exportPngSub),
            onTap: () => _run(ref, 'png'),
          ),
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text(SavingsGoalsStrings.exportCancel),
            onTap: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Future<void> _run(WidgetRef ref, String kind) async {
    HapticFeedback.lightImpact();
    final context = ref.context;
    Navigator.of(context).pop();
    final messenger = ScaffoldMessenger.of(context);
    try {
      final useCase = ref.read(exportSavingsAnalyticsUseCaseProvider);
      final String path;
      if (kind == 'png') {
        path = await useCase.exportPng(ref.read(chartRepaintBoundaryKeyProvider));
      } else {
        final goals = await ref.read(analyticsAllGoalsProvider.future);
        if (kind == 'xlsx') {
          final txns = await ref.read(analyticsSavingsTxnsProvider.future);
          path = await useCase.exportXlsx(goals: goals, transactions: txns);
        } else {
          path = await useCase.exportCsv(goals: goals);
        }
      }
      await useCase.share(path, SavingsGoalsStrings.exportShareText);
      HapticFeedback.mediumImpact();
      messenger.showSnackBar(
        const SnackBar(content: Text(SavingsGoalsStrings.exportSuccess)),
      );
    } catch (e) {
      HapticFeedback.vibrate();
      messenger.showSnackBar(
        SnackBar(content: Text('${SavingsGoalsStrings.exportFailed}: $e')),
      );
    }
  }
}