import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/offline_error_card.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../providers/split_transaction_form_providers.dart';
import '../providers/split_transaction_providers.dart';
import '../split_strings.dart';
import '../widgets/source_transaction_card.dart';
import '../widgets/split_action_bar.dart';
import '../widgets/split_bottom_summary.dart';
import '../widgets/split_positions_list.dart';
import '../widgets/unassigned_remainder_card.dart';

/// Экран разделения транзакции по категориям (ТЗ 6.3.15).
///
/// Роут: /transactions/split/:id
class SplitTransactionScreen extends ConsumerStatefulWidget {
  const SplitTransactionScreen({super.key, required this.transactionId});

  final String transactionId;

  @override
  ConsumerState<SplitTransactionScreen> createState() =>
      _SplitTransactionScreenState();
}

class _SplitTransactionScreenState
    extends ConsumerState<SplitTransactionScreen> {
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(_init);
  }

  Future<void> _init() async {
    await ref
        .read(splitTransactionFormProvider.notifier)
        .init(widget.transactionId);
    if (!mounted) return;
    final state = ref.read(splitTransactionFormProvider);
    if (state.draftAvailable) {
      await _offerDraftRestore();
    }
  }

  Future<void> _offerDraftRestore() async {
    HapticFeedback.mediumImpact();
    final restore = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text(SplitStrings.draftRestoreTitle),
        content: const Text(SplitStrings.draftRestoreText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(SplitStrings.draftStartFresh),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(SplitStrings.draftRestoreAction),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (restore == true) {
      await ref.read(splitTransactionFormProvider.notifier).restoreDraft();
    } else {
      await ref.read(splitTransactionFormProvider.notifier).discardDraft();
    }
  }

  Future<void> _close() async {
    final state = ref.read(splitTransactionFormProvider);
    if (state.isDirty) {
      final discard = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text(SplitStrings.cancelTitle),
          content: const Text(SplitStrings.cancelSubtitle),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(SplitStrings.continueEditing),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text(SplitStrings.discardAction),
            ),
          ],
        ),
      );
      if (discard != true || !mounted) return;
    }
    Navigator.of(context).pop();
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    final me = ref.read(currentUserIdProvider);
    setState(() => _saving = true);
    try {
      final state = ref.read(splitTransactionFormProvider);
      await ref.read(createTransactionSplitUseCaseProvider)(
        transactionId: state.transactionId,
        positions: state.positions,
        actorUserId: me,
      );
      await ref.read(updateSplitOfferCountUseCaseProvider)(
        userId: me,
        accepted: true,
      );
      ref.read(splitTransactionFormProvider.notifier).markSaved();
      if (!mounted) return;
      HapticFeedback.heavyImpact();
      messenger.showSnackBar(
        const SnackBar(content: Text(SplitStrings.savedSnack)),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      HapticFeedback.vibrate();
      messenger.showSnackBar(
        SnackBar(
          content: Text('${SplitStrings.operationFailed}: $e'),
          backgroundColor: AppColors.colorExpense,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(splitTransactionFormProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: _close,
        ),
        title: const Text(SplitStrings.screenTitle),
      ),
      body: !state.initialized
          ? ListView(
              padding: const EdgeInsets.all(AppSpacing.spacing16),
              children: const [
                SkeletonShimmer(height: 72),
                SizedBox(height: AppSpacing.spacing12),
                SkeletonShimmer(height: 140),
                SizedBox(height: AppSpacing.spacing12),
                SkeletonShimmer(height: 140),
              ],
            )
          : state.source == null
              ? Center(
                  child: OfflineErrorCard(
                    message: SplitStrings.loadingError,
                    retryLabel: SplitStrings.retry,
                    onRetry: () => ref
                        .read(splitTransactionFormProvider.notifier)
                        .init(widget.transactionId),
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.spacing16),
                      child: SourceTransactionCard(transaction: state.source!),
                    ),
                    if (state.existingSplitsCount > 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.spacing16,
                        ),
                        child: Text(
                          SplitStrings.alreadySplitNote,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.colorWarning),
                        ),
                      ),
                    const Expanded(child: SplitPositionsList()),
                    const UnassignedRemainderCard(),
                    const SplitBottomSummary(),
                    SplitActionBar(onSave: _save, saving: _saving),
                  ],
                ),
    );
  }
}