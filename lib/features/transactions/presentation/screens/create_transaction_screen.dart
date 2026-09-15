import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/constants/currency_codes.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/core/formatting/money_input_parser.dart';
import 'package:budget_assistant/core/formatting/money_text_input_formatter.dart';
import 'package:budget_assistant/core/formatting/money_formatter.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/cashback/presentation/providers/cashback_providers.dart';
import '../../../../core/providers/security_providers.dart';
import '../../domain/entities/lookup_item.dart';
import '../../domain/models/secrecy_config.dart';
import '../../domain/models/transaction_draft.dart';
import '../labels/transactions_log_labels.dart';
import '../providers/create_transaction_providers.dart';
import '../providers/transactions_log_providers.dart';

/// Экран создания транзакции.
///
/// Роут: /transactions/create?type=expense|income|transfer
/// Этап 10: выбор валюты операции + авто-конвертация в валюту счёта
/// по курсу на дату (оригинал хранится в original_amount/original_currency).
class CreateTransactionScreen extends ConsumerStatefulWidget {
  const CreateTransactionScreen({super.key, required this.type});

  final TransactionType type;

  @override
  ConsumerState<CreateTransactionScreen> createState() =>
      _CreateTransactionScreenState();
}

class _CreateTransactionScreenState
    extends ConsumerState<CreateTransactionScreen> {
  late TransactionDraft _draft;
  final _amountController = TextEditingController();
  final _merchantController = TextEditingController();
  final _commentController = TextEditingController();
  bool _isSaving = false;
  String? _amountError;
  String? _selectedCurrency;
  String? _previewText;

  @override
  void initState() {
    super.initState();
    _invalidateLookups();
    _draft = TransactionDraft(
      type: widget.type,
      accountId: '',
      date: DateTime.now(),
      amount: 0,
    );
  }

  /// Принудительно перечитывает списки счетов и категорий из БД,
  /// чтобы новые записи были видны без перезапуска приложения.
  void _invalidateLookups() {
    Future.microtask(() {
      if (!mounted) return;
      ref.invalidate(transactionAccountLookupProvider);
      ref.invalidate(transactionCategoryLookupProvider);
      ref.invalidate(accountCurrencyMapProvider);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _merchantController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(transactionAccountLookupProvider);
    final categoriesAsync = ref.watch(transactionCategoryLookupProvider);
    return Scaffold(
      appBar: AppBar(title: Text(_screenTitle())),
      body: accountsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Не удалось загрузить счета: $e')),
        data: (accounts) {
          if (accounts.isEmpty) {
            return _buildNoAccounts();
          }
          // Авто-выбор первого счёта при первом билде
          if (_draft.accountId.isEmpty) {
            _draft = _draft.copyWith(accountId: accounts.first.id);
          }
          return categoriesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Center(child: Text('Не удалось загрузить категории: $e')),
            data: (categories) => _buildForm(accounts, categories),
          );
        },
      ),
      bottomNavigationBar: _buildActionBar(),
    );
  }

  String _screenTitle() {
    switch (widget.type) {
      case TransactionType.expense:
        return 'Новый расход';
      case TransactionType.income:
        return 'Новый доход';
      case TransactionType.transfer:
        return 'Новый перевод';
    }
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
              'Без счёта нельзя создать транзакцию',
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
    final currencyMap =
        ref.watch(accountCurrencyMapProvider).value ?? const <String, String>{};
    final accountCurrency = currencyMap[_draft.accountId] ?? 'RUB';
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      children: [
        _buildAmountField(_selectedCurrency ?? accountCurrency),
        const SizedBox(height: AppSpacing.spacing16),
        _buildAccountDropdown(accounts),
        const SizedBox(height: AppSpacing.spacing16),
        _buildCurrencyDropdown(accountCurrency),
        if (widget.type == TransactionType.transfer) ...[
          const SizedBox(height: AppSpacing.spacing16),
          _buildLinkedAccountDropdown(accounts),
        ],
        if (widget.type != TransactionType.transfer) ...[
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

  Widget _buildAmountField(String suffixCurrency) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _amountController,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
            signed: false,
          ),
          inputFormatters: [
            MoneyTextInputFormatter(),
          ],
          autofocus: true,
          decoration: InputDecoration(
            labelText: 'Сумма',
            errorText: _amountError,
            border: const OutlineInputBorder(),
            suffixText: suffixCurrency,
          ),
          onChanged: (value) {
            final parsed = MoneyInputParser.parseKopecks(value);
            setState(() {
              if (parsed == null) {
                _amountError = 'Некорректная сумма';
              } else {
                _amountError = null;
                _draft = _draft.copyWith(amount: parsed);
              }
            });
            _updatePreview();
          },
        ),
        if (_previewText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              _previewText!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }

  Widget _buildAccountDropdown(List<LookupItem> accounts) {
    return DropdownButtonFormField<String>(
      initialValue: _draft.accountId.isEmpty ? null : _draft.accountId,
      decoration: const InputDecoration(
        labelText: 'Счёт',
        border: OutlineInputBorder(),
      ),
      items: accounts
          .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _draft = _draft.copyWith(accountId: value);
            _selectedCurrency = null;
            _previewText = null;
          });
          _updatePreview();
        }
      },
    );
  }

  Widget _buildCurrencyDropdown(String accountCurrency) {
    final current = _selectedCurrency ?? accountCurrency;
    return DropdownButtonFormField<String>(
      initialValue: current,
      decoration: const InputDecoration(
        labelText: 'Валюта операции',
        border: OutlineInputBorder(),
      ),
      items: [
        for (final code in kCurrencyCodes)
          DropdownMenuItem(value: code, child: Text(code)),
      ],
      onChanged: (value) {
        setState(() {
          _selectedCurrency =
              (value == null || value == accountCurrency) ? null : value;
          _previewText = null;
        });
        _updatePreview();
      },
    );
  }

  Widget _buildLinkedAccountDropdown(List<LookupItem> accounts) {
    final others = accounts.where((a) => a.id != _draft.accountId).toList();
    return DropdownButtonFormField<String>(
      initialValue: _draft.linkedAccountId,
      decoration: const InputDecoration(
        labelText: 'Счёт-получатель',
        border: OutlineInputBorder(),
      ),
      items: others
          .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
          .toList(),
      onChanged: (value) {
        setState(() => _draft = _draft.copyWith(linkedAccountId: value));
      },
    );
  }

  Widget _buildCategoryDropdown(List<LookupItem> categories) {
    return DropdownButtonFormField<String>(
      initialValue: _draft.customCategoryId,
      decoration: const InputDecoration(
        labelText: 'Категория (опционально)',
        border: OutlineInputBorder(),
      ),
      items: categories
          .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
          .toList(),
      onChanged: (value) {
        setState(() => _draft = _draft.copyWith(customCategoryId: value));
      },
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: _draft.date,
          firstDate: DateTime(2000),
          lastDate: DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) {
          setState(() => _draft = _draft.copyWith(date: picked));
          _updatePreview();
        }
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Дата',
          border: OutlineInputBorder(),
        ),
        child: Text(DateFormat('dd.MM.yyyy').format(_draft.date)),
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
      onChanged: (v) => _draft = _draft.copyWith(merchantName: v),
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
      onChanged: (v) => _draft = _draft.copyWith(comment: v),
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

  /// Живой предпросмотр конвертации в валюту счёта (Этап 10).
  Future<void> _updatePreview() async {
    if (_draft.amount <= 0) {
      if (mounted) setState(() => _previewText = null);
      return;
    }
    try {
      final map = await ref.read(accountCurrencyMapProvider.future);
      final accountCurrency = map[_draft.accountId] ?? 'RUB';
      final txCurrency = _selectedCurrency ?? accountCurrency;
      if (txCurrency == accountCurrency) {
        if (mounted) setState(() => _previewText = null);
        return;
      }
      final converted = await ref.read(convertCurrencyUseCaseProvider)(
        amountKopecks: _draft.amount,
        fromCurrency: txCurrency,
        toCurrency: accountCurrency,
        dateUtc: _draft.date.toUtc(),
      );
      if (!mounted) return;
      setState(() {
        _previewText = converted == null
            ? 'Нет курса $txCurrency → $accountCurrency на дату: при сохранении потребуется исключение'
            : '≈ ${MoneyFormatter.formatKopecks(converted, accountCurrency)} по курсу на дату';
      });
    } catch (_) {
      if (mounted) setState(() => _previewText = null);
    }
  }

  Future<void> _onSave() async {
    HapticFeedback.mediumImpact();
    if (_draft.amount <= 0) {
      setState(() => _amountError = 'Введите сумму больше нуля');
      return;
    }
    if (widget.type == TransactionType.transfer &&
        (_draft.linkedAccountId == null || _draft.linkedAccountId!.isEmpty)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Выберите счёт-получатель')));
      return;
    }
    setState(() => _isSaving = true);
    try {
      final usecase = ref.read(createTransactionUseCaseProvider);
      final userId = ref.read(currentUserIdForCreateProvider);
      final spaceId = ref.read(currentSpaceIdProvider);
      final currencyMap =
          await ref.read(accountCurrencyMapProvider.future);
      final accountCurrency = currencyMap[_draft.accountId] ?? 'RUB';
      final txCurrency = _selectedCurrency ?? accountCurrency;

      var saveDraft = _draft.copyWith(spaceId: spaceId);
      if (txCurrency != accountCurrency) {
        final converted = await ref.read(convertCurrencyUseCaseProvider)(
          amountKopecks: _draft.amount,
          fromCurrency: txCurrency,
          toCurrency: accountCurrency,
          dateUtc: _draft.date.toUtc(),
        );
        if (converted == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Нет курса $txCurrency → $accountCurrency на дату операции. '
                  'Добавьте исключение: экран «Кэшбэк» → иконка ⇄.',
                ),
                backgroundColor: AppColors.colorExpense,
              ),
            );
          }
          return;
        }
        saveDraft = saveDraft.copyWith(
          amount: converted,
          originalCurrency: txCurrency,
          originalAmount: _draft.amount,
        );
      }

      // Читаем настройки секретности из app_settings
      final secrecyConfig = await _loadSecrecyConfig(userId);
      final result = await usecase.call(
        draft: saveDraft,
        userId: userId,
        secrecyConfig: secrecyConfig,
      );
      if (!mounted) return;
      switch (result) {
        case Success(:final value):
          HapticFeedback.mediumImpact();
          ref.invalidate(transactionsLogProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Сохранено: ${MoneyFormatter.formatKopecks(value.amount, accountCurrency)}',
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