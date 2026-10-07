import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import 'package:budget_assistant/features/transactions/domain/entities/split_position_draft.dart';
import '../../domain/dtos/receipt_bundle.dart';
import '../../domain/dtos/receipt_category_lookup.dart';
import '../labels/receipts_strings.dart';
import '../providers/receipt_preview_providers.dart';
import '../providers/receipts_providers.dart';
import '../providers/split_receipt_providers.dart';
import '../utils/receipt_money_utils.dart';

/// Этап 16.5 (ТЗ 6.3.48): разделение привязанного чека по категориям.
/// Позиции -> transaction_splits; исходная транзакция is_split=TRUE.
class SplitReceiptScreen extends ConsumerStatefulWidget {
  const SplitReceiptScreen({super.key, required this.receiptId});

  final String receiptId;

  @override
  ConsumerState<SplitReceiptScreen> createState() => _SplitReceiptScreenState();
}

class _SplitReceiptScreenState extends ConsumerState<SplitReceiptScreen> {
  bool _initialized = false;
  bool _changed = false;
  bool _saving = false;
  bool _showBanner = true;
  List<SplitPositionDraft> _positions = [];
  ReceiptBundle? _lastBundle;

  List<SplitPositionDraft> _fromItems(ReceiptBundle bundle) {
    return [
      for (final i in bundle.items)
        if (!i.isExcluded && i.totalPrice > 0)
          SplitPositionDraft(
            id: i.id,
            name: i.originalName,
            amount: i.totalPrice,
            categoryId: i.categoryId,
            fromOcr: true,
          ),
    ];
  }

