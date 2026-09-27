import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../../domain/entities/holiday.dart';
import '../../domain/usecases/create_holiday_usecase.dart';
import '../calendar_strings.dart';
import '../providers/holidays_screen_providers.dart';

/// Форма создания/редактирования личного праздника (ТЗ 6.3.8.4).
Future<void> showHolidayFormSheet(
  BuildContext context,
  WidgetRef ref, {
  Holiday? existing,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _HolidayFormBody(existing: existing),
  );
}

class _HolidayFormBody extends ConsumerStatefulWidget {
  const _HolidayFormBody({this.existing});
  final Holiday? existing;

  @override
  ConsumerState<_HolidayFormBody> createState() => _HolidayFormBodyState();
}

class _HolidayFormBodyState extends ConsumerState<_HolidayFormBody> {
  late final TextEditingController _nameController =
      TextEditingController(text: widget.existing?.name ?? '');
  late final TextEditingController _emojiController =
      TextEditingController(text: widget.existing?.iconEmoji ?? '🎉');
  late DateTime _date = widget.existing?.date.toLocal() ??
      DateTime.now().add(const Duration(days: 1));
  late bool _annually = widget.existing?.isAnnuallyRecurring ?? true;
  late String _color =
      widget.existing?.colorHex ?? holidayColorPalette.first;
  late String _scope = widget.existing?.spaceId != null ? 'family' : 'personal';

  @override
  void dispose() {
    _nameController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text(CalendarStrings.validationName)),
      );
      return;
    }
    MotionTokens.light();
    final emoji = _emojiController.text.trim();
    final spaceId = ref.read(currentSpaceIdProvider);
    final userId = ref.read(currentUserIdProvider);
    final isFamily = _scope == 'family' && spaceId != null;
    try {
      final existing = widget.existing;
      if (existing == null) {
        await ref.read(createHolidayUseCaseProvider)(
          CreateHolidayParams(
            userId: userId,
            spaceId: isFamily ? spaceId : null,
            name: name,
            dateUtc: DateTime.utc(_date.year, _date.month, _date.day),
            isAnnuallyRecurring: _annually,
            iconEmoji: emoji.isEmpty ? null : emoji,
            colorHex: _color,
          ),
        );
      } else {
        await ref.read(updateHolidayUseCaseProvider)(
          existing.copyWith(
            name: name,
            date: DateTime.utc(_date.year, _date.month, _date.day),
            isAnnuallyRecurring: _annually,
            iconEmoji: emoji.isEmpty ? null : emoji,
            colorHex: _color,
            spaceId: isFamily ? spaceId : null,
          ),
        );
      }
      MotionTokens.medium();
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(existing == null
              ? CalendarStrings.created
              : CalendarStrings.updated),
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final spaceId = ref.watch(currentSpaceIdProvider);
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.spacing16).add(
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.existing == null
                  ? CalendarStrings.addHoliday
                  : CalendarStrings.editHoliday,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.spacing16),
            TextField(
              controller: _nameController,
              maxLength: 60,
              decoration:
                  const InputDecoration(hintText: CalendarStrings.formName),
            ),
            OutlinedButton(
              onPressed: _pickDate,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.calendar_month_outlined),
                  const SizedBox(width: AppSpacing.spacing8),
                  Text('${_date.day}.${_date.month}.${_date.year}'),
                ],
              ),
            ),
            SwitchListTile(
              value: _annually,
              title: const Text(CalendarStrings.formAnnually),
              onChanged: (v) => setState(() => _annually = v),
            ),
            TextField(
              controller: _emojiController,
              maxLength: 4,
              decoration:
                  const InputDecoration(hintText: CalendarStrings.formEmoji),
            ),
            Text(CalendarStrings.formColor,
                style: Theme.of(context).textTheme.labelLarge),
            Wrap(
              spacing: AppSpacing.spacing8,
              children: [
                for (final hex in holidayColorPalette)
                  GestureDetector(
                    onTap: () {
                      MotionTokens.selection();
                      setState(() => _color = hex);
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Color(int.parse(hex.substring(1), radix: 16) +
                            0xFF000000),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _color == hex
                              ? Colors.white
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            if (spaceId != null) ...[
              const SizedBox(height: AppSpacing.spacing12),
              Text(CalendarStrings.formScope,
                  style: Theme.of(context).textTheme.labelLarge),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                      value: 'personal',
                      label: Text(CalendarStrings.scopePersonal)),
                  ButtonSegment(
                      value: 'family',
                      label: Text(CalendarStrings.scopeFamily)),
                ],
                selected: {_scope},
                onSelectionChanged: (v) => setState(() => _scope = v.first),
              ),
            ],
            const SizedBox(height: AppSpacing.spacing16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(CalendarStrings.cancel),
                ),
                ElevatedButton(
                  onPressed: _save,
                  child: const Text(CalendarStrings.save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}