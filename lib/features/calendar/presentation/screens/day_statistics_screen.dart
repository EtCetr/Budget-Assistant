import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import 'package:budget_assistant/core/widgets/offline_error_card.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../calendar_strings.dart';
import '../providers/calendar_screen_providers.dart';
import '../providers/day_statistics_providers.dart';

/// Статистика дня (ТЗ 6.3.6): итоги доход/расход, бейдж «бесплатный
/// день» со streak, список транзакций дня.
class DayStatisticsScreen extends ConsumerWidget {
  const DayStatisticsScreen({super.key, required this.dateIso});

  final String dateIso;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = DateTime.tryParse(dateIso) ?? DateTime.now();
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final currency = ref.watch(calendarBaseCurrencyProvider).value ?? 'RUB';
    final totals = ref.watch(dayTotalsProvider(dateIso));
    final transactionsAsync = ref.watch(dayTransactionsProvider(dateIso));
    final streakAsync = ref.watch(freeDayStreakProvider);
    final categories = ref.watch(categoriesMapCalendarProvider);
    final isFreeDay = totals.expense == 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(DateFormat('d MMMM yyyy', 'ru').format(day)),
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
        data: (transactions) => ListView(
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.spacing16),
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(AppRadius.radiusLg),
                border: Border.all(color: AppColors.borderDivider),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${CalendarStrings.incomeTitle} '
                        '${formatter.formatAmount(totals.income, currency, mode)}',
                        style: const TextStyle(
                            color: AppColors.colorIncome,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${CalendarStrings.expenseTitle} '
                        '${formatter.formatAmount(totals.expense, currency, mode)}',
                        style: const TextStyle(
                            color: AppColors.colorExpense,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  if (isFreeDay) ...[
                    const SizedBox(height: AppSpacing.spacing12),
                    Wrap(
                      spacing: AppSpacing.spacing8,
                      children: [
                        const Chip(
                          avatar: Text('🎉'),
                          label: Text(CalendarStrings.freeDayBadge),
                        ),
                        if ((streakAsync.value ?? 0) > 1)
                          Chip(
                            label: Text(
                              '${streakAsync.value} '
                              '${CalendarStrings.streakSuffix}',
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spacing16),
            if (transactions.isEmpty)
              const EmptyStateWidget(
                icon: Icons.receipt_long_outlined,
                title: CalendarStrings.noTransactions,
              )
            else
              for (final t in transactions)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: AppColors.surfaceElevated,
                    child: Text(
                      categories[t.customCategoryId]?.iconEmoji ?? '💳',
                    ),
                  ),
                  title: Text(
                    formatter.formatName(t.merchantName ?? t.comment, mode),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    categories[t.customCategoryId]?.name ?? '—',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12),
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
          ],
        ),
      ),
    );
  }
}