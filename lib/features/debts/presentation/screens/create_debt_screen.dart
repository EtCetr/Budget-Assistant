import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/formatting/money_input_parser.dart';
import 'package:budget_assistant/core/providers/security_providers.dart';
import 'package:budget_assistant/core/router/routes.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../debts_strings.dart';
import '../providers/create_debt_providers.dart';
import '../providers/debts_providers.dart';
import '../providers/debts_repository_providers.dart';
import '../widgets/debt_cancel_confirmation_dialog.dart';
import '../widgets/debt_form_counterparty_section.dart';
import '../widgets/debt_form_details_section.dart';
import '../widgets/debt_form_links_section.dart';
import '../widgets/debt_form_type_section.dart';
import '../widgets/debt_live_preview.dart';

/// Экран создания/редактирования долга (ТЗ 6.3.14).
///
/// Роут: /debts/create?id=:debtId&transaction_id=:id&split_id=:id
class CreateDebtScreen extends ConsumerStatefulWidget {
  const CreateDebtScreen({
    super.key,
    this.debtId,
    this.transactionId,
    this.splitId,
  });

  final String? debtId;
  final String? transactionId;
  final String? splitId;

  @override
  ConsumerState<CreateDebtScreen> createState() => _CreateDebtScreenState();
}

class _CreateDebtScreenState extends ConsumerState<CreateDebtScreen> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _externalController = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_init);
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _externalController.dispose();
    super.dispose();
  }

  /// Пустая строка из query-параметров GoRouter = параметр отсутствует.
  String? _nullIfEmpty(String? v) => (v == null || v.isEmpty) ? null : v;

  Future<void> _init() async {
    await ref.read(createDebtFormProvider.notifier).init(
          debtId: _nullIfEmpty(widget.debtId),
          transactionId: _nullIfEmpty(widget.transactionId),
          splitId: _nullIfEmpty(widget.splitId),
        );
    if (!mounted) return;
    final isCreatePlain = _nullIfEmpty(widget.debtId) == null &&
        _nullIfEmpty(widget.transactionId) == null &&
        _nullIfEmpty(widget.splitId) == null;
    if (isCreatePlain) {
      final userId = ref.read(currentUserIdProvider);
      final draft =
          await ref.read(debtsRepositoryProvider).getFreshDraft(userId);
      if (!mounted) return;
      if (draft != null) {
        await _offerDraftRestore(draft);
      }
    }
  }

  Future<void> _offerDraftRestore(dynamic draft) async {
    HapticFeedback.mediumImpact();
    final restore = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(DebtsStrings.draftRestoreTitle),
        content: const Text(DebtsStrings.draftRestoreText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(DebtsStrings.draftStartFresh),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(DebtsStrings.draftRestoreAction),
          ),
        ],
      ),
    );
    final userId = ref.read(currentUserIdProvider);
    if (restore == true) {
      ref.read(createDebtFormProvider.notifier).applyDraft(draft);
    } else {
      await ref.read(debtsRepositoryProvider).deleteDraftByUser(userId);
    }
  }

  Future<void> _close() async {
    final form = ref.read(createDebtFormProvider);
    if (form.isDirty) {
      final discard =
          await showDebtCancelConfirmationDialog(context, isEdit: form.isEdit);
      if (!discard || !mounted) return;
    }
    Navigator.of(context).pop();
  }

  String _title() {
    if (_nullIfEmpty(widget.debtId) != null) {
      return DebtsStrings.formTitleEdit;
    }
    if (_nullIfEmpty(widget.transactionId) != null ||
        _nullIfEmpty(widget.splitId) != null) {
      return DebtsStrings.formTitleFromTransaction;
    }
    return DebtsStrings.formTitleNew;
  }

  Future<void> _save() async {
    HapticFeedback.lightImpact();
    final messenger = ScaffoldMessenger.of(context);
    final validationError = ref.read(createDebtValidationProvider);
    if (validationError != null) {
      messenger.showSnackBar(SnackBar(content: Text(validationError)));
      return;
    }
    final form = ref.read(createDebtFormProvider);
    final me = ref.read(currentUserIdProvider);
    final amount = MoneyInputParser.parseKopecks(form.amountText)!;
    final declined =
        ref.read(declineNameUseCaseProvider)(form.externalName).dative;
    setState(() => _saving = true);
    try {
      if (form.isEdit) {
        final existing =
            await ref.read(editDebtForFormProvider(form.debtId!).future);
        if (existing == null) throw StateError('Debt not found for edit');
        final otherId =
            existing.debtorId == me ? existing.creditorId : existing.debtorId;
        final familyId = form.counterpartyType == 'family_member'
            ? (form.selectedMemberIds.isEmpty
                ? otherId
                : form.selectedMemberIds.first)
            : null;
        final updated = existing.copyWith(
          debtorId: form.counterpartyType == 'external'
              ? (form.debtType == 'payable' ? me : null)
              : (form.debtType == 'payable' ? me : familyId),
          creditorId: form.counterpartyType == 'external'
              ? (form.debtType == 'payable' ? null : me)
              : (form.debtType == 'payable' ? familyId : me),
          counterpartyNameDative:
              form.counterpartyType == 'external' ? declined : null,
          amount: amount,
          currency: form.currency,
          categoryId: form.categoryId,
          description: form.description.trim().isEmpty
              ? null
              : form.description.trim(),
          dueDate: form.dueDate,
          autoResolve: form.autoResolve,
          updatedAt: DateTime.now().toUtc(),
        );
        await ref.read(updateDebtUseCaseProvider)(
          debt: updated,
          actorUserId: me,
        );
        if (!mounted) return;
        HapticFeedback.mediumImpact();
        messenger.showSnackBar(
          const SnackBar(content: Text(DebtsStrings.debtUpdatedSnack)),
        );
      } else {
        final spaceId = form.counterpartyType == 'family_member'
            ? ref.read(currentSpaceIdProvider)
            : null;
        final created = await ref.read(createDebtsBatchUseCaseProvider)(
          creatorUserId: me,
          spaceId: spaceId,
          debtType: form.debtType,
          memberIds: form.counterpartyType == 'family_member'
              ? form.selectedMemberIds
              : const <String>[],
          externalNameDative:
              form.counterpartyType == 'external' ? declined : null,
          amountKopecks: amount,
          currency: form.currency,
          categoryId: form.categoryId,
          description: form.description.trim().isEmpty
              ? null
              : form.description.trim(),
          dueDateUtc: form.dueDate,
          originalTransactionId: form.linkedTransactionId,
          splitId: form.linkedSplitId,
          autoResolve: form.autoResolve,
        );
        if (!mounted) return;
        created.length == 1
            ? HapticFeedback.mediumImpact()
            : HapticFeedback.heavyImpact();
        messenger.showSnackBar(SnackBar(
          content: Text(created.length == 1
              ? DebtsStrings.debtCreatedSnack
              : '${DebtsStrings.debtsCreatedSnack}: ${created.length}'),
        ));
      }
      ref.read(createDebtFormProvider.notifier).markSaved();
      await ref.read(debtsRepositoryProvider).deleteDraftByUser(me);
      if (!mounted) return;
      // Возврат на список долгов без слома стека навигации.
      if (context.canPop()) {
        context.pop();
      } else {
        context.go(AppRoutes.home);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      HapticFeedback.vibrate();
      messenger.showSnackBar(
        SnackBar(
          content: Text('${DebtsStrings.operationFailed}: $e'),
          backgroundColor: AppColors.colorExpense,
        ),
      );
    }
  }

  void _showPrivacySheet() {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        final current = ref.read(privacyModeProvider);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                selected: current == BalanceVisibilityMode.visible,
                leading: const Icon(Icons.visibility),
                title: const Text(DebtsStrings.privacyVisible),
                onTap: () {
                  ref
                      .read(privacyModeProvider.notifier)
                      .setMode(BalanceVisibilityMode.visible);
                  Navigator.of(sheetContext).pop();
                },
              ),
              ListTile(
                selected: current == BalanceVisibilityMode.partial,
                leading: const Icon(Icons.visibility_outlined),
                title: const Text(DebtsStrings.privacyPartial),
                onTap: () {
                  ref
                      .read(privacyModeProvider.notifier)
                      .setMode(BalanceVisibilityMode.partial);
                  Navigator.of(sheetContext).pop();
                },
              ),
              ListTile(
                selected: current == BalanceVisibilityMode.hidden,
                leading: const Icon(Icons.visibility_off),
                title: const Text(DebtsStrings.privacyHidden),
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
    final form = ref.watch(createDebtFormProvider);
    final validationError = ref.watch(createDebtValidationProvider);
    final privacyMode = ref.watch(privacyModeProvider);
    ref.listen(createDebtFormProvider, (_, next) {
      if (_amountController.text != next.amountText) {
        _amountController.text = next.amountText;
      }
      if (_descriptionController.text != next.description) {
        _descriptionController.text = next.description;
      }
      if (_externalController.text != next.externalName) {
        _externalController.text = next.externalName;
      }
    });
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _close,
        ),
        title: Text(_title()),
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
            onPressed: (form.initialized && !_saving && validationError == null)
                ? _save
                : null,
            child: _saving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    form.isEdit
                        ? DebtsStrings.updateAction
                        : DebtsStrings.saveAction,
                  ),
          ),
          const SizedBox(width: AppSpacing.spacing8),
        ],
      ),
      body: !form.initialized
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
                const DebtFormTypeSection(),
                const SizedBox(height: AppSpacing.spacing24),
                DebtFormCounterpartySection(
                  externalController: _externalController,
                ),
                const SizedBox(height: AppSpacing.spacing24),
                DebtFormDetailsSection(
                  amountController: _amountController,
                  descriptionController: _descriptionController,
                ),
                const SizedBox(height: AppSpacing.spacing16),
                const DebtLivePreview(),
                const SizedBox(height: AppSpacing.spacing24),
                const DebtFormLinksSection(),
                const SizedBox(height: AppSpacing.spacing32),
              ],
            ),
    );
  }
}