import 'package:flutter/material.dart';

import '../../domain/entities/transactions_filter_state.dart';
import '../labels/transactions_log_labels.dart';

class TransactionsSegmentedControl extends StatelessWidget {
  const TransactionsSegmentedControl({
    super.key,
    required this.scope,
    required this.onChanged,
  });

  final TransactionsScope scope;
  final ValueChanged<TransactionsScope> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SegmentedButton<TransactionsScope>(
        segments: const [
          ButtonSegment(
            value: TransactionsScope.all,
            label: Text(TransactionsLogLabels.scopeAll),
          ),
          ButtonSegment(
            value: TransactionsScope.mine,
            label: Text(TransactionsLogLabels.scopeMine),
          ),
          ButtonSegment(
            value: TransactionsScope.family,
            label: Text(TransactionsLogLabels.scopeFamily),
          ),
        ],
        selected: {scope},
        onSelectionChanged: (selection) {
          onChanged(selection.first);
        },
      ),
    );
  }
}
