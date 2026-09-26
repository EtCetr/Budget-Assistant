import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/savings_goal.dart';
import '../../domain/usecases/sort_goals_table_usecase.dart';
import '../providers/savings_analytics_providers.dart';
import '../savings_goals_strings.dart';

/// Сортируемая таблица целей (ТЗ 6.3.18.6): тап по заголовку — сортировка
/// по колонке, повторный тап — смена направления.
class SavingsGoalsTable extends ConsumerWidget {
  const SavingsGoalsTable({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(sortedAnalyticsGoalsProvider);
    final field = ref.watch(goalsSortFieldProvider);
    final asc = ref.watch(goalsSortAscendingProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final mode = ref.watch(privacyModeProvider);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: goalsAsync.when(
        loading: () => const SizedBox(
          height: 80,
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => const Text(SavingsGoalsStrings.loadingError),
        data: (goals) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              SavingsGoalsStrings.tableTitle,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: AppSpacing.spacing12),
            _header(ref, field, asc),
            const Divider(height: 1),
            if (goals.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.spacing16),
                child: Text(SavingsGoalsStrings.chartEmptySubtitle),
              )
            else
              ...goals.map((g) => _row(g, formatter, mode)),
          ],
        ),
      ),
    );
  }

  Widget _header(WidgetRef ref, GoalSortField field, bool asc) {
    Widget cell(String label, GoalSortField f) => Expanded(
          child: InkWell(
            onTap: () {
              if (field == f) {
                ref.read(goalsSortAscendingProvider.notifier).toggle();
              } else {
                ref.read(goalsSortFieldProvider.notifier).set(f);
                ref.read(goalsSortAscendingProvider.notifier).set(true);
              }
            },
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (field == f)
                  Icon(asc ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 14),
              ],
            ),
          ),
        );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.spacing8),
      child: Row(
        children: [
          cell(SavingsGoalsStrings.tableGoal, GoalSortField.name),
          cell(SavingsGoalsStrings.tableTarget, GoalSortField.target),
          cell(SavingsGoalsStrings.tableSaved, GoalSortField.current),
          cell(SavingsGoalsStrings.tableProgress, GoalSortField.progress),
          cell(SavingsGoalsStrings.tableDeadline, GoalSortField.deadline),
        ],
      ),
    );
  }

  Widget _row(
    SavingsGoal g,
    PrivacyFormatter formatter,
    BalanceVisibilityMode mode,
  ) {
    const style = TextStyle(fontSize: 12);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(g.name, overflow: TextOverflow.ellipsis, style: style),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatter.formatAmount(g.targetAmount, g.currency, mode),
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              formatter.formatAmount(g.currentAmount, g.currency, mode),
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
          Expanded(
            child: Text(
              formatter.formatPercent(g.progressPercent, mode),
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              g.deadline == null
                  ? '—'
                  : DateFormat('dd.MM.yy').format(g.deadline!.toLocal()),
              overflow: TextOverflow.ellipsis,
              style: style,
            ),
          ),
        ],
      ),
    );
  }
}