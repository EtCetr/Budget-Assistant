import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import '../providers/notification_settings_providers.dart';

/// Настройки дайджестов (ТЗ 6.3.41): тумблер + время для день/неделя/месяц.
/// Конфиг хранится в app_settings.digest_config (JSON).
class DigestSettingsScreen extends ConsumerWidget {
  const DigestSettingsScreen({super.key});

  static const List<List<String>> _kinds = [
    ['daily', 'Ежедневный дайджест', 'Итоги за день'],
    ['weekly', 'Еженедельный дайджест', 'Итоги за неделю (воскресенье)'],
    ['monthly', 'Ежемесячный дайджест', 'Итоги за месяц (1 число)'],
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(appSettingsRawProvider);
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(title: const Text('Настройки дайджестов')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Ошибка: $e',
              style: const TextStyle(color: AppColors.textPrimary)),
        ),
        data: (m) {
          final cfg = parseJsonMap(m['digest_config']);
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.spacing16),
            children: [
              const Text(
                'Дайджест объединяет непрочитанные некритические пуши в одну '
                'сводку. Пустые блоки не показываются. После сборки исходные '
                'пуши помечаются прочитанными.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
              const SizedBox(height: AppSpacing.spacing16),
              for (final k in _kinds)
                _DigestCard(
                  kind: k[0],
                  title: k[1],
                  subtitle: k[2],
                  config: (cfg[k[0]] as Map<String, dynamic>?) ?? const {},
                  onSave: (on, time) async {
                    final next = {
                      ...cfg,
                      k[0]: {'on': on, 'time': time},
                    };
                    await saveSettingsColumn(
                        ref, 'digest_config', jsonEncode(next));
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}

class _DigestCard extends StatefulWidget {
  const _DigestCard({
    required this.kind,
    required this.title,
    required this.subtitle,
    required this.config,
    required this.onSave,
  });
  final String kind;
  final String title;
  final String subtitle;
  final Map<String, dynamic> config;
  final Future<void> Function(bool on, String time) onSave;

  @override
  State<_DigestCard> createState() => _DigestCardState();
}

class _DigestCardState extends State<_DigestCard> {
  late bool _on = widget.config['on'] is bool ? widget.config['on'] as bool : true;
  late final TextEditingController _time = TextEditingController(
    text: widget.config['time'] is String
        ? widget.config['time'] as String
        : '19:00',
  );

  @override
  void dispose() {
    _time.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    HapticFeedback.mediumImpact();
    await widget.onSave(_on, _time.text.trim());
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Настройки дайджеста сохранены')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacing12),
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.title,
                        style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
                    Text(widget.subtitle,
                        style: const TextStyle(
                            color: AppColors.textSecondary, fontSize: 12)),
                  ],
                ),
              ),
              Switch(
                value: _on,
                onChanged: (v) {
                  HapticFeedback.selectionClick();
                  setState(() => _on = v);
                  _save();
                },
              ),
            ],
          ),
          if (_on) ...[
            const SizedBox(height: AppSpacing.spacing8),
            Row(
              children: [
                const Text('Время: ',
                    style: TextStyle(color: AppColors.textSecondary)),
                SizedBox(
                  width: 90,
                  child: TextField(
                    controller: _time,
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) => _save(),
                    decoration: const InputDecoration(
                      hintText: '19:00',
                      isDense: true,
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.spacing8),
                FilledButton(
                  onPressed: _save,
                  child: const Text('Сохранить'),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}