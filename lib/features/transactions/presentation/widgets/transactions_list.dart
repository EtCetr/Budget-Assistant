import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/transaction_day_group.dart';
import '../../domain/entities/transaction_ui_model.dart';
import 'transaction_group_header.dart';
import 'transaction_row.dart';

sealed class _TransactionsListEntry {
  const _TransactionsListEntry();
}

class _HeaderEntry extends _TransactionsListEntry {
  const _HeaderEntry(this.group);

  final TransactionDayGroupUi group;
}

class _RowEntry extends _TransactionsListEntry {
  const _RowEntry(this.transaction);

  final TransactionUiModel transaction;
}

class TransactionsList extends ConsumerStatefulWidget {
  const TransactionsList({
    super.key,
    required this.groups,
    required this.hasMore,
    required this.isLoadingMore,
    required this.onLoadMore,
  });

  final List<TransactionDayGroupUi> groups;
  final bool hasMore;
  final bool isLoadingMore;
  final VoidCallback onLoadMore;

  @override
  ConsumerState<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends ConsumerState<TransactionsList> {
  late final ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScroll);
    _controller.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_controller.hasClients) return;

    final threshold = _controller.position.maxScrollExtent - 250;

    if (_controller.position.pixels >= threshold &&
        widget.hasMore &&
        !widget.isLoadingMore) {
      widget.onLoadMore();
    }
  }

  List<_TransactionsListEntry> _buildEntries() {
    final entries = <_TransactionsListEntry>[];

    for (final group in widget.groups) {
      entries.add(_HeaderEntry(group));

      for (final tx in group.transactions) {
        entries.add(_RowEntry(tx));
      }
    }

    return entries;
  }

  @override
  Widget build(BuildContext context) {
    final entries = _buildEntries();

    return ListView.builder(
      controller: _controller,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: entries.length + (widget.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == entries.length && widget.hasMore) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: widget.isLoadingMore
                  ? const CircularProgressIndicator()
                  : const SizedBox.shrink(),
            ),
          );
        }

        final entry = entries[index];

        return switch (entry) {
          _HeaderEntry(:final group) => TransactionGroupHeader(group: group),
          _RowEntry(:final transaction) => TransactionRow(
            transaction: transaction,
          ),
        };
      },
    );
  }
}
