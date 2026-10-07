import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../features/privacy/domain/models/balance_visibility_mode.dart';
import '../../../../features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/dtos/receipt_match_result.dart';
import '../../domain/dtos/transaction_match_candidate.dart';
import '../labels/receipts_strings.dart';
import '../utils/receipt_money_utils.dart';

/// Секция матчинга чека к операции: сценарии А/Б/В/Г (ТЗ 6.3.23.5).
class TransactionMatchSection extends ConsumerStatefulWidget {
  const TransactionMatchSection({
    super.key,
    required this.match,
    required this.onAttach,
    required this.onSkip,
    required this.onCreateNew,
  });

  final AsyncValue<ReceiptMatchResult?> match;
  final ValueChanged<String> onAttach;
  final VoidCallback onSkip;
  final VoidCallback onCreateNew;

  @override
  ConsumerState<TransactionMatchSection> createState() =>
      _TransactionMatchSectionState();
}

class _TransactionMatchSectionState
    extends ConsumerState<TransactionMatchSection> {
  bool _showList = false;
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                ReceiptsStrings.matchTitle,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              widget.match.when(
                loading: () => const Center(
                    child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                )),
                error: (e, _) => Text('$e'),
                data: (result) {
                  if (result == null) return const SizedBox.shrink();
                  return _buildByScenario(result, mode, formatter);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildByScenario(
    ReceiptMatchResult result,
    BalanceVisibilityMode mode,
    dynamic formatter,
  ) {
    switch (result.scenario) {
      case MatchScenario.pendingBlocked:
        return _pendingCard();
      case MatchScenario.none:
        return _noneButtons();
      case MatchScenario.single:
        if (_showList) return _list(result.autoCandidates, mode, formatter);
        final c = result.autoCandidates.first;
        return Column(
          children: [
            _candidateTile(c, mode, formatter, true, () {}),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onSkip,
                  child: const Text(ReceiptsStrings.matchSkip),
                ),
                TextButton(
                  onPressed: () => setState(() => _showList = true),
                  child: const Text(ReceiptsStrings.matchChooseOther),
                ),
                FilledButton(
                  onPressed: () => widget.onAttach(c.id),
                  child: const Text(ReceiptsStrings.matchAttach),
                ),
              ],
            ),
          ],
        );
      case MatchScenario.multiple:
        return _list(result.autoCandidates, mode, formatter);
    }
  }

  Widget _pendingCard() => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.colorWarning.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          children: [
            Icon(Icons.hourglass_bottom, color: AppColors.colorWarning),
            SizedBox(width: 8),
            Expanded(child: Text(ReceiptsStrings.matchPending)),
          ],
        ),
      );

  Widget _noneButtons() => Column(
        children: [
          const Text(ReceiptsStrings.matchNone),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: widget.onSkip,
                child: const Text(ReceiptsStrings.matchSkip),
              ),
              FilledButton(
                onPressed: widget.onCreateNew,
                child: const Text(ReceiptsStrings.matchCreate),
              ),
            ],
          ),
        ],
      );

  Widget _list(
    List<TransactionMatchCandidate> candidates,
    BalanceVisibilityMode mode,
    dynamic formatter,
  ) {
    return Column(
      children: [
        ...candidates.map((c) => _candidateTile(
              c,
              mode,
              formatter,
              _selectedId == c.id,
              () => setState(() => _selectedId = c.id),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: widget.onSkip,
              child: const Text(ReceiptsStrings.matchSkip),
            ),
            FilledButton(
              onPressed: _selectedId == null
                  ? null
                  : () => widget.onAttach(_selectedId!),
              child: const Text(ReceiptsStrings.matchConfirmSel),
            ),
          ],
        ),
      ],
    );
  }

  Widget _candidateTile(
    TransactionMatchCandidate c,
    BalanceVisibilityMode mode,
    dynamic formatter,
    bool selected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            selected
                ? Icons.radio_button_checked
                : Icons.radio_button_off,
            color: AppColors.colorFAB,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${ReceiptMoneyUtils.formatDateUtc(c.dateUtc)}  ·  '
              '${formatter.formatAmount(c.amountKop, 'RUB', mode)}'
              '${c.hasReceipt ? '  📎' : ''}',
            ),
          ),
        ],
      ),
    );
  }
}