import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import '../../domain/models/recurrence_settings.dart';
import '../reminders_strings.dart';

/// RRULE-билдер (BottomSheet, ТЗ 6.3.12.4): частота, интервал,
/// дни недели, день месяца, месяц (для yearly), «повторять до».
Future<RecurrenceSettings?> showRRuleBuilderSheet(
  BuildContext context,
  RecurrenceSettings initial,
) {
  return showModalBottomSheet<RecurrenceSettings>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => _RRuleBuilderBody(initial: initial),
  );
}

class _RRuleBuilderBody extends StatefulWidget {
  const _RRuleBuilderBody({required this.initial});
  final RecurrenceSettings initial;

  @override
  State<_RRuleBuilderBody> createState() => _RRuleBuilderBodyState();
}

class _RRuleBuilderBodyState extends State<_RRuleBuilderBody> {
  late RecurrenceFreq _freq = widget.initial.freq;
  late int _interval = widget.initial.interval;
  late final Set<int> _weekdays = widget.initial.byWeekday.toSet();
  late int _monthDay = widget.initial.byMonthDay ?? 1;
  late int _month = widget.initial.byMonth ?? DateTime.now().month;
  late bool _hasUntil = widget.initial.until != null;
  late DateTime _until =
      widget.initial.until ?? DateTime.now().add(const Duration(days: 365));
  late final TextEditingController _intervalController =
      TextEditingController(text: '${widget.initial.interval}');

  static const _weekdayLabels = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
  static const _monthLabels = [
    'янв', 'фев', 'мар', 'апр', 'май', 'июн',
    'июл', 'авг', 'сен', 'окт', 'ноя', 'дек',
  ];

  @override
  void dispose() {
    _intervalController.dispose();
    super.dispose();
  }

  Future<void> _pickUntil() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _until,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (picked != null && mounted) {
      setState(() {
        _hasUntil = true;
        _until = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.spacing16).add(
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(RemindersStrings.rruleSheetTitle,
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.spacing16),
            Text(RemindersStrings.rruleFreq,
                style: Theme.of(context).textTheme.labelLarge),
            DropdownButton<RecurrenceFreq>(
              value: _freq,
              isExpanded: true,
              items: [
                for (final f in RecurrenceFreq.values)
                  DropdownMenuItem(
                    value: f,
                    child: Text(switch (f) {
                      RecurrenceFreq.daily => 'Ежедневно',
                      RecurrenceFreq.weekly => 'Еженедельно',
                      RecurrenceFreq.monthly => 'Ежемесячно',
                      RecurrenceFreq.yearly => 'Ежегодно',
                    }),
                  ),
              ],
              onChanged: (v) => setState(() => _freq = v!),
            ),
            Row(
              children: [
                const Text('Каждые '),
                SizedBox(
                  width: 56,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _intervalController,
                    decoration: const InputDecoration(isDense: true),
                    onChanged: (v) =>
                        setState(() => _interval = int.tryParse(v) ?? 1),
                  ),
                ),
                const Text(' период(ов)'),
              ],
            ),
            if (_freq == RecurrenceFreq.weekly) ...[
              const SizedBox(height: AppSpacing.spacing12),
              Text(RemindersStrings.rruleWeekdays,
                  style: Theme.of(context).textTheme.labelLarge),
              Wrap(
                spacing: 6,
                children: [
                  for (int day = 1; day <= 7; day++)
                    FilterChip(
                      label: Text(_weekdayLabels[day - 1]),
                      selected: _weekdays.contains(day),
                      onSelected: (on) => setState(() {
                        if (on) {
                          _weekdays.add(day);
                        } else {
                          _weekdays.remove(day);
                        }
                      }),
                    ),
                ],
              ),
            ],
            if (_freq == RecurrenceFreq.monthly) ...[
              const SizedBox(height: AppSpacing.spacing12),
              Text(RemindersStrings.rruleMonthDay,
                  style: Theme.of(context).textTheme.labelLarge),
              DropdownButton<int>(
                value: _monthDay.clamp(1, 31),
                items: [
                  for (int d = 1; d <= 31; d++)
                    DropdownMenuItem(value: d, child: Text('$d')),
                ],
                onChanged: (v) => setState(() => _monthDay = v!),
              ),
            ],
            if (_freq == RecurrenceFreq.yearly) ...[
              const SizedBox(height: AppSpacing.spacing12),
              Text('Месяц', style: Theme.of(context).textTheme.labelLarge),
              DropdownButton<int>(
                value: _month.clamp(1, 12),
                items: [
                  for (int m = 1; m <= 12; m++)
                    DropdownMenuItem(
                        value: m, child: Text(_monthLabels[m - 1])),
                ],
                onChanged: (v) => setState(() => _month = v!),
              ),
              Text(RemindersStrings.rruleMonthDay,
                  style: Theme.of(context).textTheme.labelLarge),
              DropdownButton<int>(
                value: _monthDay.clamp(1, 31),
                items: [
                  for (int d = 1; d <= 31; d++)
                    DropdownMenuItem(value: d, child: Text('$d')),
                ],
                onChanged: (v) => setState(() => _monthDay = v!),
              ),
            ],
            const SizedBox(height: AppSpacing.spacing12),
            Text(RemindersStrings.rruleUntil,
                style: Theme.of(context).textTheme.labelLarge),
            RadioGroup<bool>(
              groupValue: _hasUntil,
              onChanged: (v) {
                if (v == null) return;
                if (!v) {
                  setState(() => _hasUntil = false);
                  return;
                }
                _pickUntil();
              },
              child: Column(
                children: [
                  const RadioListTile<bool>(
                    value: false,
                    title: Text(RemindersStrings.rruleForever),
                  ),
                  RadioListTile<bool>(
                    value: true,
                    title: Text(
                      '${RemindersStrings.rruleUntilDate}: '
                      '${_until.day}.${_until.month}.${_until.year}',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.spacing16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(RemindersStrings.cancel),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(
                      RecurrenceSettings(
                        freq: _freq,
                        interval: _interval < 1 ? 1 : _interval,
                        byWeekday: _weekdays.toList()..sort(),
                        byMonthDay: _freq == RecurrenceFreq.monthly ||
                                _freq == RecurrenceFreq.yearly
                            ? _monthDay
                            : null,
                        byMonth: _freq == RecurrenceFreq.yearly ? _month : null,
                        until: _hasUntil ? _until : null,
                      ),
                    );
                  },
                  child: const Text(RemindersStrings.rruleApply),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}