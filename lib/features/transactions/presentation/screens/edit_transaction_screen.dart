import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/core/formatting/money_input_parser.dart';
import 'package:budget_assistant/core/formatting/money_formatter.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';

import '../../domain/entities/lookup_item.dart';
import '../../domain/models/secrecy_config.dart';
import '../../domain/models/transaction.dart';
import '../../domain/models/transaction_draft.dart';
import '../../domain/models/transaction_split.dart';
import '../labels/transactions_log_labels.dart';
import '../providers/create_transaction_providers.dart';
import '../providers/transactions_log_providers.dart';

/// Экран редактирования транзакции.
///
/// Роут: /transactions/edit/:id
class EditTransactionScreen extends ConsumerStatefulWidget {
  const EditTransactionScreen({super.key, required this.transactionId});

  final String transactionId;

  @override
  ConsumerState<EditTransactionScreen> createState() =>
      _EditTransactionScreenState();
}

class _EditTransactionScreenState extends ConsumerState<EditTransactionScreen> {
  TransactionDraft? _draft;
  List<TransactionSplitDraft>? _existingSplits;
  TransactionType? _type;

  final _amountController = TextEditingController();
  final _merchantController = TextEditingController();
  final _commentController = TextEditingController();

  bool _isSaving = false;
  bool _isLoaded = false;
  String? _amountError;

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _initFromTransaction(Transaction t, List<TransactionSplit> splits) {
    if (_isLoaded) return;
    _isLoaded = true;

    _type = t.type;

    _draft = TransactionDraft(
      id: t.id,
      accountId: t.accountId,
      linkedAccountId: t.linkedAccountId,
      date: t.date.toLocal(),
      amount: t.amount,
      originalCurrency: t.originalCurrency,
      originalAmount: t.originalAmount,
      type: t.type,
      spaceId: t.spaceId,
      bankCategory: t.bankCategory,
      customCategoryId: t.customCategoryId,
      merchantName: t.merchantName,
      comment: t.comment,
      savingsGoalId: t.savingsGoalId,
      isWithdrawal: t.isWithdrawal,
    );

    _existingSplits = splits
        .map(
          (s) => TransactionSplitDraft(
            id: s.id,
            categoryId: s.categoryId,
            amount: s.amount,
            description: s.description,
            createdAt: s.createdAt,
          ),
        )
        .toList();

    _amountController.text = _formatAmountForInput(t.amount);
    _merchantController.text = t.merchantName ?? '';
    _commentController.text = t.comment ?? '';
  }

  /// Форматирует копейки в строку для поля ввода.
  /// Пример: 25050 копеек -> "250,50"
  /// Копейки = 0 -> просто "250"
  String _formatAmountForInput(int kopecks) {
    final abs = kopecks.abs();
    final rubles = abs ~/ 100;
    final kop = abs % 100;

    if (kop == 0) {
      return '$rubles';
    }
    return '$rubles,${kop.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final transactionAsync = ref.watch(
      editTransactionProvider(widget.transactionId),
    );
    final splitsAsync = ref.watch(
      editTransactionSplitsProvider(widget.transactionId),
    );
    final accountsAsync = ref.watch(transactionAccountLookupProvider);
    final categoriesAsync = ref.watch(transactionCategoryLookupProvider);

    return Scaffold(
      appBar: AppBar(title: const Text(TransactionsLogLabels.editTitle)),
      body: transactionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Не удалось загрузить: $e')),
        data: (transaction) {
          if (transaction == null) {
            return const Center(child: Text('Транзакция не найдена'));
          }

          return splitsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Не удалось загрузить: $e')),
            data: (splits) {
              _initFromTransaction(transaction, splits);

              return accountsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    Center(child: Text('Не удалось загрузить счета: $e')),
                data: (accounts) {
                  if (accounts.isEmpty) {
                    return _buildNoAccounts();
                  }

                  return categoriesAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Center(
                      child: Text('Не удалось загрузить категории: $e'),
                    ),
                    data: (categories) => _buildForm(accounts, categories),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: _isLoaded ? _buildActionBar() : null,
    );
  }

  Widget _buildNoAccounts() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_balance_wallet_outlined, size: 72),
            const SizedBox(height: 16),
            Text(
              'Сначала добавьте счёт',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Без счёта нельзя редактировать транзакцию',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Назад'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForm(List<LookupItem> accounts, List<LookupItem> categories) {
    if (_draft == null) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      children: [
        _buildAmountField(),
        const SizedBox(height: AppSpacing.spacing16),
        _buildAccountDropdown(accounts),
        if (_type == TransactionType.transfer) ...[
          const SizedBox(height: AppSpacing.spacing16),
          _buildLinkedAccountDropdown(accounts),
        ],
        if (_type != TransactionType.transfer) ...[
          const SizedBox(height: AppSpacing.spacing16),
          _buildCategoryDropdown(categories),
        ],
        const SizedBox(height: AppSpacing.spacing16),
        _buildDatePicker(),
        const SizedBox(height: AppSpacing.spacing16),
        _buildMerchantField(),
        const SizedBox(height: AppSpacing.spacing16),
        _buildCommentField(),
        const SizedBox(height: AppSpacing.spacing32),
      ],
    );
  }

  Widget _buildAmountField() {
    return TextField(
      controller: _amountController,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: false,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*[,.]?\d{0,2}')),
      ],
      decoration: InputDecoration(
        labelText: 'Сумма',
        errorText: _amountError,
        border: const OutlineInputBorder(),
        suffixText: '₽',
      ),
      onChanged: (value) {
        final parsed = MoneyInputParser.parseKopecks(value);
        setState(() {
          if (parsed == null) {
            _amountError = 'Некорректная сумма';
          } else {
            _amountError = null;
            _draft = _draft?.copyWith(amount: parsed);
          }
        });
      },
    );
  }

