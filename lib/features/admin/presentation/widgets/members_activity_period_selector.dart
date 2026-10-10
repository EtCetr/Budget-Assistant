import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/features/admin/domain/usecases/members_activity_usecases.dart';
import '../providers/members_activity_providers.dart';

/// Переключатель периода (ТЗ 6.3.34.3): Неделя / Месяц / Квартал / Год.
class MembersActivityPeriodSelector extends ConsumerWidget {
  const MembersActivityPeriodSelector({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(activityPeriodProvider);
    return SegmentedButton<ActivityPeriod>(
      segments: const [
        ButtonSegment(value: ActivityPeriod.week, label: Text('Неделя')),
        ButtonSegment(value: ActivityPeriod.month, label: Text('Месяц')),
        ButtonSegment(value: ActivityPeriod.quarter, label: Text('Квартал')),
        ButtonSegment(value: ActivityPeriod.year, label: Text('Год')),
      ],
      selected: {period},
      onSelectionChanged: (s) {
        HapticFeedback.selectionClick();
        ref.read(activityPeriodProvider.notifier).set(s.first);
      },
    );
  }
}