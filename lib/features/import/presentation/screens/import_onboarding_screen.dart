import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import '../providers/import_onboarding_notifier.dart';
import '../widgets/import_progress_indicator.dart';
import '../widgets/import_progress_overlay.dart';
import '../widgets/step1_file_upload_widget.dart';
import '../widgets/step2_bank_detection_widget.dart';
import '../widgets/step3_data_preview_widget.dart';
import '../widgets/step4_account_selection_widget.dart';

/// Wizard импорта выписки: 4 шага (ТЗ 6.3.25).
class ImportOnboardingScreen extends ConsumerStatefulWidget {
  const ImportOnboardingScreen({super.key});

  @override
  ConsumerState<ImportOnboardingScreen> createState() =>
      _ImportOnboardingScreenState();
}

class _ImportOnboardingScreenState extends ConsumerState<ImportOnboardingScreen> {
  static const Map<int, String> _titles = {
    1: 'Загрузите файл',
    2: 'Определение банка',
    3: 'Проверьте структуру',
    4: 'Куда импортировать',
  };

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(importOnboardingProvider);

    ref.listen(importOnboardingProvider, (prev, next) {
      if (next.snackMessage != null && next.snackMessage != prev?.snackMessage) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.snackMessage!)));
      }
    });

    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        title: Text(_titles[state.step] ?? 'Импорт'),
        backgroundColor: AppColors.surfaceBackground,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              ImportProgressIndicator(step: state.step),
              Expanded(
                child: switch (state.step) {
                  1 => const Step1FileUploadWidget(),
                  2 => const Step2BankDetectionWidget(),
                  3 => const Step3DataPreviewWidget(),
                  _ => const Step4AccountSelectionWidget(),
                },
              ),
            ],
          ),
          if (state.isProcessing)
            ImportProgressOverlay(
              label: state.step == 1
                  ? 'Читаем файл…'
                  : state.step == 2
                      ? 'Определяем банк…'
                      : 'Парсим данные…',
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              if (state.step > 1)
                OutlinedButton(
                  onPressed: state.isProcessing
                      ? null
                      : () => ref.read(importOnboardingProvider.notifier).back(),
                  child: const Text('Назад'),
                ),
              const Spacer(),
              if (state.step < 4)
                FilledButton(
                  onPressed: state.canNext && !state.isProcessing
                      ? () {
                          if (state.step == 2) {
                            ref.read(importOnboardingProvider.notifier).parseFileWithConfig();
                          }
                          ref.read(importOnboardingProvider.notifier).next();
                        }
                      : null,
                  child: const Text('Далее'),
                )
              else
                FilledButton(
                  onPressed: state.canNext && !state.isProcessing
                      ? () async {
                          final result = await ref
                              .read(importOnboardingProvider.notifier)
                              .launchImport();
                          if (result != null && context.mounted) {
                            await context.push('/import/review', extra: result);
                          }
                        }
                      : null,
                  child: const Text('Запустить импорт'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}