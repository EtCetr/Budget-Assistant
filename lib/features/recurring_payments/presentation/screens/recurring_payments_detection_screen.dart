import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import 'package:budget_assistant/core/widgets/offline_error_card.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../../reminders/presentation/providers/reminders_providers.dart';
import '../../domain/entities/recurring_transaction.dart';
import '../../domain/usecases/group_recurring_candidates_usecase.dart';
import '../providers/recurring_detection_providers.dart';
import '../providers/recurring_repository_providers.dart';
import '../recurring_detection_strings.dart';

/// Экран детекции регулярных платежей (ТЗ 6.3.9): инфо-баннер, сводка,
/// группы по системным категориям с чекбоксами и confidence-бейджами,
/// sticky-бар «Отклонить все / Добавить выбранные (N)», confirm-диалог
/// с опцией напоминаний (1/3/7 дней), undo-snackbar на отклонение.
class RecurringPaymentsDetectionScreen extends ConsumerStatefulWidget {
  const RecurringPaymentsDetectionScreen({super.key});

  @override
  ConsumerState<RecurringPaymentsDetectionScreen> createState() =>
      _RecurringPaymentsDetectionScreenState();
}

class _AddConfirmResult {
  const _AddConfirmResult({
    required this.createReminders,
    required this.advanceDays,
  });
  final bool createReminders;
  final int advanceDays;
}

