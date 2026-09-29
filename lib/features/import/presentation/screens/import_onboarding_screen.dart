import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import '../providers/import_onboarding_notifier.dart';
import '../widgets/import_progress_indicator.dart';
import '../widgets/import_progress_overlay.dart';
import '../widgets/step1_bank_selection_widget.dart';
import '../widgets/step2_file_upload_widget.dart';
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
  bool _draftDialogShown = false;

  static const Map<int, String> _titles = {
    1: 'Выберите банк',
    2: 'Загрузите файл',
    3: 'Проверьте структуру',
    4: 'Куда импортировать',
  };

  static const Map<String, String> _parseErrors = {
    'too_large': 'Файл больше 50 МБ — выберите файл меньшего размера',
    'not_found': 'Файл не найден — попробуйте ещё раз',
    'parse_error': 'Не удалось прочитать файл — проверьте формат',
  };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowDraftDialog());
  }

  void _maybeShowDraftDialog() {
    if (_draftDialogShown) return;
    final state = ref.read(importOnboardingProvider);
    if (state.draftBankName == null) return;
    _draftDialogShown = true;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Восстановить черновик?'),
        content: Text(
            'Найден незавершённый импорт ${state.draftBankName}. Продолжить с того же места?'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(importOnboardingProvider.notifier).dismissDraft();
              ctx.pop();
            },
            child: const Text('Начать заново'),
          ),
          FilledButton(
            onPressed: () {
              ctx.pop();
              ref.read(importOnboardingProvider.notifier).restoreDraft();
            },
            child: const Text('Восстановить'),
          ),
        ],
      ),
    );
  }

  Future<void> _launch() async {
    final result = await ref.read(importOnboardingProvider.notifier).launchImport();
    if (result != null && mounted) {
      await context.push('/import/review', extra: result);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось подготовить импорт')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(importOnboardingProvider);

    ref.listen(importOnboardingProvider, (prev, next) {
      if (next.snackMessage != null && next.snackMessage != prev?.snackMessage) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(next.snackMessage!)));
        ref.read(importOnboardingProvider.notifier).clearSnack();
      }
      if (next.parseErrorCode != null &&
          next.parseErrorCode != prev?.parseErrorCode) {
        MotionTokens.error();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(_parseErrors[next.parseErrorCode] ??
                'Не удалось прочитать файл')));
        ref.read(importOnboardingProvider.notifier).clearSnack();
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
                  1 => const Step1BankSelectionWidget(),
                  2 => const Step2FileUploadWidget(),
                  3 => const Step3DataPreviewWidget(),
                  _ => const Step4AccountSelectionWidget(),
                },
              ),
            ],
          ),
          if (state.isParsing || state.isLaunching)
            ImportProgressOverlay(
              label: state.isLaunching
                  ? 'Проверяем дубликаты и переводы…'
                  : 'Читаем файл…',
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
                  onPressed: state.isParsing || state.isLaunching
                      ? null
                      : () => ref.read(importOnboardingProvider.notifier).back(),
                  child: const Text('Назад'),
                ),
              const Spacer(),
              if (state.step < 4)
                FilledButton(
                  onPressed: state.canNext && !state.isParsing
                      ? () => ref.read(importOnboardingProvider.notifier).next()
                      : null,
                  child: const Text('Далее'),
                )
              else
                FilledButton(
                  onPressed: state.canNext &&
                          !state.isParsing &&
                          !state.isLaunching
                      ? _launch
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