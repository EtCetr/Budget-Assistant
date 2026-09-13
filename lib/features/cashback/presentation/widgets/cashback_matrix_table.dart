import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/cashback_account_ref.dart';
import '../../domain/entities/cashback_matrix_models.dart';
import '../providers/cashback_providers.dart';

/// Матрица выгоды: сравнительная таблица «категория x карта».
///
/// Ячейка: процент кэшбэка + фактический кэшбэк за цикл + статус.
/// Лучшая карта по категории (макс. процент) подсвечивается рамкой.
/// Статус переключается тапом по иконке: potential <-> approved.
class CashbackMatrixTable extends ConsumerWidget {
  const CashbackMatrixTable({
    super.key,
    required this.rows,
    required this.accounts,
  });

  final List<CashbackMatrixRow> rows;
  final List<CashbackAccountRef> accounts;

  static const double _catWidth = 128;
  static const double _cellWidth = 108;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(privacyFormatterProvider);
    final mode = ref.watch(privacyModeProvider);
    if (rows.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Категории кэшбэка не настроены.\nДобавьте их в режиме «По картам».',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(),
                  for (final row in rows)
                    _row(context, ref, row, formatter, mode),
                ],
              ),
            ),
          ),
        ),
        _legend(context),
      ],
    );
  }

  Widget _header() {
    return Row(
      children: [
        const SizedBox(
          width: _catWidth,
          child: Text(
            'Категория',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        for (final a in accounts)
          SizedBox(
            width: _cellWidth,
            child: Text(
              '${a.name}\n(${a.currency})',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _row(
    BuildContext context,
    WidgetRef ref,
    CashbackMatrixRow row,
    dynamic formatter,
    dynamic mode,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: _catWidth,
            child: Text(
              row.categoryName,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
          ),
          for (final cell in row.cells)
            _cell(
              context,
              ref,
              cell,
              cell.accountId == row.bestAccountId && cell.percentBps != null,
              formatter,
              mode,
            ),
        ],
      ),
    );
  }

  Widget _cell(
    BuildContext context,
    WidgetRef ref,
    CashbackMatrixCell cell,
    bool isBest,
    dynamic formatter,
    dynamic mode,
  ) {
    final theme = Theme.of(context);
    final Widget content;
    if (cell.percentBps == null) {
      content = const Text('—', style: TextStyle(color: Colors.grey));
    } else {
      final percent = formatter.formatPercentBps(cell.percentBps!, mode);
      final cashback =
          formatter.formatAmount(cell.cashbackKopecks ?? 0, cell.currency, mode);
      content = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            percent,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: isBest ? theme.colorScheme.primary : null,
            ),
          ),
          const SizedBox(height: 2),
          Text(cashback, style: theme.textTheme.bodySmall),
          const SizedBox(height: 2),
          _statusIcon(context, ref, cell),
        ],
      );
    }
    return SizedBox(
      width: _cellWidth,
      child: Container(
        margin: const EdgeInsets.all(3),
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        decoration: BoxDecoration(
          color: isBest
              ? theme.colorScheme.primary.withValues(alpha: 0.10)
              : null,
          border: isBest
              ? Border.all(color: theme.colorScheme.primary, width: 1.5)
              : Border.all(color: theme.dividerColor.withValues(alpha: 0.4)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(child: content),
      ),
    );
  }

  Widget _statusIcon(
    BuildContext context,
    WidgetRef ref,
    CashbackMatrixCell cell,
  ) {
    final approved = cell.status == 'approved';
    return IconButton(
      tooltip: approved
          ? 'Подтверждён (approved). Тап — вернуть в «Начислен»'
          : 'Начислен (potential). Тап — подтвердить',
      icon: Icon(
        approved ? Icons.verified : Icons.hourglass_bottom,
        size: 16,
        color: approved ? Colors.green : Colors.orange,
      ),
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: cell.entryId == null
          ? null
          : () => _toggleStatus(context, ref, cell),
    );
  }

  Future<void> _toggleStatus(
    BuildContext context,
    WidgetRef ref,
    CashbackMatrixCell cell,
  ) async {
    final next = cell.status == 'approved' ? 'potential' : 'approved';
    try {
      final result = await ref.read(updateCashbackEntryStatusUseCaseProvider)(
        entryId: cell.entryId!,
        status: next,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            result.isSuccess
                ? (next == 'approved'
                    ? 'Кэшбэк подтверждён'
                    : 'Возвращено в «Начислен»')
                : 'Не удалось изменить статус',
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось изменить статус')),
      );
    }
  }

  Widget _legend(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      child: Row(
        children: [
          const Icon(Icons.hourglass_bottom, size: 14, color: Colors.orange),
          const SizedBox(width: 4),
          const Text('Начислен', style: TextStyle(fontSize: 11)),
          const SizedBox(width: 12),
          const Icon(Icons.verified, size: 14, color: Colors.green),
          const SizedBox(width: 4),
          const Text('Подтверждён', style: TextStyle(fontSize: 11)),
          const SizedBox(width: 12),
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.primary,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 4),
          const Text('лучший %', style: TextStyle(fontSize: 11)),
        ],
      ),
    );
  }
}