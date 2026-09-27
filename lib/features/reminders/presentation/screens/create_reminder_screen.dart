import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/formatting/money_text_input_formatter.dart';
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/features/accounts/presentation/providers/account_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/categories/presentation/providers/category_providers.dart';
import '../../domain/entities/reminder_form_draft.dart';
import '../../domain/models/recurrence_settings.dart';
import '../providers/create_reminder_providers.dart';
import '../providers/reminders_providers.dart';
import '../providers/reminders_repository_providers.dart';
import '../providers/reminders_screen_providers.dart';
import '../reminders_strings.dart';
import '../widgets/rrule_builder_sheet.dart';

/// Форма создания/редактирования напоминания (ТЗ 6.3.12):
/// секции Что/Когда/Финансы/Область/Связи, RRULE-пресеты и билдер,
/// автосейв черновика каждые 5 сек, восстановление черновика < 24 ч,
/// режимы edit / from_recurring / copy / date.
class CreateReminderScreen extends ConsumerStatefulWidget {
  const CreateReminderScreen({
    super.key,
    this.editReminderId,
    this.type,
    this.dateIso,
    this.copyFromReminderId,
  });

  final String? editReminderId;
  final String? type;
  final String? dateIso;
  final String? copyFromReminderId;

  @override
  ConsumerState<CreateReminderScreen> createState() =>
      _CreateReminderScreenState();
}