class _RecurringPaymentsDetectionScreenState
    extends ConsumerState<RecurringPaymentsDetectionScreen> {
  bool _detecting = false;
  bool _detectRanOnce = false;
  bool _dismissedOnce = false;

  static String _key(RecurringTransaction c) =>
      '${c.merchantNameNormalized}|${c.averageAmountBucket}';

  Future<void> _runDetect() async {
    if (_detecting) return;
    setState(() => _detecting = true);
    try {
      await ref.read(detectRecurringPaymentsUseCaseProvider)(
        userId: ref.read(currentUserIdProvider),
        spaceId: ref.read(currentSpaceIdProvider),
      );
      ref.invalidate(pendingCandidatesProvider);
      ref.invalidate(activeCandidateKeysProvider);
    } catch (_) {
      // Ошибка анализа: стрим покажет error-состояние с Retry.
    } finally {
      if (mounted) {
        setState(() {
          _detecting = false;
          _detectRanOnce = true;
        });
      }
    }
  }

  Future<void> _dismissAll() async {
    MotionTokens.medium();
    final userId = ref.read(currentUserIdProvider);
    final result =
        await ref.read(dismissAllCandidatesUseCaseProvider)(userId);
    if (result.deleted.isEmpty) return;
    ref.read(selectedCandidatesProvider.notifier).clear();
    setState(() => _dismissedOnce = true);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(result.autoDetectDisabled
            ? RecurringDetectionStrings.snackbarAutoDetectOff
            : RecurringDetectionStrings.snackbarDismissed),
        action: SnackBarAction(
          label: RecurringDetectionStrings.undo,
          onPressed: () async {
            MotionTokens.medium();
            await ref
                .read(restoreDismissedCandidatesUseCaseProvider)(
                    userId, result.deleted);
            ref.invalidate(pendingCandidatesProvider);
          },
        ),
      ),
    );
  }

  Future<void> _addSelected() async {
    final pending = ref.read(pendingCandidatesProvider).value ?? const [];
    final selectedIds = ref.read(selectedCandidatesProvider);
    final chosen = pending.where((c) => selectedIds.contains(c.id)).toList();
    if (chosen.isEmpty) return;
    MotionTokens.medium();
    final result = await showDialog<_AddConfirmResult>(
      context: context,
      builder: (d) => _AddConfirmDialog(count: chosen.length),
    );
    if (result == null || !mounted) return;
    setState(() => _detecting = true);
    int added = 0;
    try {
      for (final c in chosen) {
        await ref.read(addRecurringPaymentUseCaseProvider)(c);
        if (result.createReminders) {
          final refreshed = await ref
              .read(recurringTransactionsRepositoryProvider)
              .getByKey(
                userId: c.userId,
                merchantNormalized: c.merchantNameNormalized,
                amountBucket: c.averageAmountBucket,
              );
          if (refreshed != null) {
            await ref.read(createReminderFromRecurringUseCaseProvider)(
              recurring: refreshed,
              advanceDays: result.advanceDays,
            );
          }
        }
        added++;
      }
      if (result.createReminders && added > 0) {
        await ref.read(scheduleRemindersUseCaseProvider)(
          ref.read(currentUserIdProvider),
        );
      }
    } catch (_) {
      MotionTokens.error();
    } finally {
      if (mounted) setState(() => _detecting = false);
    }
    ref.read(selectedCandidatesProvider.notifier).clear();
    ref.invalidate(pendingCandidatesProvider);
    ref.invalidate(activeCandidateKeysProvider);
    if (!mounted) return;
    MotionTokens.medium();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${RecurringDetectionStrings.snackbarAddedPrefix}$added'
          '${RecurringDetectionStrings.snackbarAddedSuffix}',
        ),
      ),
    );
  }

  void _showHelp() {
    showDialog<void>(
      context: context,
      builder: (d) => AlertDialog(
        title: const Text(RecurringDetectionStrings.helpTitle),
        content: const Text(RecurringDetectionStrings.helpText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(d).pop(),
            child: const Text(RecurringDetectionStrings.emptyClose),
          ),
        ],
      ),
    );
  }

  String _groupLabel(String key) {
    return switch (key) {
      'subscriptions' => RecurringDetectionStrings.groupSubscriptions,
      'utilities' => RecurringDetectionStrings.groupUtilities,
      'transport' => RecurringDetectionStrings.groupTransport,
      'cloud' => RecurringDetectionStrings.groupCloud,
      'games' => RecurringDetectionStrings.groupGames,
      _ => RecurringDetectionStrings.groupOther,
    };
  }

  Widget _statChip(String label, Color color) {
    return Text(
      label,
      style: TextStyle(color: color, fontWeight: FontWeight.w600),
    );
  }

  Widget _groupHeader(
    BuildContext context,
    RecurringCandidateGroup group,
    Set<String> selected,
    Set<String> activeKeys,
  ) {
    final selectable = group.candidates
        .where((c) => !activeKeys.contains(_key(c)))
        .map((c) => c.id)
        .toList();
    final allSelected =
        selectable.isNotEmpty && selectable.every((id) => selected.contains(id));
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.spacing8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${group.emoji} ${_groupLabel(group.key)} '
              '(${group.candidates.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (selectable.isNotEmpty)
            Checkbox(
              value: allSelected,
              onChanged: (v) {
                MotionTokens.selection();
                ref
                    .read(selectedCandidatesProvider.notifier)
                    .setMany(selectable, v ?? false);
              },
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingAsync = ref.watch(pendingCandidatesProvider);
    final activeKeys =
        ref.watch(activeCandidateKeysProvider).value ?? const <String>{};
    final selected = ref.watch(selectedCandidatesProvider);
    final stats = ref.watch(detectionStatsProvider);
    final groups = ref.watch(groupedCandidatesProvider);
    final bannerDismissed =
        ref.watch(infoBannerDismissedProvider).value ?? false;
    return Scaffold(
      appBar: AppBar(
        title: const Text(RecurringDetectionStrings.screenTitle),
        actions: [
          IconButton(
            tooltip: RecurringDetectionStrings.helpTitle,
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelp,
          ),
          IconButton(
            tooltip: RecurringDetectionStrings.refreshTooltip,
            icon: const Icon(Icons.refresh),
            onPressed: _runDetect,
          ),
        ],
      ),
      bottomNavigationBar: pendingAsync.whenOrNull(
        data: (pending) => pending.isEmpty
            ? null
            : SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.spacing16),
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceCard,
                    border: Border(
                      top: BorderSide(color: AppColors.borderDivider),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.colorExpense,
                          ),
                          onPressed: _dismissAll,
                          child: const Text(
                              RecurringDetectionStrings.rejectAll),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.spacing8),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.colorFAB,
                          ),
                          onPressed:
                              stats.selected == 0 ? null : _addSelected,
                          child: Text(
                            '${RecurringDetectionStrings.addSelectedPrefix}'
                            ' (${stats.selected})',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
      body: _detecting
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: AppSpacing.spacing16),
                  Text(RecurringDetectionStrings.analyzing),
                ],
              ),
            )
          : pendingAsync.when(
              loading: () => ListView(
                padding: const EdgeInsets.all(16),
                children: const [
                  SkeletonShimmer(height: 60),
                  SizedBox(height: 12),
                  SkeletonShimmer(height: 90),
                  SizedBox(height: 12),
                  SkeletonShimmer(height: 90),
                ],
              ),
              error: (e, _) => Center(
                child: OfflineErrorCard(
                  message: RecurringDetectionStrings.loadingError,
                  retryLabel: RecurringDetectionStrings.retry,
                  onRetry: () => ref.invalidate(pendingCandidatesProvider),
                ),
              ),
              data: (pending) {
                if (pending.isEmpty) {
                  if (!_detectRanOnce && !_dismissedOnce) {
                    return EmptyStateWidget(
                      icon: Icons.radar,
                      title: RecurringDetectionStrings.emptyTitle,
                      subtitle: RecurringDetectionStrings.emptySubtitle,
                      primaryAction: EmptyStateAction(
                        label: RecurringDetectionStrings.emptyRunAnalysis,
                        onPressed: _runDetect,
                      ),
                      secondaryAction: EmptyStateAction(
                        label: RecurringDetectionStrings.emptyClose,
                        isPrimary: false,
                        onPressed: () => context.pop(),
                      ),
                    );
                  }
                  if (_dismissedOnce) {
                    return EmptyStateWidget(
                      icon: Icons.inbox_outlined,
                      title: RecurringDetectionStrings.emptyTitle,
                      subtitle: RecurringDetectionStrings.emptySubtitle,
                      secondaryAction: EmptyStateAction(
                        label: RecurringDetectionStrings.emptyClose,
                        isPrimary: false,
                        onPressed: () => context.pop(),
                      ),
                    );
                  }
                  return EmptyStateWidget(
                    icon: Icons.task_alt,
                    title: RecurringDetectionStrings.allAddedTitle,
                    subtitle: RecurringDetectionStrings.allAddedSubtitle,
                    secondaryAction: EmptyStateAction(
                      label: RecurringDetectionStrings.emptyClose,
                      isPrimary: false,
                      onPressed: () => context.pop(),
                    ),
                  );
                }
                return ListView(
                  padding: const EdgeInsets.all(AppSpacing.spacing16),
                  children: [
                    if (!bannerDismissed)
                      Card(
                        color: AppColors.colorTransfer.withValues(alpha: 0.12),
                        child: ListTile(
                          leading: const Icon(Icons.auto_awesome,
                              color: AppColors.colorTransfer),
                          title: const Text(
                            RecurringDetectionStrings.infoBannerText,
                            style: TextStyle(fontSize: 13),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close, size: 18),
                            onPressed: () {
                              ref.read(dismissInfoBannerProvider)();
                              ref.invalidate(infoBannerDismissedProvider);
                            },
                          ),
                        ),
                      ),
                    const SizedBox(height: AppSpacing.spacing8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _statChip(
                          '${RecurringDetectionStrings.statsFound}: '
                          '${stats.found}',
                          AppColors.textPrimary,
                        ),
                        _statChip(
                          '${RecurringDetectionStrings.statsSelected}: '
                          '${stats.selected}',
                          AppColors.colorIncome,
                        ),
                        _statChip(
                          '${RecurringDetectionStrings.statsSkipped}: '
                          '${stats.skipped}',
                          AppColors.textSecondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.spacing16),
                    for (final group in groups) ...[
                      _groupHeader(context, group, selected, activeKeys),
                      for (final c in group.candidates)
                        _CandidateCard(
                          candidate: c,
                          alreadyAdded: activeKeys.contains(_key(c)),
                        ),
                      const SizedBox(height: AppSpacing.spacing16),
                    ],
                    const SizedBox(height: AppSpacing.spacing32),
                  ],
                );
              },
            ),
    );
  }
}

