import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/notifications/domain/models/notification_type.dart';
import '../providers/notification_settings_providers.dart';

/// Настройки уведомлений (ТЗ 6.3.40): глобальные тумблеры + переключатели
/// по каждому из 27 типов (сгруппированы по каналам). alwaysOn — без тумблера.
class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(appSettingsRawProvider);
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(title: const Text('Настройки уведомлений')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Ошибка: $e',
              style: const TextStyle(color: AppColors.textPrimary)),
        ),
        data: (m) {
          final perType = parseJsonMap(m['notification_settings_json']);
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.spacing16),
            children: [
              _section('Глобальные переключатели', [
                _colSwitch(m, 'enable_debt_alerts', 'Долги', ref),
                _colSwitch(m, 'enable_deficit_forecast_alerts',
                    'Прогноз дефицита', ref),
                _colSwitch(m, 'enable_reminder_notifications',
                    'Напоминания', ref),
                _colSwitch(m, 'enable_group_activity_alerts',
                    'Активность группы', ref),
                _colSwitch(m, 'enable_bank_statement_reminder',
                    'Напоминание о выписке', ref),
                _colSwitch(m, 'enable_secrecy_mode',
                    'Режим секретности (подарки)', ref),
                _colSwitch(m, 'enable_year_in_review_alerts',
                    'Годовой отчёт', ref),
              ]),
              for (final ch in NotificationChannel.values)
                _section(ch.title, [
                  for (final t in NotificationType.values
                      .where((t) => t.channel == ch))
                    _typeRow(t, perType, ref),
                ]),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius:
                      const BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
                  border: Border.all(color: AppColors.borderDivider),
                ),
                child: ListTile(
                  leading: const Icon(Icons.summarize_outlined,
                      color: AppColors.colorTransfer),
                  title: const Text('Дайджесты',
                      style: TextStyle(color: AppColors.textPrimary)),
                  subtitle: const Text('Итоги дня / недели / месяца',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 12)),
                  trailing: const Icon(Icons.chevron_right,
                      color: AppColors.textSecondary),
                  onTap: () {
                    HapticFeedback.selectionClick();
                    context.push('/settings/digest');
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _section(String title, List<Widget> rows) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
              top: AppSpacing.spacing16, bottom: AppSpacing.spacing8),
          child: Text(title,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius:
                const BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
            border: Border.all(color: AppColors.borderDivider),
          ),
          child: Column(children: rows),
        ),
      ],
    );
  }

  Widget _colSwitch(Map<String, Object?> m, String column, String label,
      WidgetRef ref) {
    final value = (m[column] as bool?) ?? true;
    return SwitchListTile(
      value: value,
      title: Text(label, style: const TextStyle(color: AppColors.textPrimary)),
      onChanged: (v) {
        HapticFeedback.selectionClick();
        saveSettingsColumn(ref, column, v);
      },
    );
  }

  Widget _typeRow(
    NotificationType t,
    Map<String, dynamic> perType,
    WidgetRef ref,
  ) {
    final value = perType[t.dbValue] is bool ? perType[t.dbValue] as bool : true;
    return SwitchListTile(
      value: t.alwaysOn ? true : value,
      onChanged: t.alwaysOn
          ? null
          : (v) {
              HapticFeedback.selectionClick();
              final next = {...perType, t.dbValue: v};
              saveSettingsColumn(
                ref,
                'notification_settings_json',
                jsonEncodeSafe(next),
              );
            },
      title: Text(t.label,
          style: const TextStyle(color: AppColors.textPrimary)),
      subtitle: t.alwaysOn
          ? const Text('Всегда включено (критическое)',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12))
          : null,
    );
  }
}

String jsonEncodeSafe(Map<String, dynamic> m) {
  final sb = StringBuffer('{');
  var first = true;
  for (final e in m.entries) {
    if (!first) sb.write(',');
    first = false;
    sb.write('"${e.key}":${e.value}');
  }
  sb.write('}');
  return sb.toString();
}