class _CreateReminderScreenState extends ConsumerState<CreateReminderScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController =
      TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  Timer? _draftTimer;
  String _lastSavedJson = '';
  bool _initialized = false;

  bool get _isEdit => widget.editReminderId != null;

  @override
  void initState() {
    super.initState();
    Future.microtask(_initialize);
  }

  @override
  void dispose() {
    _draftTimer?.cancel();
    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  DateTime _defaultDate() {
    final now = DateTime.now().toLocal();
    return DateTime(now.year, now.month, now.day + 1, 17, 0).toUtc();
  }

  String _draftJson(ReminderFormDraft draft) => jsonEncode(draft.toJson());

  Future<void> _initialize() async {
    if (_initialized) return;
    _initialized = true;
    final notifier = ref.read(createReminderFormProvider.notifier);
    ReminderFormDraft? draft;
    if (_isEdit || widget.copyFromReminderId != null) {
      final id = _isEdit ? widget.editReminderId! : widget.copyFromReminderId!;
      final reminder =
          await ref.read(remindersRepositoryProvider).getById(id);
      if (reminder != null) {
        draft = ReminderFormDraft(
          reminderId: _isEdit ? reminder.id : null,
          title: reminder.title,
          description: reminder.description,
          remindAt: _isEdit ? reminder.remindAt : _defaultDate(),
          recurrenceRule: reminder.recurrenceRule,
          expectedAmountKopecks: reminder.expectedAmount,
          linkedCategoryId: reminder.linkedCategoryId,
          linkedAccountId: reminder.linkedAccountId,
          linkedRecurringId: reminder.linkedRecurringId,
          priority: reminder.priority,
          scope: reminder.spaceId == null ? 'personal' : 'family',
          assigneeId: reminder.assigneeId,
        );
      }
    }
    draft ??= ReminderFormDraft(remindAt: _defaultDate());
    final dateIso = widget.dateIso;
    if (dateIso != null) {
      final parsed = DateTime.tryParse(dateIso);
      if (parsed != null) draft = draft.copyWith(remindAt: parsed.toUtc());
    }
    notifier.load(draft);
    _syncControllers(draft);
    _detectPreset(draft.recurrenceRule);
    if (!_isEdit && mounted) {
      final fresh = await ref
          .read(restoreReminderDraftUseCaseProvider)(
              ref.read(currentUserIdProvider));
      if (fresh != null && mounted) {
        final restore = await showDialog<bool>(
          context: context,
          builder: (d) => AlertDialog(
            title: const Text(RemindersStrings.restoreDraftTitle),
            content: const Text(RemindersStrings.restoreDraftText),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(d).pop(false),
                child: const Text(RemindersStrings.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(d).pop(true),
                child: const Text(RemindersStrings.restoreDraftAction),
              ),
            ],
          ),
        );
        if (restore == true && mounted) {
          notifier.load(fresh);
          _syncControllers(fresh);
          _detectPreset(fresh.recurrenceRule);
        }
      }
    }
    if (widget.type == 'from_recurring' && mounted) {
      await _openSelectRecurringSheet();
    }
    _draftTimer = Timer.periodic(const Duration(seconds: 5), _autosave);
    if (mounted) setState(() {});
  }

  void _syncControllers(ReminderFormDraft draft) {
    _titleController.text = draft.title;
    _descriptionController.text = draft.description ?? '';
    final kopecks = draft.expectedAmountKopecks;
    _amountController.text = kopecks == null ? '' : _formatInput(kopecks);
  }

  String _formatInput(int kopecks) {
    final rub = kopecks ~/ 100;
    final kop = kopecks % 100;
    return '$rub,${kop.toString().padLeft(2, '0')}';
  }

  int? _parseKopecks(String text) {
    final cleaned = text.replaceAll(' ', '').replaceAll('\u00A0', '');
    if (cleaned.isEmpty) return null;
    final parts = cleaned.split(',');
    final rub = int.tryParse(parts[0]) ?? 0;
    final kop = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return rub * 100 + kop;
  }

  void _detectPreset(String? rule) {
    final notifier = ref.read(createReminderRecurrenceProvider.notifier);
    if (rule == null) {
      notifier.setPreset('once');
    } else if (rule == 'FREQ=DAILY') {
      notifier.setPreset('daily');
    } else if (rule == 'FREQ=WEEKLY') {
      notifier.setPreset('weekly');
    } else if (rule.startsWith('FREQ=MONTHLY')) {
      notifier.setPreset('monthly');
    } else if (rule.startsWith('FREQ=YEARLY')) {
      notifier.setPreset('yearly');
    } else {
      notifier.setPreset('custom');
    }
  }

  void _autosave(Timer _) {
    final draft = ref.read(createReminderFormProvider);
    final json = _draftJson(draft);
    if (json == _lastSavedJson) return;
    if (draft.title.trim().isEmpty && draft.description == null) return;
    _lastSavedJson = json;
    ref
        .read(saveReminderDraftUseCaseProvider)(
            ref.read(currentUserIdProvider), draft);
  }

  Future<void> _openSelectRecurringSheet() async {
    final all =
        await ref.read(activeRecurringForLinkProvider.future);
    final available = all.where((r) => r.linkedReminderId == null).toList();
    if (!mounted) return;
    if (available.isEmpty) {
      await showDialog<void>(
        context: context,
        builder: (d) => AlertDialog(
          title: const Text(RemindersStrings.noRecurringTitle),
          content: const Text(RemindersStrings.noRecurringSubtitle),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(d).pop(),
              child: const Text(RemindersStrings.noRecurringAction),
            ),
          ],
        ),
      );
      return;
    }
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final r in available)
              ListTile(
                title: Text(r.merchantName),
                subtitle: Text('~${r.averageDayOfMonth} число'),
                onTap: () => Navigator.of(sheetContext).pop(r.id),
              ),
          ],
        ),
      ),
    );
    if (picked == null || !mounted) return;
    final source = available.firstWhere((r) => r.id == picked);
    final day = source.averageDayOfMonth.clamp(1, 28);
    final now = DateTime.now().toLocal();
    var remindAt = DateTime(now.year, now.month, day, 17, 0);
    if (remindAt.isBefore(now)) {
      remindAt = DateTime(now.year, now.month + 1, day, 17, 0);
    }
    ref.read(createReminderFormProvider.notifier).load(
          ref.read(createReminderFormProvider).copyWith(
                title: source.merchantName,
                expectedAmountKopecks: source.averageAmount,
                linkedRecurringId: source.id,
                remindAt: remindAt.toUtc(),
                recurrenceRule: 'FREQ=MONTHLY;BYMONTHDAY=$day',
              ),
        );
    _syncControllers(ref.read(createReminderFormProvider));
    _detectPreset('FREQ=MONTHLY');
  }

  Future<void> _pickDateTime() async {
    MotionTokens.light();
    final draft = ref.read(createReminderFormProvider);
    final initial = draft.remindAt?.toLocal() ?? _defaultDate().toLocal();
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 3650)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initial),
    );
    if (time == null) return;
    MotionTokens.selection();
    ref.read(createReminderFormProvider.notifier).setRemindAt(
          DateTime(date.year, date.month, date.day, time.hour, time.minute)
              .toUtc(),
        );
  }

  Future<void> _applyPreset(String preset) async {
    final formNotifier = ref.read(createReminderFormProvider.notifier);
    final build = ref.read(buildRRuleUseCaseProvider);
    final at =
        ref.read(createReminderFormProvider).remindAt?.toLocal() ??
            DateTime.now().toLocal();
    ref.read(createReminderRecurrenceProvider.notifier).setPreset(preset);
    switch (preset) {
      case 'once':
        formNotifier.setRecurrenceRule(null);
      case 'daily':
        formNotifier.setRecurrenceRule(
            build(const RecurrenceSettings(freq: RecurrenceFreq.daily)));
      case 'weekly':
        formNotifier.setRecurrenceRule(
            build(const RecurrenceSettings(freq: RecurrenceFreq.weekly)));
      case 'monthly':
        formNotifier.setRecurrenceRule(build(RecurrenceSettings(
            freq: RecurrenceFreq.monthly, byMonthDay: at.day)));
      case 'yearly':
        formNotifier.setRecurrenceRule(build(RecurrenceSettings(
            freq: RecurrenceFreq.yearly, byMonth: at.month, byMonthDay: at.day)));
      case 'custom':
        if (!mounted) return;
        final settings = await showRRuleBuilderSheet(
          context,
          ref.read(createReminderRecurrenceProvider).settings ??
              RecurrenceSettings(byMonthDay: at.day),
        );
        if (settings == null || !mounted) return;
        MotionTokens.medium();
        ref
            .read(createReminderRecurrenceProvider.notifier)
            .setSettings(settings);
        formNotifier.setRecurrenceRule(build(settings));
    }
  }

  Future<void> _save() async {
    final draft = ref.read(createReminderFormProvider);
    final error = ref.read(validateReminderFormUseCaseProvider)(
      draft: draft,
      isNew: !_isEdit,
      nowUtc: DateTime.now().toUtc(),
    );
    final messenger = ScaffoldMessenger.of(context);
    if (error != null) {
      MotionTokens.error();
      messenger.showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    MotionTokens.light();
    final userId = ref.read(currentUserIdProvider);
    final spaceId = ref.read(currentSpaceIdProvider);
    try {
      if (_isEdit) {
        final existing = await ref
            .read(remindersRepositoryProvider)
            .getById(widget.editReminderId!);
        if (existing == null) return;
        final isFamily = draft.scope == 'family' && spaceId != null;
        await ref.read(updateReminderUseCaseProvider)(
          existing.copyWith(
            title: draft.title.trim(),
            description: draft.description,
            remindAt: draft.remindAt!,
            recurrenceRule: draft.recurrenceRule,
            expectedAmount: draft.expectedAmountKopecks,
            linkedCategoryId: draft.linkedCategoryId,
            linkedAccountId: draft.linkedAccountId,
            linkedRecurringId: draft.linkedRecurringId,
            priority: draft.priority,
            spaceId: isFamily ? spaceId : null,
            assigneeId: isFamily ? draft.assigneeId : null,
          ),
        );
      } else {
        final params = ref.read(buildReminderDraftUseCaseProvider)(
          draft: draft,
          userId: userId,
          familySpaceId: spaceId,
        );
        await ref.read(createReminderUseCaseProvider)(params);
      }
      await ref.read(clearReminderDraftUseCaseProvider)(userId);
      MotionTokens.medium();
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(_isEdit
              ? RemindersStrings.snackbarUpdated
              : RemindersStrings.snackbarCreated),
        ),
      );
      context.go('/reminders');
    } catch (e) {
      MotionTokens.error();
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }

  Future<bool> _confirmDiscard() async {
    final draft = ref.read(createReminderFormProvider);
    final dirty = _draftJson(draft) != _lastSavedJson &&
        (draft.title.trim().isNotEmpty || draft.description != null);
    if (!dirty) return true;
    final discard = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        title: const Text(RemindersStrings.cancelConfirmTitle),
        content: const Text(RemindersStrings.cancelConfirmText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(d).pop(false),
            child: const Text(RemindersStrings.cancelContinue),
          ),
          TextButton(
            onPressed: () => Navigator.of(d).pop(true),
            child: const Text(RemindersStrings.cancelDiscard),
          ),
        ],
      ),
    );
    return discard == true;
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(createReminderFormProvider);
    final recurrence = ref.watch(createReminderRecurrenceProvider);
    final spaceId = ref.watch(currentSpaceIdProvider);
    final assignees = ref.watch(assigneeOptionsProvider).value ?? const [];
    final categoriesAsync = ref.watch(
        categoriesGroupedByTypeProvider(ref.watch(currentUserIdProvider)));
    final accountsAsync =
        ref.watch(accountsListProvider(ref.watch(currentUserIdProvider)));
    final recurringAsync = ref.watch(activeRecurringForLinkProvider);
    final expenseCategories = categoriesAsync.value?['expense'] ?? const [];
    final accounts = accountsAsync.value ?? const [];
    final recurring = recurringAsync.value ?? const [];
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final discard = await _confirmDiscard();
        if (discard && context.mounted) context.pop();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(_isEdit
              ? RemindersStrings.editTitle
              : widget.type == 'from_recurring'
                  ? RemindersStrings.fromRecurringTitle
                  : RemindersStrings.createTitle),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              color: AppColors.colorIncome,
              onPressed: _save,
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          children: [
            Text(RemindersStrings.formWhat,
                style: Theme.of(context).textTheme.titleMedium),
            TextField(
              controller: _titleController,
              maxLength: 100,
              decoration: const InputDecoration(
                  hintText: RemindersStrings.formTitleHint),
              onChanged: (v) =>
                  ref.read(createReminderFormProvider.notifier).setTitle(v),
            ),
            TextField(
              controller: _descriptionController,
              maxLength: 500,
              maxLines: 3,
              decoration: const InputDecoration(
                  hintText: RemindersStrings.formDescriptionHint),
              onChanged: (v) => ref
                  .read(createReminderFormProvider.notifier)
                  .setDescription(v),
            ),
            Text(RemindersStrings.formPriority,
                style: Theme.of(context).textTheme.labelLarge),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                    value: 'low', label: Text(RemindersStrings.priorityLow)),
                ButtonSegment(
                    value: 'normal',
                    label: Text(RemindersStrings.priorityNormal)),
                ButtonSegment(
                    value: 'high',
                    label: Text(RemindersStrings.priorityHigh)),
              ],
              selected: {draft.priority},
              onSelectionChanged: (v) {
                MotionTokens.selection();
                ref
                    .read(createReminderFormProvider.notifier)
                    .setPriority(v.first);
              },
            ),
            const SizedBox(height: AppSpacing.spacing24),
            Text(RemindersStrings.formWhen,
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.spacing8),
            OutlinedButton(
              onPressed: _pickDateTime,
              child: Row(
                children: [
                  const Icon(Icons.calendar_month_outlined),
                  const SizedBox(width: AppSpacing.spacing8),
                  Text(
                    draft.remindAt == null
                        ? RemindersStrings.formDateTime
                        : DateFormat('EEEE, d MMMM yyyy, HH:mm', 'ru')
                            .format(draft.remindAt!.toLocal()),
                  ),
                ],
              ),
            ),
            Text(RemindersStrings.formRecurrence,
                style: Theme.of(context).textTheme.labelLarge),
            DropdownButton<String>(
              value: recurrence.preset,
              isExpanded: true,
              items: const [
                DropdownMenuItem(
                    value: 'once',
                    child: Text(RemindersStrings.recurrenceOnce)),
                DropdownMenuItem(
                    value: 'daily',
                    child: Text(RemindersStrings.recurrenceDaily)),
                DropdownMenuItem(
                    value: 'weekly',
                    child: Text(RemindersStrings.recurrenceWeekly)),
                DropdownMenuItem(
                    value: 'monthly',
                    child: Text(RemindersStrings.recurrenceMonthly)),
                DropdownMenuItem(
                    value: 'yearly',
                    child: Text(RemindersStrings.recurrenceYearly)),
                DropdownMenuItem(
                    value: 'custom',
                    child: Text(RemindersStrings.recurrenceCustom)),
              ],
              onChanged: (v) => _applyPreset(v!),
            ),
            if (draft.recurrenceRule != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.spacing4),
                child: Text(
                  '🔁 ${ref.watch(formatRRuleUseCaseProvider)(draft.recurrenceRule)}',
                  style: const TextStyle(color: AppColors.colorTransfer),
                ),
              ),
            const SizedBox(height: AppSpacing.spacing24),
            Text(RemindersStrings.formFinance,
                style: Theme.of(context).textTheme.titleMedium),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              inputFormatters: [MoneyTextInputFormatter()],
              decoration: const InputDecoration(
                  hintText: RemindersStrings.formAmount),
              onChanged: (v) => ref
                  .read(createReminderFormProvider.notifier)
                  .setExpectedAmountKopecks(_parseKopecks(v)),
            ),
            DropdownButton<String?>(
              value: draft.linkedCategoryId,
              isExpanded: true,
              hint: const Text(RemindersStrings.formNoCategory),
              items: [
                const DropdownMenuItem(
                    value: null, child: Text(RemindersStrings.formNoCategory)),
                for (final c in expenseCategories)
                  DropdownMenuItem(value: c.id, child: Text(c.name)),
              ],
              onChanged: (v) => ref
                  .read(createReminderFormProvider.notifier)
                  .setLinkedCategoryId(v),
            ),
            DropdownButton<String?>(
              value: draft.linkedAccountId,
              isExpanded: true,
              hint: const Text(RemindersStrings.formNoAccount),
              items: [
                const DropdownMenuItem(
                    value: null, child: Text(RemindersStrings.formNoAccount)),
                for (final a in accounts)
                  DropdownMenuItem(value: a.id, child: Text(a.customName)),
              ],
              onChanged: (v) => ref
                  .read(createReminderFormProvider.notifier)
                  .setLinkedAccountId(v),
            ),
            const SizedBox(height: AppSpacing.spacing24),
            Text(RemindersStrings.formScope,
                style: Theme.of(context).textTheme.titleMedium),
            SegmentedButton<String>(
              segments: [
                const ButtonSegment(
                    value: 'personal',
                    label: Text(RemindersStrings.scopePersonal)),
                ButtonSegment(
                  value: 'family',
                  label: const Text(RemindersStrings.scopeFamily),
                  enabled: spaceId != null,
                ),
              ],
              selected: {draft.scope},
              onSelectionChanged: (v) {
                MotionTokens.selection();
                ref.read(createReminderFormProvider.notifier).setScope(v.first);
              },
            ),
            const Padding(
              padding: EdgeInsets.only(top: AppSpacing.spacing8),
              child: Text(
                RemindersStrings.scopeHint,
                style:
                    TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ),
            if (draft.scope == 'family') ...[
              const SizedBox(height: AppSpacing.spacing8),
              Text(RemindersStrings.formAssignee,
                  style: Theme.of(context).textTheme.labelLarge),
              DropdownButton<String?>(
                value: draft.assigneeId,
                isExpanded: true,
                items: [
                  const DropdownMenuItem(
                      value: null, child: Text(RemindersStrings.assigneeAll)),
                  for (final o in assignees)
                    DropdownMenuItem(
                        value: o.membershipId, child: Text(o.displayName)),
                ],
                onChanged: (v) => ref
                    .read(createReminderFormProvider.notifier)
                    .setAssigneeId(v),
              ),
            ],
            const SizedBox(height: AppSpacing.spacing24),
            if (draft.scope != 'family') ...[
              Text(RemindersStrings.formLinks,
                  style: Theme.of(context).textTheme.titleMedium),
              DropdownButton<String?>(
                value: draft.linkedRecurringId,
                isExpanded: true,
                hint: const Text(RemindersStrings.noLink),
                items: [
                  const DropdownMenuItem(
                      value: null, child: Text(RemindersStrings.noLink)),
                  for (final r in recurring)
                    DropdownMenuItem(
                      value: r.linkedReminderId != null ? null : r.id,
                      child: Text(
                        r.linkedReminderId != null
                            ? '${r.merchantName} (${RemindersStrings.alreadyHasReminder})'
                            : r.merchantName,
                      ),
                    ),
                ],
                onChanged: (v) => ref
                    .read(createReminderFormProvider.notifier)
                    .setLinkedRecurringId(v),
              ),
              CheckboxListTile(
                value: draft.autoCompleteOnPayment,
                title: const Text(RemindersStrings.formAutoComplete),
                onChanged: (v) => ref
                    .read(createReminderFormProvider.notifier)
                    .setAutoComplete(v ?? true),
              ),
            ],
          ],
        ),
      ),
    );
  }
}