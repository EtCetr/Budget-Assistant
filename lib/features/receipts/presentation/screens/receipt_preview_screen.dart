import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/providers/security_providers.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/dtos/receipt_category_lookup.dart';
import '../../domain/entities/receipt.dart';
import '../../domain/entities/receipt_item.dart';
import '../../domain/dtos/parsed_item_draft.dart';
import '../../domain/dtos/receipt_validation_result.dart';
import '../labels/receipts_strings.dart';
import '../providers/receipt_preview_providers.dart';
import '../providers/receipts_providers.dart';
import '../widgets/product_naming_dialog.dart';
import '../widgets/receipt_image_preview.dart';
import '../widgets/receipt_items_section.dart';
import '../widgets/receipt_metadata_card.dart';
import '../widgets/transaction_match_section.dart';

/// Этап 16.4 (ТЗ 6.3.23): предпросмотр/редактирование чека,
/// матчинг к операции, подтверждение.
class ReceiptPreviewScreen extends ConsumerStatefulWidget {
  const ReceiptPreviewScreen({
    super.key,
    required this.receiptId,
    this.transactionId,
  });

  final String receiptId;
  final String? transactionId;

  @override
  ConsumerState<ReceiptPreviewScreen> createState() =>
      _ReceiptPreviewScreenState();
}

class _ReceiptPreviewScreenState extends ConsumerState<ReceiptPreviewScreen> {
  static final Logger _logger = Logger();

  Receipt? _receipt;
  List<ReceiptItem> _items = [];
  bool _matchSkipped = false;
  bool _saving = false;

  String? get _preTxId =>
      (widget.transactionId == null || widget.transactionId!.isEmpty)
          ? null
          : widget.transactionId;

  List<ReceiptItem> get _activeItems =>
      _items.where((i) => !i.isExcluded).toList();

  Future<void> _persistItems() async {
    final r = _receipt;
    if (r == null) return;
    try {
      await ref.read(receiptsRepositoryProvider).saveItems(r.id, _items);
    } catch (e, st) {
      _logger.e('Persist items failed', error: e, stackTrace: st);
    }
  }

  Future<void> _persistReceipt() async {
    final r = _receipt;
    if (r == null) return;
    try {
      await ref.read(receiptsRepositoryProvider).saveReceipt(r);
    } catch (e, st) {
      _logger.e('Persist receipt failed', error: e, stackTrace: st);
    }
  }

