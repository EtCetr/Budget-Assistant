import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import 'package:go_router/go_router.dart';
import '../calendar_strings.dart';
import '../providers/calendar_screen_providers.dart';
import '../providers/date_forecast_providers.dart';

/// Прогноз баланса на БУДУЩУЮ дату (ТЗ 6.3.7 + фикс 14.4e):
/// текущий баланс − накопленные события (напоминания с суммой +
/// регулярные платежи); секции событий; дефицит-блок; кэш-разбивка
/// по категориям; stale-баннер с пересчётом в compute-изоляте.
/// Прошедшие даты → карточка «день прошёл» + переход в статистику.
class DateForecastScreen extends ConsumerStatefulWidget {
  const DateForecastScreen({super.key, this.initialDateIso});

  final String? initialDateIso;

  @override
  ConsumerState<DateForecastScreen> createState() =>
      _DateForecastScreenState();
}

class _DateForecastScreenState extends ConsumerState<DateForecastScreen> {
  late DateTime _date = _clampToFuture(
    DateTime.tryParse(widget.initialDateIso ?? '') ??
        DateTime.now().add(const Duration(days: 1)),
  );
  bool _recalculating = false;

  static DateTime _clampToFuture(DateTime d) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final tomorrowStart =
        DateTime(tomorrow.year, tomorrow.month, tomorrow.day);
    final day = DateTime(d.year, d.month, d.day);
    return day.isBefore(tomorrowStart) ? tomorrowStart : day;
  }

  bool get _isPast =>
      _date.isBefore(DateTime.now().add(const Duration(days: 1)));

  String get _monthKey =>
      '${_date.year.toString().padLeft(4, '0')}-'
      '${_date.month.toString().padLeft(2, '0')}';

  String get _dateIso => _date.toIso8601String();

  @override
  void initState() {
    super.initState();
    Future.microtask(_maybeAutoRecalc);
  }

  Future<void> _maybeAutoRecalc() async {
    try {
      final last =
          await ref.read(forecastLastUpdatedProvider(_monthKey).future);
      final now = DateTime.now().toUtc();
      final todayStart = DateTime.utc(now.year, now.month, now.day);
      if (last == null || last.isBefore(todayStart)) {
        await _runRecalc();
      }
    } catch (_) {
      // Пересчёт не критичен для отображения прогноза (offline-first).
    }
  }

  Future<void> _runRecalc() async {
    if (_recalculating) return;
    setState(() => _recalculating = true);
    try {
      final events = ref.read(forecastEventsProvider(_monthKey));
      await ref.read(recalculateForecastUseCaseProvider)(
        userId: ref.read(currentUserIdProvider),
        spaceId: ref.read(currentSpaceIdProvider),
        monthKey: _monthKey,
        events: events,
      );
      ref.invalidate(forecastCacheProvider(_monthKey));
      ref.invalidate(forecastLastUpdatedProvider(_monthKey));
      MotionTokens.light();
    } catch (_) {
      // Ошибка пересчёта: показываем старые данные (offline-first).
    } finally {
      if (mounted) setState(() => _recalculating = false);
    }
  }

  Future<void> _pickDate() async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: tomorrow,
      lastDate: DateTime.now().add(const Duration(days: 730)),
    );
    if (picked != null) {
      MotionTokens.selection();
      setState(() => _date = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final currency = ref.watch(calendarBaseCurrencyProvider).value ?? 'RUB';
    final categories = ref.watch(categoriesMapCalendarProvider);
    if (_isPast) {
      return Scaffold(
        appBar: AppBar(title: const Text(CalendarStrings.forecastTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.spacing32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.history, size: 64),
                const SizedBox(height: AppSpacing.spacing16),
                Text(CalendarStrings.pastDayTitle,
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppSpacing.spacing8),
                const Text(
                  CalendarStrings.pastDaySubtitle,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.spacing16),
                ElevatedButton(
                  onPressed: () {
                    MotionTokens.light();
                    context.push('/calendar/day?date=$_dateIso');
                  },
                  child: const Text(CalendarStrings.openDayStats),
                ),
              ],
            ),
          ),
        ),
      );
    }
    final balanceAsync = ref.watch(currentBalanceProvider);
    final predictedAsync = ref.watch(predictedBalanceProvider(_dateIso));
    final cacheAsync = ref.watch(forecastCacheProvider(_monthKey));
    final lastUpdatedAsync = ref.watch(forecastLastUpdatedProvider(_monthKey));
    final remindersAsync = ref.watch(forecastMonthRemindersProvider(_monthKey));
    final recurring = ref.watch(activeRecurringCalendarProvider).value ?? const [];
    final holidays = ref.watch(forecastHolidaysProvider(_dateIso));
    final lastUpdated = lastUpdatedAsync.value;
    final now = DateTime.now().toUtc();
    final todayStart = DateTime.utc(now.year, now.month, now.day);
    final stale = lastUpdated == null || lastUpdated.isBefore(todayStart);
    final predicted = predictedAsync.value;
    final targetEnd =
        DateTime(_date.year, _date.month, _date.day, 23, 59, 59);
    return Scaffold(
      appBar: AppBar(title: const Text(CalendarStrings.forecastTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.spacing16),
        children: [
          OutlinedButton(
            onPressed: _pickDate,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_month_outlined),
                const SizedBox(width: AppSpacing.spacing8),
                Text(DateFormat('EEEE, d MMMM yyyy', 'ru').format(_date)),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.spacing16),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(CalendarStrings.currentBalanceTitle,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: AppSpacing.spacing4),
                    balanceAsync.when(
                      loading: () => const SkeletonShimmer(height: 24),
                      error: (_, __) => const Text('—'),
                      data: (b) => Text(
                        formatter.formatAmount(b, currency, mode),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(CalendarStrings.predictedBalancePrefix,
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium
                            ?.copyWith(color: AppColors.textSecondary)),
                    const SizedBox(height: AppSpacing.spacing4),
                    predictedAsync.when(
                      loading: () => const SkeletonShimmer(height: 24),
                      error: (_, __) => const Text('—'),
                      data: (p) => Text(
                        formatter.formatAmount(p, currency, mode),
                        style: TextStyle(
                          color: p < 0
                              ? AppColors.colorExpense
                              : AppColors.colorIncome,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (predicted != null && predicted < 0) ...[
            const SizedBox(height: AppSpacing.spacing16),
            Container(
              padding: const EdgeInsets.all(AppSpacing.spacing16),
              decoration: BoxDecoration(
                color: AppColors.colorExpense.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.radiusMd),
                border: Border.all(color: AppColors.colorExpense),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.warning_amber_rounded,
                          color: AppColors.colorExpense),
                      SizedBox(width: AppSpacing.spacing8),
                      Expanded(
                        child: Text(
                          CalendarStrings.deficitTitle,
                          style: TextStyle(
                            color: AppColors.colorExpense,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.spacing8),
                  Text(
                    '${CalendarStrings.deficitSubtitlePrefix}'
                    '${DateFormat('d MMMM', 'ru').format(_date)}: '
                    '${formatter.formatAmount(predicted, currency, mode)}',
                  ),
                  const SizedBox(height: AppSpacing.spacing8),
                  OutlinedButton(
                    onPressed: () {
                      MotionTokens.light();
                      _showAvoidSheet(predicted, currency, mode, formatter,
                          categories);
                    },
                    child: const Text(CalendarStrings.howToAvoid),
                  ),
                ],
              ),
            ),
          ],
          if (stale) ...[
            const SizedBox(height: AppSpacing.spacing16),
            Card(
              color: AppColors.colorWarning.withValues(alpha: 0.15),
              child: ListTile(
                leading: _recalculating
                    ? const _RecalcSpinner()
                    : const Icon(Icons.update,
                        color: AppColors.colorWarning),
                title: Text(
                  _recalculating
                      ? CalendarStrings.recalculating
                      : CalendarStrings.forecastStaleText,
                ),
                trailing: _recalculating
                    ? null
                    : TextButton(
                        onPressed: () {
                          MotionTokens.medium();
                          _runRecalc();
                        },
                        child: const Text(CalendarStrings.recalculate),
                      ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.spacing16),
          Text(CalendarStrings.eventsSectionTitle,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.spacing8),
          _section(
            context,
            '💳 ${CalendarStrings.recurringSection}',
            [
              for (final r in recurring)
                if (_recurringDate(r.averageDayOfMonth)
                    .isBefore(targetEnd.add(const Duration(days: 1))))
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(formatter.formatName(r.merchantName, mode)),
                    subtitle: Text(
                      DateFormat('d MMMM', 'ru')
                          .format(_recurringDate(r.averageDayOfMonth)),
                      style: const TextStyle(fontSize: 12),
                    ),
                    trailing: Text(
                      formatter.formatAmount(
                          r.averageAmount.abs(), currency, mode),
                      style:
                          const TextStyle(color: AppColors.colorExpense),
                    ),
                  ),
            ],
          ),
          remindersAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (reminders) {
              final withAmount = reminders
                  .where((r) =>
                      r.expectedAmount != null &&
                      !r.remindAt.toLocal().isAfter(targetEnd))
                  .toList();
              final withoutAmount = reminders
                  .where((r) =>
                      r.expectedAmount == null &&
                      !r.remindAt.toLocal().isAfter(targetEnd))
                  .toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _section(
                    context,
                    '🔔 ${CalendarStrings.remindersWithAmountSection}',
                    [
                      for (final r in withAmount)
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(r.title),
                          subtitle: Text(
                            DateFormat('d MMMM', 'ru')
                                .format(r.remindAt.toLocal()),
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: Text(
                            formatter.formatAmount(
                                r.expectedAmount!, currency, mode),
                            style: const TextStyle(
                                color: AppColors.colorExpense),
                          ),
                          onTap: () {
                            MotionTokens.light();
                            context.push('/reminders/${r.id}');
                          },
                        ),
                    ],
                  ),
                  _section(
                    context,
                    '🔔 ${CalendarStrings.remindersNoAmountSection}',
                    [
                      for (final r in withoutAmount)
                        ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(r.title),
                          subtitle: Text(
                            DateFormat('d MMMM', 'ru')
                                .format(r.remindAt.toLocal()),
                            style: const TextStyle(fontSize: 12),
                          ),
                          onTap: () {
                            MotionTokens.light();
                            context.push('/reminders/${r.id}');
                          },
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
          _section(
            context,
            '🎉 ${CalendarStrings.holidaysSection}',
            [
              for (final h in holidays)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: Text(h.iconEmoji ?? '🎉',
                      style: const TextStyle(fontSize: 22)),
                  title: Text(formatter.formatName(h.name, mode)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing16),
          Text(CalendarStrings.breakdownTitle,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.spacing8),
          cacheAsync.when(
            loading: () => const SkeletonShimmer(height: 60),
            error: (_, __) => const SizedBox.shrink(),
            data: (entries) {
              final byCategory = entries
                  .where((e) => e.categoryId != null)
                  .toList();
              if (byCategory.isEmpty) {
                return const Text(
                  CalendarStrings.forecastEmptyPlanned,
                  style: TextStyle(color: AppColors.textSecondary),
                );
              }
              return Column(
                children: [
                  for (final e in byCategory)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      leading:
                          Text(categories[e.categoryId]?.iconEmoji ?? '🏷'),
                      title: Text(
                        categories[e.categoryId]?.name ?? '—',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        formatter.formatAmount(
                            e.forecastedAmount, currency, mode),
                        style: const TextStyle(
                            color: AppColors.colorExpense),
                      ),
                    ),
                ],
              );
            },
          ),
          if (lastUpdated != null) ...[
            const SizedBox(height: AppSpacing.spacing16),
            Text(
              '${CalendarStrings.updatedAtPrefix} '
              '${DateFormat('d MMMM, HH:mm', 'ru').format(lastUpdated.toLocal())}',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 12),
            ),
          ],
          const SizedBox(height: AppSpacing.spacing24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.colorFAB,
                  ),
                  onPressed: () {
                    MotionTokens.light();
                    context.push(
                        '/transactions/create?type=expense&date=$_dateIso');
                  },
                  child: const Text(CalendarStrings.planExpense),
                ),
              ),
              const SizedBox(width: AppSpacing.spacing8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    MotionTokens.light();
                    context.push('/reminders/create?date=$_dateIso');
                  },
                  child: const Text(CalendarStrings.createReminder),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  DateTime _recurringDate(int dayOfMonth) {
    final day = dayOfMonth.clamp(1, 28);
    var date = DateTime(_date.year, _date.month, day, 12, 0);
    if (date.isBefore(DateTime.now())) {
      date = DateTime(_date.year, _date.month + 1, day, 12, 0);
    }
    return date;
  }

  Widget _section(BuildContext context, String title, List<Widget> rows) {
    if (rows.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.labelLarge),
        ...rows,
        const SizedBox(height: AppSpacing.spacing8),
      ],
    );
  }

  void _showAvoidSheet(
    int predicted,
    String currency,
    dynamic mode,
    dynamic formatter,
    Map<String, dynamic> categories,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        final cache =
            ref.read(forecastCacheProvider(_monthKey)).value ?? const [];
        final top = cache
            .where((e) => e.categoryId != null)
            .toList()
          ..sort((a, b) => b.forecastedAmount.compareTo(a.forecastedAmount));
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.spacing16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(CalendarStrings.avoidTopCategories,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: AppSpacing.spacing8),
                for (final e in top.take(3))
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                        categories[e.categoryId]?.name?.toString() ?? '—'),
                    trailing: Text(formatter.formatAmount(
                        e.forecastedAmount, currency, mode)),
                  ),
                const SizedBox(height: AppSpacing.spacing16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(sheetContext).pop();
                    context.push('/transactions/create?type=income');
                  },
                  child: const Text(CalendarStrings.avoidAddIncome),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Const-спиннер пересчёта (вынесен, чтобы блок Card оставался
/// const-дружественным и не ловил prefer_const_constructors).
class _RecalcSpinner extends StatelessWidget {
  const _RecalcSpinner();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(12),
      child: SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      ),
    );
  }
}