  Future<void> _init(ReceiptBundle bundle) async {
    final txId = bundle.receipt.transactionId;
    List<SplitPositionDraft>? draft;
    if (txId != null) {
      draft =
          await ref.read(receiptsRepositoryProvider).getFreshSplitDraft(txId);
    }
    if (!mounted) return;
    setState(() {
      _initialized = true;
      _positions = _fromItems(bundle);
    });
    if (draft != null && draft.isNotEmpty && mounted) {
      final restore = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text(ReceiptsStrings.splitRestoreTitle),
          content: const Text(ReceiptsStrings.splitRestoreText),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text(ReceiptsStrings.splitRestoreNo),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text(ReceiptsStrings.splitRestoreYes),
            ),
          ],
        ),
      );
      if (restore == true && mounted) {
        setState(() => _positions = draft!);
      }
    }
  }

  void _update(void Function() fn) {
    setState(fn);
    _changed = true;
    _persistDraft();
  }

  void _persistDraft() {
    final txId = _lastBundle?.receipt.transactionId;
    if (txId == null) return;
    ref.read(receiptsRepositoryProvider).saveSplitDraft(txId, _positions);
  }

  void _move(int index, int delta) {
    MotionTokens.selection();
    _update(() {
      final item = _positions.removeAt(index);
      _positions.insert(index + delta, item);
    });
  }

  Future<void> _pickCategory(SplitPositionDraft p) async {
    MotionTokens.light();
    final categories = ref.read(receiptCategoriesProvider).asData?.value ??
        const <ReceiptCategoryLookup>[];
    final picked = await showDialog<ReceiptCategoryLookup>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(ReceiptsStrings.splitPickCategory),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final cVal in categories)
                ListTile(
                  dense: true,
                  title: Text(cVal.iconEmoji == null
                      ? cVal.name
                      : '${cVal.iconEmoji} ${cVal.name}'),
                  onTap: () => Navigator.of(ctx).pop(cVal),
                ),
            ],
          ),
        ),
      ),
    );
    if (picked != null) {
      MotionTokens.selection();
      _update(() {
        _positions = [
          for (final x in _positions)
            if (x.id == p.id) x.copyWith(categoryId: picked.id) else x
        ];
      });
    }
  }

  Future<void> _pickCategoryForRemainder(int remainder) async {
    final categories = ref.read(receiptCategoriesProvider).asData?.value ??
        const <ReceiptCategoryLookup>[];
    final picked = await showDialog<ReceiptCategoryLookup>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(ReceiptsStrings.splitPickCategory),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final cVal in categories)
                ListTile(
                  dense: true,
                  title: Text(cVal.iconEmoji == null
                      ? cVal.name
                      : '${cVal.iconEmoji} ${cVal.name}'),
                  onTap: () => Navigator.of(ctx).pop(cVal),
                ),
            ],
          ),
        ),
      ),
    );
    if (picked != null) {
      MotionTokens.selection();
      _update(() {
        _positions.add(SplitPositionDraft(
          id: const Uuid().v4(),
          name: ReceiptsStrings.splitRemainderPosition,
          amount: remainder,
          categoryId: picked.id,
          fromOcr: false,
        ));
      });
    }
  }

  Future<void> _cancel() async {
    MotionTokens.light();
    final confirm = _changed
        ? await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text(ReceiptsStrings.splitConfirmCancelTitle),
              content: const Text(ReceiptsStrings.splitConfirmCancelText),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text(ReceiptsStrings.splitCancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text(ReceiptsStrings.splitCancel),
                ),
              ],
            ),
          )
        : true;
    if (confirm != true || !mounted) return;
    await ref
        .read(receiptsRepositoryProvider)
        .recordSplitDecision(ref.read(currentUserIdProvider), accepted: false);
    if (mounted) context.pop();
  }

  String _mapError(Object e) {
    if (e is FormatException) {
      switch (e.message) {
        case 'MIN_TWO_POSITIONS':
          return ReceiptsStrings.splitMinTwo;
        case 'SUM_MISMATCH':
          return ReceiptsStrings.splitSumMismatch;
        case 'MISSING_CATEGORY':
          return ReceiptsStrings.splitMissingCategory;
      }
    }
    return ReceiptsStrings.splitError;
  }

  Future<void> _split() async {
    MotionTokens.light();
    setState(() => _saving = true);
    try {
      await ref.read(splitReceiptUseCaseProvider)(
        receiptId: widget.receiptId,
        positions: _positions,
        actorUserId: ref.read(currentUserIdProvider),
      );
      await ref
          .read(receiptsRepositoryProvider)
          .recordSplitDecision(ref.read(currentUserIdProvider), accepted: true);
      if (!mounted) return;
      MotionTokens.heavy();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(ReceiptsStrings.splitSaved)),
      );
      context.go('/transactions');
    } catch (e) {
      if (!mounted) return;
      MotionTokens.error();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(_mapError(e))));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bundleAsync = ref.watch(receiptBundleProvider(widget.receiptId));
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final categories =
        ref.watch(receiptCategoriesProvider).asData?.value ??
            const <ReceiptCategoryLookup>[];
    return Scaffold(
      appBar: AppBar(
        title: const Text(ReceiptsStrings.splitTitle),
        actions: [
          IconButton(
            icon: Icon(mode == BalanceVisibilityMode.hidden
                ? Icons.visibility_off
                : Icons.visibility),
            onPressed: () {
              MotionTokens.light();
              ref.read(privacyModeProvider.notifier).toggle();
            },
          ),
        ],
      ),
      body: bundleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (bundle) {
          if (bundle == null) {
            return const Center(child: Text(ReceiptsStrings.splitNotFound));
          }
          _lastBundle = bundle;
          if (!_initialized) {
            _init(bundle);
            return const Center(child: CircularProgressIndicator());
          }
          return _buildBody(bundle, mode, formatter, categories);
        },
      ),
    );
  }

  Widget _buildBody(
    ReceiptBundle bundle,
    BalanceVisibilityMode mode,
    dynamic formatter,
    List<ReceiptCategoryLookup> categories,
  ) {
    final receipt = bundle.receipt;
    if (receipt.transactionId == null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(ReceiptsStrings.splitNeedLink),
        ),
      );
    }
    final sum = _positions.fold<int>(0, (a, p) => a + p.amount);
    final remainder = receipt.totalAmount - sum;
    final canSplit = _positions.length >= 2 &&
        remainder == 0 &&
        _positions.every((p) => p.amount > 0 && p.categoryId != null);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatter.formatMerchant(receipt.storeName, mode),
                          style:
                              const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ReceiptMoneyUtils.formatDateUtc(receipt.receiptDate),
                          style: const TextStyle(
                              color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    formatter.formatAmount(
                        receipt.totalAmount, receipt.currency, mode),
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.colorExpense),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (_showBanner)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.lightbulb_outline,
                        color: AppColors.colorTransfer),
                    const SizedBox(width: 8),
                    const Expanded(
                        child: Text(ReceiptsStrings.splitInfoBanner)),
                    IconButton(
                      icon: const Icon(Icons.close, size: 18),
                      onPressed: () => setState(() => _showBanner = false),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Expanded(
          child: _positions.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(ReceiptsStrings.splitNoPositions),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    for (var i = 0; i < _positions.length; i++)
                      _card(_positions[i], mode, formatter, categories, i),
                  ],
                ),
        ),
        if (remainder > 0)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber,
                        color: AppColors.colorWarning),
                    const SizedBox(width: 8),
                    const Expanded(
                        child: Text(ReceiptsStrings.splitRemainder)),
                    Text(
                      formatter.formatAmount(
                          remainder, receipt.currency, mode),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () => _pickCategoryForRemainder(remainder),
                      child: const Text(ReceiptsStrings.splitPickCategory),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: OutlinedButton.icon(
            onPressed: () {
              MotionTokens.light();
              _update(() {
                _positions.add(SplitPositionDraft(
                  id: const Uuid().v4(),
                  name: '',
                  amount: 0,
                  categoryId: null,
                  fromOcr: false,
                ));
              });
            },
            icon: const Icon(Icons.add),
            label: const Text(ReceiptsStrings.splitAdd),
          ),
        ),
        Container(
          color: AppColors.surfaceCard,
          padding: const EdgeInsets.all(16),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${ReceiptsStrings.splitSumPositions}: '
                      '${formatter.formatAmount(sum, receipt.currency, mode)}',
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${ReceiptsStrings.splitSumReceipt}: '
                          '${formatter.formatAmount(receipt.totalAmount, receipt.currency, mode)}',
                        ),
                        const SizedBox(width: 6),
                        Icon(
                          remainder == 0
                              ? Icons.check_circle
                              : Icons.warning_amber,
                          size: 18,
                          color: remainder == 0
                              ? AppColors.colorIncome
                              : AppColors.colorExpense,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _saving ? null : _cancel,
                        child: const Text(ReceiptsStrings.splitCancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: canSplit && !_saving ? _split : null,
                        child: _saving
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text(ReceiptsStrings.splitDo),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _card(
    SplitPositionDraft p,
    BalanceVisibilityMode mode,
    dynamic formatter,
    List<ReceiptCategoryLookup> categories,
    int index,
  ) {
    String? catLabel;
    for (final cVal in categories) {
      if (cVal.id == p.categoryId) {
        catLabel = cVal.iconEmoji == null
            ? cVal.name
            : '${cVal.iconEmoji} ${cVal.name}';
      }
    }
    return Card(
      key: ValueKey(p.id),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    formatter.text(p.name, mode, fallback: '-'),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_upward, size: 18),
                  onPressed: index == 0 ? null : () => _move(index, -1),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_downward, size: 18),
                  onPressed: index == _positions.length - 1
                      ? null
                      : () => _move(index, 1),
                ),
                IconButton(
                  icon: const Icon(Icons.close,
                      color: AppColors.colorExpense, size: 20),
                  onPressed: () {
                    MotionTokens.medium();
                    _update(() {
                      _positions = [
                        for (final x in _positions)
                          if (x.id != p.id) x
                      ];
                    });
                  },
                ),
              ],
            ),
            Row(
              children: [
                SizedBox(
                  width: 110,
                  child: TextFormField(
                    key: ValueKey('amt_${p.id}'),
                    initialValue: ReceiptMoneyUtils.formatKop(p.amount),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        isDense: true, labelText: 'Сумма'),
                    onChanged: (v) {
                      final kop = ReceiptMoneyUtils.parseKop(v);
                      if (kop != null) {
                        _update(() {
                          _positions = [
                            for (final x in _positions)
                              if (x.id == p.id)
                                x.copyWith(amount: kop)
                              else x
                          ];
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _pickCategory(p),
                    child: Text(
                      catLabel ?? ReceiptsStrings.splitPickCategory,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
            if (p.categoryId == null)
              const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.only(top: 4),
                  child: Text(
                    ReceiptsStrings.splitNeedCategory,
                    style:
                        TextStyle(color: AppColors.colorWarning, fontSize: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}