  Future<void> _attach(String txId) async {
    final r = _receipt;
    if (r == null) return;
    final ok = await ref.read(linkReceiptToTransactionUseCaseProvider)(
      receiptId: r.id,
      transactionId: txId,
    );
    if (!mounted) return;
    if (ok) {
      MotionTokens.medium();
      setState(() {
        _receipt = r.copyWith(transactionId: txId, status: 'matched');
      });
      ref.invalidate(receiptBundleProvider(widget.receiptId));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(ReceiptsStrings.matchAttached)),
      );
    } else {
      MotionTokens.error();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(ReceiptsStrings.matchPending)),
      );
    }
  }

  Future<void> _confirm() async {
    final r = _receipt;
    if (r == null) return;
    setState(() => _saving = true);
    try {
      final result = await ref.read(confirmReceiptUseCaseProvider)(
        receipt: r,
        items: _activeItems,
        transactionId: r.transactionId ?? _preTxId,
      );
      if (!mounted) return;
      if (!result.success) {
        MotionTokens.error();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result.errorCodes.join(', '))),
        );
        return;
      }
      ref.invalidate(receiptBundleProvider(widget.receiptId));
      final settings = await ref.read(receiptSettingsProvider.future);
      final spaceId = ref.read(currentSpaceIdProvider);
      // ТЗ 6.3.23.8: оффер именования для позиций без алиаса.
      if (settings.autoOfferNaming && settings.offerNamingCount < 3) {
        for (final item in _activeItems) {
          final catId = item.categoryId;
          if (catId == null || !mounted) continue;
          final hash =
              ref.read(hashProductNameUseCaseProvider)(item.originalName);
          final existing = await ref
              .read(productAliasesRepositoryProvider)
              .findByHash(hash: hash, currentSpaceId: spaceId ?? '');
          if (existing != null || !mounted) continue;
          await showProductNamingDialog(
            context,
            ref,
            originalName: item.originalName,
            categoryId: catId,
          );
        }
      }
      if (!mounted) return;
      // ТЗ 6.3.23.8: оффер разделения (экран в 16.5).
      final uniqueCats =
          _activeItems.map((i) => i.categoryId).whereType<String>().toSet();
      final linked = r.transactionId;
      if (linked != null &&
          uniqueCats.length > 1 &&
          settings.autoOfferSplit &&
          settings.offerSplitCount < 3) {
        await context.push('/receipts/${r.id}/split');
        return;
      }
      MotionTokens.medium();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(ReceiptsStrings.savedSnack)),
      );
      context.go('/transactions');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _togglePrivacy() {
    MotionTokens.selection();
    ref.read(privacyModeProvider.notifier).toggle();
  }

  @override
  Widget build(BuildContext context) {
    final bundleAsync = ref.watch(receiptBundleProvider(widget.receiptId));
    final matchAsync = ref.watch(receiptMatchResultProvider(widget.receiptId));
    final categoriesAsync = ref.watch(receiptCategoriesProvider);
    final mode = ref.watch(privacyModeProvider);
    final categories = categoriesAsync.asData?.value ??
        const <ReceiptCategoryLookup>[];
    return Scaffold(
      appBar: AppBar(
        title: const Text(ReceiptsStrings.previewTitle),
        actions: [
          IconButton(
            icon: Icon(
              mode == BalanceVisibilityMode.hidden
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
            onPressed: _togglePrivacy,
          ),
        ],
      ),
      body: bundleAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
        data: (bundle) {
          if (bundle == null) {
            return const Center(child: Text('...'));
          }
          if (_receipt == null) {
            _receipt = bundle.receipt;
            _items = List.of(bundle.items);
          }
          final r = _receipt!;
          final validation =
              ref.read(validateReceiptFormUseCaseProvider)(
            storeName: r.storeName,
            dateUtc: r.receiptDate,
            totalKop: r.totalAmount,
            items: _activeItems
                .map((i) => ParsedItemDraft(
                      name: i.originalName,
                      quantity: i.quantity,
                      unitPriceKop: i.unitPrice,
                      totalPriceKop: i.totalPrice,
                    ))
                .toList(),
          );
          final linkTo = r.transactionId ?? _preTxId;
          final canConfirm =
              validation.isValid && !_saving && linkTo != null;
          return Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ReceiptImagePreview(imagePath: r.imagePath),
                    ReceiptMetadataCard(
                      receipt: r,
                      onStoreChanged: (v) {
                        setState(() =>
                            _receipt = r.copyWith(storeName: v));
                        _persistReceipt();
                      },
                      onDateChanged: (v) {
                        setState(() =>
                            _receipt = r.copyWith(receiptDate: v));
                        _persistReceipt();
                      },
                      onTotalChanged: (v) {
                        setState(() =>
                            _receipt = r.copyWith(totalAmount: v));
                        _persistReceipt();
                      },
                    ),
                    const SizedBox(height: 16),
                    if (r.transactionId != null)
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Card(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Icon(Icons.link, color: AppColors.colorIncome),
                                SizedBox(width: 8),
                                Text(ReceiptsStrings.matchAlready),
                              ],
                            ),
                          ),
                        ),
                      )
                    else if (!_matchSkipped)
                      TransactionMatchSection(
                        match: matchAsync,
                        onAttach: _attach,
                        onSkip: () =>
                            setState(() => _matchSkipped = true),
                        onCreateNew: () =>
                            context.push('/transactions/create'),
                      ),
                    const SizedBox(height: 16),
                    ReceiptItemsSection(
                      items: _items,
                      categories: categories,
                      totalKop: r.totalAmount,
                      onChanged: (updated) {
                        setState(() {
                          _items = [
                            for (final i in _items)
                              if (i.id == updated.id) updated else i
                          ];
                        });
                        _persistItems();
                      },
                      onDelete: (id) {
                        setState(() => _items = [
                          for (final i in _items)
                            if (i.id != id) i
                        ]);
                        _persistItems();
                      },
                      onAdd: () {
                        final now = DateTime.now().toUtc();
                        setState(() => _items.add(ReceiptItem(
                              id: const Uuid().v4(),
                              receiptId: r.id,
                              originalName: '',
                              normalizedName: null,
                              quantity: 1.0,
                              unitPrice: 0,
                              totalPrice: 0,
                              categoryId: null,
                              isExcluded: false,
                              createdAt: now,
                              updatedAt: now,
                              syncStatus: SyncStatus.pending,
                            )));
                        _persistItems();
                      },
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
  mainAxisSize: MainAxisSize.min,
  children: [
    if (!validation.isValid)
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          _buildHint(validation, linkTo),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ),
    SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: canConfirm ? _confirm : null,
        child: _saving
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text(ReceiptsStrings.confirmButton),
      ),
    ),
  ],
),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


  String _validationHint(dynamic v) {
    final parts = <String>[];
    for (final code in v.errorCodes) {
      if (code == 'store_name_empty') {
        parts.add('укажите магазин');
      } else if (code == 'total_nonpositive') {
        parts.add('укажите сумму больше нуля');
      } else if (code == 'sum_mismatch') {
        parts.add('сумма позиций не равна итогу');
      } else if (code == 'date_future') {
        parts.add('дата в будущем');
      } else if (code == 'item_name_empty') {
        parts.add('у позиции нет названия');
      } else if (code == 'item_price_nonpositive') {
        parts.add('у позиции нет цены');
      }
    }
    return parts.join('; ');
  }
  String _buildHint(dynamic v, String? linkTo) {
    final parts = <String>[];
    if (linkTo == null) parts.add(ReceiptsStrings.hintLink);
    final rest = _validationHint(v);
    if (rest.isNotEmpty) parts.add(rest);
    if (parts.isEmpty) parts.add('проверьте форму чека');
    return parts.join('; ');
  }