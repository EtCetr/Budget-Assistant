import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import 'package:budget_assistant/core/widgets/offline_error_card.dart';
import 'package:budget_assistant/core/widgets/priority_indicator.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/holiday.dart';
import '../calendar_strings.dart';
import '../providers/calendar_screen_providers.dart';
import '../providers/day_statistics_providers.dart';

/// Статистика дня (ТЗ 6.3.6): P&L-сводка, «бесплатный день» со streak,
/// stacked-bar категорий, задачи дня с чекбоксами, список операций
/// (секретные — заглушка 🎁).
class DayStatisticsScreen extends ConsumerWidget {
  const DayStatisticsScreen({super.key, required this.dateIso});

  final String dateIso;

  Color? _parseColor(String? hex) {
    if (hex == null || hex.isEmpty) return null;
    final value = hex.startsWith('#') ? hex.substring(1) : hex;
    if (value.length != 6 && value.length != 8) return null;
    final parsed = int.tryParse(value, radix: 16);
    if (parsed == null) return null;
    return Color(value.length == 6 ? parsed + 0xFF000000 : parsed);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = DateTime.tryParse(dateIso) ?? DateTime.now();
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final currency = ref.watch(calendarBaseCurrencyProvider).value ?? 'RUB';
    final summaryAsync = ref.watch(daySummaryProvider(dateIso));
    final transactionsAsync = ref.watch(dayTransactionsProvider(dateIso));
    final breakdownAsync = ref.watch(dayCategoryBreakdownProvider(dateIso));
    final remindersAsync = ref.watch(dayRemindersListProvider(dateIso));
    final streakAsync = ref.watch(freeDayStreakProvider);
    final categories = ref.watch(categoriesMapCalendarProvider);
    final holidays = ref.watch(enabledHolidaysProvider).value ?? const [];
    final holiday = holidays
        .where((h) => h.matchesDay(day))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('EEEE, d MMMM yyyy', 'ru').format(day)),
      ),
      body: transactionsAsync.when(
        loading: () => ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            SkeletonShimmer(height: 90),
            SizedBox(height: 12),
            SkeletonShimmer(height: 60),
            SizedBox(height: 12),
            SkeletonShimmer(height: 60),
          ],
        ),
        error: (e, _) => Center(
          child: OfflineErrorCard(
            message: CalendarStrings.loadingError,
            retryLabel: CalendarStrings.retry,
            onRetry: () => ref.invalidate(dayTransactionsProvider(dateIso)),
          ),
        ),
        data: (transactions) {
          final pnlRows = applyPnlFilter(transactions);
          final summary = summaryAsync.value ?? (income: 0, expense: 0);
          final isFreeDay = summary.expense == 0;
          final breakdown = breakdownAsync.value ?? const [];
          final totalBreakdown =
              breakdown.fold<int>(0, (a, b) => a + b.total);
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.spacing16),
            children: [
              if (holiday.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: AppSpacing.spacing16),
                  padding: const EdgeInsets.all(AppSpacing.spacing12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: BorderRadius.circular(AppRadius.radiusMd),
                    border: Border.all(
                      color: AppColors.colorWarning.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(holiday.first.iconEmoji ?? '🎉',
                          style: const TextStyle(fontSize: 28)),
                      const SizedBox(width: AppSpacing.spacing12),
                      Expanded(
                        child: Text(
                          formatter.formatName(holiday.first.name, mode),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.spacing16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(AppRadius.radiusLg),
                  border: Border.all(color: AppColors.borderDivider),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _summaryColumn(
                      context,
                      CalendarStrings.spentTitle,
                      formatter.formatAmount(summary.expense, currency, mode),
                      AppColors.colorExpense,
                    ),
                    _summaryColumn(
                      context,
                      CalendarStrings.incomeCardTitle,
                      formatter.formatAmount(summary.income, currency, mode),
                      AppColors.colorIncome,
                    ),
                    _summaryColumn(
                      context,
                      CalendarStrings.operationsCardTitle,
                      '${pnlRows.length}',
                      AppColors.textPrimary,
                    ),
                  ],
                ),
              ),
              if (isFreeDay) ...[
                const SizedBox(height: AppSpacing.spacing16),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.spacing16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceCard,
                    borderRadius: BorderRadius.circular(AppRadius.radiusLg),
                    border: Border.all(
                      color: AppColors.colorIncome.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('🎉', style: TextStyle(fontSize: 40)),
                      const SizedBox(height: AppSpacing.spacing8),
                      const Text(
                        CalendarStrings.freeDayTitle,
                        style: TextStyle(
                          color: AppColors.colorIncome,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spacing4),
                      const Text(
                        CalendarStrings.freeDaySubtitle,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                      if ((streakAsync.value ?? 0) > 1) ...[
                        const SizedBox(height: AppSpacing.spacing8),
                        Text(
                          '${CalendarStrings.streakPrefix}'
                          '${streakAsync.value} '
                          '${CalendarStrings.streakSuffix}',
                          style: const TextStyle(
                              color: AppColors.colorIncome),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
              if (breakdown.isNotEmpty && totalBreakdown > 0) ...[
                const SizedBox(height: AppSpacing.spacing16),
                Text(CalendarStrings.categoryBreakdownTitle,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: AppSpacing.spacing8),
                ClipRRect(
                  borderRadius: AppRadius.radiusFull,
                  child: SizedBox(
                    height: 12,
                    child: Row(
                      children: [
                        for (final segment in breakdown)
                          Expanded(
                            flex: segment.total,
                            child: Container(
                              color: formatter.shouldShowCategoryColors(mode)
                                  ? _parseColor(categories[segment.categoryId]
                                          ?.colorHex) ??
                                      AppColors.textSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.spacing8),
                Wrap(
                  spacing: AppSpacing.spacing8,
                  runSpacing: 4,
                  children: [
                    for (final segment in breakdown)
                      InputChip(
                        backgroundColor: (formatter
                                    .shouldShowCategoryColors(mode)
                                ? _parseColor(categories[segment.categoryId]
                                        ?.colorHex)
                                : null)
                            ?.withValues(alpha: 0.2),
                        label: Text(
                          '${categories[segment.categoryId]?.name ?? '—'}: '
                          '${formatter.formatAmount(segment.total, currency, mode)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ],
              remindersAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (reminders) {
                  if (reminders.isEmpty) return const SizedBox.shrink();
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.spacing16),
                      Text(
                        '${CalendarStrings.remindersDayTitle} '
                        '(${reminders.length})',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      for (final r in reminders)
                        CheckboxListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          value: false,
                          secondary: PriorityIndicator(priority: r.priority),
                          title: Text(r.title),
                          subtitle: r.expectedAmount == null
                              ? null
                              : Text(
                                  formatter.formatAmount(
                                      r.expectedAmount!, currency, mode),
                                  style: const TextStyle(
                                      color: AppColors.colorExpense),
                                ),
                          onChanged: (_) async {
                            MotionTokens.medium();
                            await ref.read(completeDayReminderProvider)(r.id);
                          },
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.spacing16),
              if (transactions.isEmpty)
                const EmptyStateWidget(
                  icon: Icons.receipt_long_outlined,
                  title: CalendarStrings.noTransactions,
                )
              else
                for (final t in transactions)
                  t.isHiddenByCalendar
                      ? _secretRow(t, formatter, mode, currency)
                      : ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: AppColors.surfaceElevated,
                            child: Text(
                              categories[t.customCategoryId]?.iconEmoji ??
                                  '💳',
                            ),
                          ),
                          title: Text(
                            formatter.formatMerchant(
                                t.merchantName ?? t.comment, mode),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            categories[t.customCategoryId]?.name ?? '—',
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: Text(
                            '${t.type == TransactionType.income ? '+' : t.type == TransactionType.expense ? '-' : ''}'
                            '${formatter.formatAmount(t.amount.abs(), currency, mode)}',
                            style: TextStyle(
                              color: t.type == TransactionType.income
                                  ? AppColors.colorIncome
                                  : AppColors.colorExpense,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
              const SizedBox(height: AppSpacing.spacing16),
              OutlinedButton(
                onPressed: () {
                  MotionTokens.light();
                  context.push(
                      '/transactions/create?date=$dateIso&type=expense');
                },
                child: const Text(CalendarStrings.addTransaction),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _summaryColumn(
    BuildContext context,
    String title,
    String value,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.spacing4),
        Text(
          value,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _secretRow(
    dynamic t,
    dynamic formatter,
    dynamic mode,
    String currency,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const CircleAvatar(
        backgroundColor: AppColors.surfaceElevated,
        child: Text('🎁'),
      ),
      title: const Text(
        CalendarStrings.hiddenOperation,
        style: TextStyle(color: AppColors.textSecondary),
      ),
      subtitle: t.hiddenUntilDate == null
          ? null
          : Text(
              '${CalendarStrings.secretOpensPrefix}'
              '${DateFormat('d MMMM yyyy', 'ru').format((t.hiddenUntilDate as DateTime).toLocal())}',
              style: const TextStyle(
                  color: AppColors.colorWarning, fontSize: 12),
            ),
      trailing: Text(
        formatter.formatAmount((t.amount as int).abs(), currency, mode),
        style: const TextStyle(
            color: AppColors.colorExpense, fontWeight: FontWeight.w600),
      ),
    );
  }
}