/// Карточка кандидата (ТЗ 6.3.9.6): чекбокс, мерчант, мета-строка,
/// confidence-бейдж, состояние «уже добавлено» (disabled).
class _CandidateCard extends ConsumerWidget {
  const _CandidateCard({
    required this.candidate,
    required this.alreadyAdded,
  });

  final RecurringTransaction candidate;
  final bool alreadyAdded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final currency =
        ref.watch(recurringDetectionCurrencyProvider).value ?? 'RUB';
    final selected =
        ref.watch(selectedCandidatesProvider).contains(candidate.id);
    final isHigh = candidate.confidence == 'high';
    return Opacity(
      opacity: alreadyAdded ? 0.5 : 1.0,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.spacing8),
        padding: const EdgeInsets.all(AppSpacing.spacing12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.colorIncome.withValues(alpha: 0.05)
              : AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(AppRadius.radiusLg),
          border: Border.all(
            color: selected ? AppColors.colorIncome : AppColors.borderDivider,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: alreadyAdded ? true : selected,
              onChanged: alreadyAdded
                  ? null
                  : (_) {
                      MotionTokens.selection();
                      ref
                          .read(selectedCandidatesProvider.notifier)
                          .toggle(candidate.id);
                    },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatter.formatName(candidate.merchantName, mode),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppSpacing.spacing4),
                  Text(
                    '${RecurringDetectionStrings.monthDayPrefix}'
                    '${candidate.averageDayOfMonth}'
                    '${RecurringDetectionStrings.monthDaySuffix} · '
                    '${candidate.occurrenceCount} '
                    '${RecurringDetectionStrings.occurrencesSuffix} · '
                    '${formatter.formatAmount(candidate.averageAmount, currency, mode)}',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12),
                  ),
                  const SizedBox(height: AppSpacing.spacing8),
                  Wrap(
                    spacing: AppSpacing.spacing8,
                    children: [
                      if (alreadyAdded)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.textSecondary
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            RecurringDetectionStrings.alreadyAdded,
                            style: TextStyle(fontSize: 11),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: (isHigh
                                    ? AppColors.colorIncome
                                    : AppColors.colorWarning)
                                .withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            isHigh
                                ? RecurringDetectionStrings.confidenceHigh
                                : RecurringDetectionStrings.confidenceMedium,
                            style: TextStyle(
                              fontSize: 11,
                              color: isHigh
                                  ? AppColors.colorIncome
                                  : AppColors.colorWarning,
                            ),
                          ),
                        ),
                    ],
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

