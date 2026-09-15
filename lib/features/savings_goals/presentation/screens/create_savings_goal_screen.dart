import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/formatting/money_input_parser.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/savings_goal.dart';
import '../../domain/entities/savings_goal_form_draft.dart';
import '../providers/create_savings_goal_providers.dart';
import '../providers/savings_goals_providers.dart';
import '../providers/savings_goals_repository_providers.dart';
import '../savings_goals_strings.dart';
import '../widgets/cancel_confirmation_dialog.dart';
import '../widgets/savings_goal_form_automation_section.dart';
import '../widgets/savings_goal_form_basic_section.dart';
import '../widgets/savings_goal_form_type_section.dart';
import '../widgets/savings_goal_form_visibility_section.dart';
import '../widgets/savings_plan_preview.dart';

/// Экран создания/редактирования цели накопления (ТЗ 6.3.17).
class CreateSavingsGoalScreen extends ConsumerStatefulWidget {
  const CreateSavingsGoalScreen({super.key, this.goalId});

  final String? goalId;

  @override
  ConsumerState<CreateSavingsGoalScreen> createState() =>
      _CreateSavingsGoalScreenState();
}

class _CreateSavingsGoalScreenState
    extends ConsumerState<CreateSavingsGoalScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  bool _initialized = false;
  bool _saving = false;

  bool get _isEdit => widget.goalId != null;

  @override
  void initState() {
    super.initState();
    Future.microtask(_initForm);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _initForm() async {
    await ref
        .read(createSavingsGoalFormProvider.notifier)
        .init(goalId: widget.goalId);
    if (!mounted) return;
    if (!_isEdit) {
      final userId = ref.read(currentUserIdProvider);
      final draft =
          await ref.read(savingsGoalsRepositoryProvider).getFreshDraft(userId);
      if (!mounted) return;
      if (draft != null) {
        await _offerDraftRestore(draft);
        if (!mounted) return;
      }
    }
    setState(() => _initialized = true);
  }

  Future<void> _offerDraftRestore(SavingsGoalFormDraft draft) async {
    HapticFeedback.mediumImpact();
    final restore = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(SavingsGoalsStrings.draftRestoreTitle),
        content: const Text(SavingsGoalsStrings.draftRestoreText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(SavingsGoalsStrings.draftStartFresh),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(SavingsGoalsStrings.draftRestoreAction),
          ),
        ],
      ),
    );
    final userId = ref.read(currentUserIdProvider);
    if (restore == true) {
      ref.read(createSavingsGoalFormProvider.notifier).applyDraft(draft);
    } else {
      await ref.read(savingsGoalsRepositoryProvider).deleteDraftByUser(userId);
    }
  }

  Future<void> _close() async {
    final form = ref.read(createSavingsGoalFormProvider);
    if (form.isDirty) {
      final discard =
          await showCancelConfirmationDialog(context, isEdit: _isEdit);
      if (!discard || !mounted) return;
    }
    Navigator.of(context).pop();
  }

  Future<void> _save() async {
    HapticFeedback.lightImpact();
    final validationError = ref.read(createGoalValidationErrorProvider);
    if (validationError != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(validationError)));
      return;
    }
    final form = ref.read(createSavingsGoalFormProvider);
    final amount = MoneyInputParser.parseKopecks(form.amountText);
    if (amount == null || amount <= 0) return;
    final trimmedName = form.name.trim();
    final finalName =
        form.emoji.isEmpty ? trimmedName : '${form.emoji} $trimmedName';
    final userId = ref.read(currentUserIdProvider);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _saving = true);
    try {
      final String successMessage;
      if (form.goalId == null) {
        final spaceId = ref.read(createGoalSpaceIdProvider);
        await ref.read(createSavingsGoalUseCaseProvider)(
          userId: userId,
          name: finalName,
          targetAmountKopecks: amount,
          currency: form.currency,
          deadline: form.deadline,
          linkedAccountId: form.goalType == SavingsGoalType.linked
              ? form.linkedAccountId
              : null,
          autoReminderEnabled: form.autoReminderEnabled,
          spaceId: spaceId,
        );
        successMessage = SavingsGoalsStrings.goalCreatedSnack;
      } else {
        final goal = ref.read(editSavingsGoalProvider(form.goalId!)).value;
        if (goal == null) {
          throw StateError('Goal for edit is not loaded');
        }
        await ref.read(updateSavingsGoalUseCaseProvider)(
          goal: goal,
          newName: finalName,
          newTargetAmountKopecks: amount,
          newDeadline: form.deadline,
          newLinkedAccountId: form.goalType == SavingsGoalType.linked
              ? form.linkedAccountId
              : null,
          newAutoReminderEnabled: form.autoReminderEnabled,
        );
        successMessage = SavingsGoalsStrings.goalUpdatedSnack;
      }
      ref.read(createSavingsGoalFormProvider.notifier).markSaved();
      await ref.read(savingsGoalsRepositoryProvider).deleteDraftByUser(userId);
      if (!mounted) return;
      HapticFeedback.mediumImpact();
      messenger.showSnackBar(SnackBar(
        content:
            Text('$successMessage. ${SavingsGoalsStrings.syncLaterNote}'),
      ));
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      HapticFeedback.vibrate();
      messenger.showSnackBar(const SnackBar(
        content: Text(SavingsGoalsStrings.operationFailed),
      ));
    }
  }

  void _showPrivacySheet() {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(SavingsGoalsStrings.privacyVisible),
                onTap: () {
                  ref
                      .read(privacyModeProvider.notifier)
                      .setMode(BalanceVisibilityMode.visible);
                  Navigator.of(sheetContext).pop();
                },
              ),
              ListTile(
                title: const Text(SavingsGoalsStrings.privacyPartial),
                onTap: () {
                  ref
                      .read(privacyModeProvider.notifier)
                      .setMode(BalanceVisibilityMode.partial);
                  Navigator.of(sheetContext).pop();
                },
              ),
              ListTile(
                title: const Text(SavingsGoalsStrings.privacyHidden),
                onTap: () {
                  ref
                      .read(privacyModeProvider.notifier)
                      .setMode(BalanceVisibilityMode.hidden);
                  Navigator.of(sheetContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final privacyMode = ref.watch(privacyModeProvider);
    final validationError = ref.watch(createGoalValidationErrorProvider);

    ref.listen(createSavingsGoalFormProvider, (_, next) {
      if (_nameController.text != next.name) {
        _nameController.text = next.name;
      }
      if (_amountController.text != next.amountText) {
        _amountController.text = next.amountText;
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _close,
        ),
        title: Text(
          _isEdit
              ? SavingsGoalsStrings.editGoalTitle
              : SavingsGoalsStrings.newGoalTitle,
        ),
        actions: [
          GestureDetector(
            onLongPress: _showPrivacySheet,
            child: IconButton(
              icon: Icon(
                privacyMode == BalanceVisibilityMode.hidden
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                ref.read(privacyModeProvider.notifier).toggle();
              },
            ),
          ),
          TextButton(
            onPressed:
                (_initialized && !_saving && validationError == null)
                    ? _save
                    : null,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    _isEdit
                        ? SavingsGoalsStrings.updateAction
                        : SavingsGoalsStrings.saveAction,
                  ),
          ),
          const SizedBox(width: AppSpacing.spacing8),
        ],
      ),
      body: !_initialized
          ? ListView(
              padding: const EdgeInsets.all(AppSpacing.spacing16),
              children: const [
                SkeletonShimmer(height: 120),
                SizedBox(height: AppSpacing.spacing12),
                SkeletonShimmer(height: 180),
                SizedBox(height: AppSpacing.spacing12),
                SkeletonShimmer(height: 120),
              ],
            )
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.spacing16),
              children: [
                if (_isEdit) const _CurrentAmountRow(),
                SavingsGoalFormBasicSection(
                  nameController: _nameController,
                  amountController: _amountController,
                ),
                const SizedBox(height: AppSpacing.spacing12),
                const SavingsPlanPreview(),
                const SizedBox(height: AppSpacing.spacing24),
                const SavingsGoalFormTypeSection(),
                const SizedBox(height: AppSpacing.spacing24),
                const SavingsGoalFormAutomationSection(),
                const SizedBox(height: AppSpacing.spacing24),
                const SavingsGoalFormVisibilitySection(),
                const SizedBox(height: AppSpacing.spacing32),
              ],
            ),
    );
  }
}

class _CurrentAmountRow extends ConsumerWidget {
  const _CurrentAmountRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = ref.watch(createSavingsGoalFormProvider);
    final goalId = form.goalId;
    if (goalId == null) return const SizedBox.shrink();
    final goal = ref.watch(editSavingsGoalProvider(goalId)).value;
    if (goal == null) return const SizedBox.shrink();
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacing16),
      padding: const EdgeInsets.all(AppSpacing.spacing12),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppRadius.radiusMd),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.lock_outline,
            size: 16,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.spacing8),
          Text(
            SavingsGoalsStrings.currentAmountLabel,
            style: theme.textTheme.labelMedium
                ?.copyWith(color: AppColors.textSecondary),
          ),
          const Spacer(),
          Tooltip(
            message: SavingsGoalsStrings.currentAmountTooltip,
            child: Text(
              formatter.formatAmount(goal.currentAmount, goal.currency, mode),
              style: theme.textTheme.titleSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}