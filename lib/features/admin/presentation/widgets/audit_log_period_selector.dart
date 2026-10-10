import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/audit_log_providers.dart';

/// Четырёхсегментный переключатель периода (ТЗ 6.3.35.3).
class AuditLogPeriodSelector extends ConsumerWidget {
  const AuditLogPeriodSelector({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(auditPeriodProvider);
    return SegmentedButton<AuditLogPeriod>(
      segments: const [
        ButtonSegment(value: AuditLogPeriod.week, label: Text('Неделя')),
        ButtonSegment(value: AuditLogPeriod.month, label: Text('Месяц')),
        ButtonSegment(value: AuditLogPeriod.quarter, label: Text('Квартал')),
        ButtonSegment(value: AuditLogPeriod.all, label: Text('Всё время')),
      ],
      selected: {period},
      onSelectionChanged: (s) {
        HapticFeedback.selectionClick();
        ref.read(auditPeriodProvider.notifier).set(s.first);
      },
    );
  }
}