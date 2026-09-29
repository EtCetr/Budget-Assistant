import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/import/domain/usecases/build_secrecy_calendar_usecase.dart';
import '../providers/import_secrets_providers.dart';

/// Визуальный календарь периодов секретности (ТЗ 6.3.27).
class SecrecyCalendarWidget extends ConsumerWidget {
  const SecrecyCalendarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(importSecretsProvider);
    final notifier = ref.read(importSecretsProvider.notifier);
    if (state.year == 0) return const SizedBox.shrink();
    final days = notifier.calendarDays();
    final monthTitle = DateFormat('LLLL yyyy', 'ru').format(
        DateTime(state.year, state.month, 1));
    final firstWeekday = DateTime(state.year, state.month, 1).weekday % 7;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  onPressed: notifier.prevMonth,
                  icon: const Icon(Icons.chevron_left)),
              Text(monthTitle,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700)),
              IconButton(
                  onPressed: notifier.nextMonth,
                  icon: const Icon(Icons.chevron_right)),
            ],
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7),
            itemCount: firstWeekday + days.length,
            itemBuilder: (context, index) {
              if (index < firstWeekday) return const SizedBox.shrink();
              final day = days[index - firstWeekday];
              return _dayCell(day);
            },
          ),
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(color: AppColors.colorWarning, label: 'Секретность'),
              SizedBox(width: 12),
              _LegendDot(color: AppColors.colorFAB, label: 'Праздник'),
              SizedBox(width: 12),
              _LegendDot(color: AppColors.colorIncome, label: 'Кандидат'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dayCell(SecrecyCalendarDay day) {
    Color? bg;
    if (day.type == SecrecyDayType.secrecyPeriod) {
      bg = AppColors.colorWarning.withValues(alpha: 0.25);
    } else if (day.type == SecrecyDayType.holiday) {
      bg = AppColors.colorFAB.withValues(alpha: 0.35);
    }
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day.type == SecrecyDayType.holiday
                ? '🎁'
                : '${day.date.day}',
            style: const TextStyle(
                color: AppColors.textPrimary, fontSize: 12),
          ),
          if (day.hasCandidates)
            Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: AppColors.colorIncome,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label,
            style: const TextStyle(
                color: AppColors.textSecondary, fontSize: 11)),
      ],
    );
  }
}