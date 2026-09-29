import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import 'package:budget_assistant/features/import/domain/entities/import_result.dart';
import 'package:budget_assistant/features/import/domain/entities/import_secrecy_handoff.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../providers/post_import_review_notifier.dart';
import '../providers/import_usecase_providers.dart';
import 'package:budget_assistant/features/recurring_payments/presentation/providers/recurring_detection_providers.dart';
import '../widgets/import_summary_banner.dart';
import '../widgets/smart_detection_tabs.dart';
import '../widgets/duplicates_tab.dart';
import '../widgets/transfers_tab.dart';
import '../widgets/hold_tab.dart';
import '../widgets/categories_tab.dart';
import '../widgets/selected_summary.dart';

/// Экран проверки импорта (ТЗ 6.3.26).
class PostImportReviewScreen extends ConsumerStatefulWidget {
  const PostImportReviewScreen({super.key, this.result});

  final ImportResult? result;

  @override
  ConsumerState<PostImportReviewScreen> createState() =>
      _PostImportReviewScreenState();
}

class _PostImportReviewScreenState
    extends ConsumerState<PostImportReviewScreen> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.result != null) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(postImportReviewProvider.notifier).init(widget.result!);
      });
    }
  }

  Future<void> _confirmCancel() async {
    MotionTokens.medium();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Отменить импорт?'),
        content: const Text(
            'Все распознанные данные будут потеряны'),
        actions: [
          TextButton(
              onPressed: () => ctx.pop(false), child: const Text('Нет')),
          FilledButton(
              onPressed: () => ctx.pop(true), child: const Text('Да')),
        ],
      ),
    );
    if (confirmed == true && mounted) context.pop();
  }

  Future<void> _finalize() async {
    final notifier = ref.read(postImportReviewProvider.notifier);
    final state = ref.read(postImportReviewProvider);
    final userId = ref.read(currentUserIdProvider);

    if (notifier.summary().count == 0) {
      MotionTokens.error();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Выберите хотя бы одну транзакцию')));
      return;
    }

    // Категории: предупреждение о невыбранных.
    final uncategorizedSelected = state.rows
        .where((r) =>
            state.selectedRows.contains(r.rowIndex) &&
            r.assignedCategoryId == null)
        .length;
    if (uncategorizedSelected > 0) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Импортировать без категории?'),
          content: Text(
              '$uncategorizedSelected выбранных транзакций без категории. '
              'Их можно категоризировать позже.'),
          actions: [
            TextButton(
                onPressed: () => ctx.pop(false),
                child: const Text('Назад')),
            FilledButton(
                onPressed: () => ctx.pop(true),
                child: const Text('Импортировать')),
          ],
        ),
      );
      if (proceed != true || !mounted) return;
    }

    final outcome = await notifier.finalize();
    if (outcome == null || !mounted) {
      if (mounted) {
        MotionTokens.error();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Не удалось завершить импорт')));
      }
      return;
    }

    MotionTokens.heavy();
    final result = state.result!;

    // Проверка секретности на созданных транзакциях.
    if (result.options.checkSecrecy && outcome.created.isNotEmpty) {
      try {
        final userId = ref.read(currentUserIdProvider);
        final candidates =
            await ref.read(checkSecrecyModeUseCaseProvider).call(
                  transactions: outcome.created.map((c) => c.row).toList(),
                  targetSpaceId: result.targetSpaceId,
                  userId: userId,
                );
        if (candidates.isNotEmpty && mounted) {
          await context.push(
            '/import/secrets',
            extra: ImportSecrecyHandoff(
              candidates: candidates,
              transactionIdByRowIndex: {
                for (final c in outcome.created) c.row.rowIndex: c.id
              },
            ),
          );
          return;
        }
      } catch (_) {}
    }

    if (!mounted) return;
    final periodDays = result.periodEnd.difference(result.periodStart).inDays;
    // Этап 15.6: автодетект регулярных (долг Этапа 14):
    // опция wizard + период >= 6 мес + app_settings.autoDetectRecurring.
    var recurringTouched = 0;
    if (result.options.detectRecurring && periodDays >= 180) {
      try {
        final autoOn = await ref.read(autoDetectEnabledProvider.future);
        if (autoOn) {
          recurringTouched = await ref
              .read(detectRecurringPaymentsUseCaseProvider)
              .call(userId: userId, spaceId: result.targetSpaceId);
        }
      } catch (_) {}
    }
    if (!mounted) return;
    context.go('/transactions');
    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(SnackBar(
      content: Text('Импортировано ${outcome.created.length} транзакций${recurringTouched > 0 ? '. Регулярных кандидатов: $recurringTouched' : ''}'),
      action: (result.options.detectRecurring && periodDays >= 180)
          ? SnackBarAction(
              label: 'Проверить регулярные',
              onPressed: () =>
                  context.push('/recurring-payments-detection'),
            )
          : null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(postImportReviewProvider);
    final result = state.result;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmCancel();
      },
      child: Scaffold(
        backgroundColor: AppColors.surfaceBackground,
        appBar: AppBar(
          backgroundColor: AppColors.surfaceBackground,
          title: const Text('Проверка импорта'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _confirmCancel,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.visibility_outlined),
              onPressed: () {
                MotionTokens.light();
                ref.read(privacyModeProvider.notifier).toggle();
              },
            ),
          ],
        ),
        body: result == null || !_initialized
            ? EmptyStateWidget(
                icon: Icons.file_open_outlined,
                title: 'Нет данных импорта',
                subtitle: 'Вернитесь к мастеру импорта и загрузите файл',
                primaryAction: EmptyStateAction(
                    label: 'Назад', onPressed: () => context.pop()),
              )
            : Column(
                children: [
                  ImportSummaryBanner(
                    bankName: result.bankName,
                    fileName: result.fileName,
                    totalRows: result.totalRows,
                    periodStart: result.periodStart,
                    periodEnd: result.periodEnd,
                    targetAccountId: result.targetAccountId,
                  ),
                  const SmartDetectionTabs(),
                  Expanded(
                    child: switch (state.activeTab) {
                      0 => const DuplicatesTab(),
                      1 => const TransfersTab(),
                      2 => const HoldTab(),
                      _ => const CategoriesTab(),
                    },
                  ),
                  SelectedSummary(totalCount: result.rows.length),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        OutlinedButton(
                          onPressed: state.isFinalizing
                              ? null
                              : _confirmCancel,
                          child: const Text('Отмена'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                                backgroundColor: AppColors.colorFAB),
                            onPressed: state.isFinalizing
                                ? null
                                : _finalize,
                            child: state.isFinalizing
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white),
                                  )
                                : const Text('Импортировать выбранные'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