  Widget _buildAccountDropdown(List<LookupItem> accounts) {
    final currentId = _draft?.accountId;
    final isValid = currentId != null && accounts.any((a) => a.id == currentId);

    return DropdownButtonFormField<String>(
      initialValue: isValid ? currentId : null,
      decoration: const InputDecoration(
        labelText: 'Счёт',
        border: OutlineInputBorder(),
      ),
      items: accounts
          .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
          .toList(),
      onChanged: (value) {
        if (value != null && _draft != null) {
          setState(() => _draft = _draft!.copyWith(accountId: value));
        }
      },
    );
  }

  Widget _buildLinkedAccountDropdown(List<LookupItem> accounts) {
    final others = accounts.where((a) => a.id != _draft?.accountId).toList();
    final currentId = _draft?.linkedAccountId;
    final isValid = currentId != null && others.any((a) => a.id == currentId);

    return DropdownButtonFormField<String>(
      initialValue: isValid ? currentId : null,
      decoration: const InputDecoration(
        labelText: 'Счёт-получатель',
        border: OutlineInputBorder(),
      ),
      items: others
          .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
          .toList(),
      onChanged: (value) {
        if (_draft != null) {
          setState(() => _draft = _draft!.copyWith(linkedAccountId: value));
        }
      },
    );
  }

  Widget _buildCategoryDropdown(List<LookupItem> categories) {
    final currentId = _draft?.customCategoryId;
    final isValid =
        currentId != null && categories.any((c) => c.id == currentId);

    return DropdownButtonFormField<String>(
      initialValue: isValid ? currentId : null,
      decoration: const InputDecoration(
        labelText: 'Категория (опционально)',
        border: OutlineInputBorder(),
      ),
      items: categories
          .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
          .toList(),
      onChanged: (value) {
        if (_draft != null) {
          setState(() => _draft = _draft!.copyWith(customCategoryId: value));
        }
      },
    );
  }

  Widget _buildDatePicker() {
    if (_draft == null) return const SizedBox.shrink();

    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _draft!.date,
          firstDate: DateTime(2000),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) {
          setState(() => _draft = _draft!.copyWith(date: picked));
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Дата',
          border: OutlineInputBorder(),
        ),
        child: Text(DateFormat('dd.MM.yyyy').format(_draft!.date)),
      ),
    );
  }

  Widget _buildMerchantField() {
    return TextField(
      controller: _merchantController,
      decoration: const InputDecoration(
        labelText: 'Мерчант (опционально)',
        border: OutlineInputBorder(),
      ),
      onChanged: (v) {
        if (_draft != null) {
          _draft = _draft!.copyWith(merchantName: v);
        }
      },
    );
  }

  Widget _buildCommentField() {
    return TextField(
      controller: _commentController,
      decoration: const InputDecoration(
        labelText: 'Комментарий (опционально)',
        border: OutlineInputBorder(),
      ),
      maxLines: 2,
      onChanged: (v) {
        if (_draft != null) {
          _draft = _draft!.copyWith(comment: v);
        }
      },
    );
  }

  Widget _buildActionBar() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: const BoxDecoration(
        color: AppColors.surfaceCard,
        border: Border(top: BorderSide(color: AppColors.borderDivider)),
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: _isSaving ? null : () => context.pop(),
              child: const Text(TransactionsLogLabels.cancel),
            ),
          ),
          const SizedBox(width: AppSpacing.spacing12),
          Expanded(
            child: FilledButton(
              onPressed: _isSaving ? null : _onSave,
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Сохранить'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSave() async {
    HapticFeedback.mediumImpact();

    if (_draft == null) return;

    if (_draft!.amount <= 0) {
      setState(() => _amountError = 'Введите сумму больше нуля');
      return;
    }

    if (_type == TransactionType.transfer &&
        (_draft!.linkedAccountId == null || _draft!.linkedAccountId!.isEmpty)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Выберите счёт-получатель')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      final usecase = ref.read(updateTransactionUseCaseProvider);
      final userId = ref.read(currentUserIdForCreateProvider);

      // Готовим черновик с сохранением существующих сплитов
      final draftWithSplits = _draft!.copyWith(splits: _existingSplits);

      // Читаем настройки секретности из app_settings
      final secrecyConfig = await _loadSecrecyConfig(userId);

      final result = await usecase.call(
        draft: draftWithSplits,
        userId: userId,
        secrecyConfig: secrecyConfig,
      );

      if (!mounted) return;

      switch (result) {
        case Success(:final value):
          HapticFeedback.mediumImpact();
          ref.invalidate(transactionsLogProvider);
          ref.invalidate(hasPendingSyncProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Сохранено: ${MoneyFormatter.formatKopecks(value.amount, 'RUB')}',
              ),
            ),
          );
          context.pop();

        case Error(:final failure):
          HapticFeedback.vibrate();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Ошибка: ${failure.message}'),
              backgroundColor: AppColors.colorExpense,
            ),
          );
      }
    } catch (e) {
      HapticFeedback.vibrate();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Непредвиденная ошибка: $e'),
            backgroundColor: AppColors.colorExpense,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  /// Читает настройки режима секретности из app_settings.
  Future<SecrecyConfig?> _loadSecrecyConfig(String userId) async {
    try {
      final db = AppDatabase();
      final settings = await db.appSettingsDao.getForUser(userId);

      if (!settings.enableSecrecyMode) {
        return null;
      }

      return SecrecyConfig(
        enabled: true,
        threshold: settings.largeTransactionThreshold,
        timeoutSeconds: settings.secrecyTimeoutSeconds,
      );
    } catch (e) {
      return null;
    }
  }
}