/// Confirm-диалог добавления (ТЗ 6.3.9.8): список кандидатов, опция
/// напоминаний (default TRUE) и выбор дней заранее (1/3/7, default 3).
class _AddConfirmDialog extends StatefulWidget {
  const _AddConfirmDialog({required this.count});
  final int count;

  @override
  State<_AddConfirmDialog> createState() => _AddConfirmDialogState();
}

class _AddConfirmDialogState extends State<_AddConfirmDialog> {
  bool _createReminders = true;
  int _advanceDays = 3;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '${RecurringDetectionStrings.confirmTitlePrefix}${widget.count}'
        '${RecurringDetectionStrings.confirmTitleSuffix}',
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            value: _createReminders,
            title: const Text(RecurringDetectionStrings.createRemindersOption),
            onChanged: (v) => setState(() => _createReminders = v ?? false),
          ),
          if (_createReminders) ...[
            const Text(RecurringDetectionStrings.advanceDaysLabel),
            const SizedBox(height: AppSpacing.spacing8),
            SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 1, label: Text('1')),
                ButtonSegment(value: 3, label: Text('3')),
                ButtonSegment(value: 7, label: Text('7')),
              ],
              selected: {_advanceDays},
              onSelectionChanged: (v) =>
                  setState(() => _advanceDays = v.first),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(RecurringDetectionStrings.cancel),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(
            _AddConfirmResult(
              createReminders: _createReminders,
              advanceDays: _advanceDays,
            ),
          ),
          child: const Text(RecurringDetectionStrings.add),
        ),
      ],
    );
  }
}