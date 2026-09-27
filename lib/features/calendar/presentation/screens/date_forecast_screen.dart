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
import '../calendar_strings.dart';
import '../providers/calendar_screen_providers.dart';
import '../providers/date_forecast_providers.dart';

/// Прогноз баланса на дату (ТЗ 6.3.7): текущий баланс счетов +
/// накопленные события месяца; кэш прогноза по категориям +
/// stale-баннер с пересчётом через compute-изолят.
class DateForecastScreen extends ConsumerStatefulWidget {
  const DateForecastScreen({super.key, this.initialDateIso});

  final String? initialDateIso;

  @override
  ConsumerState<DateForecastScreen> createState() =>
      _DateForecastScreenState();
}

class _DateForecastScreenState extends ConsumerState<DateForecastScreen> {
  late DateTime _date =
      DateTime.tryParse(widget.initialDateIso ?? '') ?? DateTime.now();
  bool _recalculating = false;

  String get _monthKey =>
      '${_date.year.toString().padLeft(4, '0')}-'
      '${_date.month.toString().padLeft(2, '0')}';

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
    } catch (_) {
      // Ошибка пересчёта: показываем старые данные (offline-first).
    } finally {
      if (mounted) setState(() => _recalculating = false);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
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
    final dateIso = _date.toIso8601String();
    final balanceAsync = ref.watch(predictedBalanceProvider(dateIso));
    final cacheAsync = ref.watch(forecastCacheProvider(_monthKey));
    final lastUpdatedAsync = ref.watch(forecastLastUpdatedProvider(_monthKey));
    final categories = ref.watch(categoriesMapCalendarProvider);
    final lastUpdated = lastUpdatedAsync.value;
    final now = DateTime.now().toUtc();
    final todayStart = DateTime.utc(now.year, now.month, now.day);
    final stale = lastUpdated == null || lastUpdated.isBefore(todayStart);
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
            padding: const EdgeInsets.all(AppSpacing.spacing24),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(AppRadius.radiusLg),
              border: Border.all(color: AppColors.borderDivider),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(CalendarStrings.predictedBalancePrefix,
                    style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(height: AppSpacing.spacing8),
                balanceAsync.when(
                  loading: () => const SkeletonShimmer(height: 40),
                  error: (_, __) => const Text('—'),
                  data: (balance) => Text(
                    formatter.formatAmount(balance, currency, mode),
                    style: TextStyle(
                      color: balance < 0
                          ? AppColors.colorExpense
                          : AppColors.colorIncome,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (stale) ...[
            const SizedBox(height: AppSpacing.spacing16),
            Card(
              color: AppColors.colorWarning.withValues(alpha: 0.15),
              child: ListTile(
                leading: _recalculating
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
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
                          MotionTokens.light();
                          _runRecalc();
                        },
                        child: const Text(CalendarStrings.recalculate),
                      ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.spacing16),
          Text(CalendarStrings.breakdownTitle,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.spacing8),
          cacheAsync.when(
            loading: () => const SkeletonShimmer(height: 60),
            error: (_, __) => const SizedBox.shrink(),
            data: (entries) {
              if (entries.isEmpty) {
                return const Text(
                  CalendarStrings.noTransactions,
                  style: TextStyle(color: AppColors.textSecondary),
                );
              }
              return Column(
                children: [
                  for (final e in entries)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      leading: Text(categories[e.categoryId]?.iconEmoji ?? '🏷'),
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
        ],
      ),
    );
  }
}