import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/holiday.dart';
import '../calendar_strings.dart';
import '../providers/calendar_screen_providers.dart';
import '../providers/date_forecast_providers.dart';
import '../providers/day_statistics_providers.dart';

/// Сводка выбранного дня ПОД сеткой календаря (пожелание владельца,
/// 14.4e-2): тап по дню больше не открывает отдельный экран — данные
/// обновляются здесь. Полные экраны доступны кнопкой внизу панели.
class CalendarDayPanel extends ConsumerWidget {
  const CalendarDayPanel({super.key});

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
    final day = ref.watch(selectedDayProvider);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final currency = ref.watch(calendarBaseCurrencyProvider).value ?? 'RUB';
    final dateIso = day.toIso8601String();
    final summaryAsync = ref.watch(daySummaryProvider(dateIso));
    final breakdownAsync = ref.watch(dayCategoryBreakdownProvider(dateIso));
    final remindersAsync = ref.watch(dayRemindersListProvider(dateIso));
    final transactionsAsync = ref.watch(dayTransactionsProvider(dateIso));
    final categories = ref.watch(categoriesMapCalendarProvider);
    final holidays = ref.watch(enabledHolidaysProvider).value ?? const [];
    final dayHolidays = holidays.where((h) => h.matchesDay(day)).toList();
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final dayStart = DateTime(day.year, day.month, day.day);
    final isFuture = dayStart.isAfter(todayStart);
    final monthKey =
        '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}';
    final events = ref.watch(forecastEventsProvider(monthKey));
    int planned = 0;
    for (final e in events) {
      final local = e.dateUtc.toLocal();
      if (local.year == day.year &&
          local.month == day.month &&
          local.day == day.day) {
        planned += e.amountKopecks;
      }
    }
    final summary = summaryAsync.value;
    final pnlCount = applyPnlFilter(transactionsAsync.value ?? const []).length;
    final breakdown = breakdownAsync.value ?? const [];
    final isFreeDay = !isFuture && summary != null && summary.expense == 0;
    return Container(
      margin: const EdgeInsets.all(AppSpacing.spacing16),
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            DateFormat('EEEE, d MMMM yyyy', 'ru').format(day),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (dayHolidays.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.spacing8),
            Wrap(
              spacing: AppSpacing.spacing8,
              children: [
                for (final h in dayHolidays)
                  Chip(
                    avatar: Text(h.iconEmoji ?? '🎉'),
                    label: Text(formatter.formatName(h.name, mode)),
                  ),
              ],
            ),
          ],
          const SizedBox(height: AppSpacing.spacing12),
          if (!isFuture)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _miniColumn(
                  context,
                  CalendarStrings.spentTitle,
                  formatter.formatAmount(summary?.expense ?? 0, currency, mode),
                  AppColors.colorExpense,
                ),
                _miniColumn(
                  context,
                  CalendarStrings.incomeCardTitle,
                  formatter.formatAmount(summary?.income ?? 0, currency, mode),
                  AppColors.colorIncome,
                ),
                _miniColumn(
                  context,
                  CalendarStrings.operationsCardTitle,
                  '$pnlCount',
                  AppColors.textPrimary,
                ),
              ],
            )
          else
            Text(
              '${CalendarStrings.plannedTitle} '
              '${formatter.formatAmount(planned, currency, mode)}',
              style: const TextStyle(
                color: AppColors.colorTransfer,
                fontWeight: FontWeight.w600,
              ),
            ),
          if (isFreeDay) ...[
            const SizedBox(height: AppSpacing.spacing8),
            const Chip(
              avatar: Text('🎉'),
              label: Text(CalendarStrings.freeDayBadge),
            ),
          ],
          if (breakdown.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.spacing8),
            Wrap(
              spacing: AppSpacing.spacing8,
              runSpacing: 4,
              children: [
                for (final segment in breakdown.take(3))
                  InputChip(
                    backgroundColor: (formatter.shouldShowCategoryColors(mode)
                            ? _parseColor(categories[segment.categoryId]?.colorHex)
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
          const SizedBox(height: AppSpacing.spacing12),
          Text(CalendarStrings.dayRemindersSection,
              style: Theme.of(context).textTheme.labelLarge),
          remindersAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (reminders) {
              if (reminders.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.only(top: AppSpacing.spacing4),
                  child: Text(
                    CalendarStrings.noRemindersDay,
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 13),
                  ),
                );
              }
              return Column(
                children: [
                  for (final r in reminders)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      leading: Text(
                        DateFormat('HH:mm', 'ru').format(r.remindAt.toLocal()),
                        style:
                            const TextStyle(color: AppColors.textSecondary),
                      ),
                      title: Text(r.title,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: r.expectedAmount == null
                          ? null
                          : Text(
                              formatter.formatAmount(
                                  r.expectedAmount!, currency, mode),
                              style: const TextStyle(
                                  color: AppColors.colorExpense, fontSize: 13),
                            ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.spacing8),
          OutlinedButton(
            onPressed: () {
              MotionTokens.light();
              context.push(isFuture
                  ? '/calendar/forecast?date=$dateIso'
                  : '/calendar/day?date=$dateIso');
            },
            child: Text(isFuture
                ? CalendarStrings.openForecast
                : CalendarStrings.openDayStats),
          ),
        ],
      ),
    );
  }

  Widget _miniColumn(
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
}