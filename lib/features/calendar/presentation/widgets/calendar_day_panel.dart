import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../calendar_strings.dart';
import '../providers/calendar_screen_providers.dart';

/// Панель выбранного дня под календарём (ТЗ 6.3.5): праздник,
/// потрачено, топ-категории, напоминания дня + переходы в
/// статистику дня и прогноз баланса.
class CalendarDayPanel extends ConsumerWidget {
  const CalendarDayPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(selectedDayProvider);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final currency = ref.watch(calendarBaseCurrencyProvider).value ?? 'RUB';
    final monthKey =
        '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}';
    final agg = ref.watch(monthAggregatesProvider(monthKey))[
        calendarDayKey(day)];
    final remindersAsync = ref.watch(selectedDayRemindersProvider);
    final categories = ref.watch(categoriesMapCalendarProvider);
    final dateIso = day.toIso8601String();
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
          if (agg != null && agg.holidays.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.spacing8),
            Wrap(
              spacing: AppSpacing.spacing8,
              children: [
                for (final h in agg.holidays)
                  Chip(
                    avatar: Text(h.iconEmoji ?? '🎉'),
                    label: Text(formatter.formatName(h.name, mode)),
                  ),
              ],
            ),
          ],
          if (agg != null && agg.expenseTotal > 0) ...[
            const SizedBox(height: AppSpacing.spacing8),
            Text(
              '${CalendarStrings.spentPrefix} '
              '${formatter.formatAmount(agg.expenseTotal, currency, mode)}',
              style: const TextStyle(
                color: AppColors.colorExpense,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.spacing8),
            Wrap(
              spacing: AppSpacing.spacing8,
              runSpacing: 4,
              children: [
                for (final e in agg.topCategories)
                  InputChip(
                    label: Text(
                      '${categories[e.key]?.name ?? '—'}: '
                      '${formatter.formatAmount(e.value, currency, mode)}',
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
                        DateFormat('HH:mm', 'ru')
                            .format(r.remindAt.toLocal()),
                        style: const TextStyle(
                            color: AppColors.textSecondary),
                      ),
                      title: Text(r.title,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.spacing12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    MotionTokens.light();
                    context.push('/calendar/day?date=$dateIso');
                  },
                  child: const Text(CalendarStrings.openDayStats),
                ),
              ),
              const SizedBox(width: AppSpacing.spacing8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    MotionTokens.light();
                    context.push('/calendar/forecast?date=$dateIso');
                  },
                  child: const Text(CalendarStrings.openForecast),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}