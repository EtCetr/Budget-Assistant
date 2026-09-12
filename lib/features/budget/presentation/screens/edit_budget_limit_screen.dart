import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/formatting/money_input_parser.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/categories/domain/entities/category.dart';
import 'package:budget_assistant/features/categories/presentation/providers/category_providers.dart';
import '../../domain/entities/budget_limit.dart';
import '../providers/budget_providers.dart';

class EditBudgetLimitScreen extends ConsumerStatefulWidget {
  final String? limitId;

  const EditBudgetLimitScreen({super.key, this.limitId});

  @override
  ConsumerState<EditBudgetLimitScreen> createState() =>
      _EditBudgetLimitScreenState();
}

class _EditBudgetLimitScreenState extends ConsumerState<EditBudgetLimitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  String? _selectedCategoryId;
  int _alertPercent = 80;
  bool _isSaving = false;
  bool _isPrefilled = false;

  bool get _isEditing => widget.limitId != null;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  /// Заполнить поля текущими значениями лимита (только один раз).
  void _applyPrefill(BudgetLimit limit) {
    if (!mounted || _isPrefilled) return;
    setState(() {
      _selectedCategoryId = limit.categoryId;
      _amountController.text = _formatRubles(limit.limitAmount);
      _alertPercent = limit.alertPercent.clamp(50, 100);
      _isPrefilled = true;
    });
  }

  /// Копейки -> строка рублей для поля ввода (без double).
  String _formatRubles(int kopecks) {
    final rubles = kopecks ~/ 100;
    final kop = kopecks % 100;
    if (kop == 0) return '$rubles';
    return '$rubles.${kop.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final userId = ref.watch(currentUserIdProvider);
    final categoriesAsync = ref.watch(categoriesListProvider(userId));
    // Лимиты месяца нужны, чтобы исключить категории с уже заданным лимитом.
    final limitsAsync = ref.watch(budgetLimitsForCurrentMonthProvider);

    AsyncValue<BudgetLimit?> limitAsync = const AsyncValue.data(null);
    if (_isEditing) {
      limitAsync = ref.watch(budgetLimitByIdProvider(widget.limitId!));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Редактировать лимит' : 'Новый лимит'),
        centerTitle: true,
      ),
      body: _buildBody(categoriesAsync, limitsAsync, limitAsync),
    );
  }

  Widget _buildBody(
    AsyncValue<List<Category>> categoriesAsync,
    AsyncValue<List<BudgetLimit>> limitsAsync,
    AsyncValue<BudgetLimit?> limitAsync,
  ) {
    // При редактировании ждём загрузку существующего лимита.
    if (_isEditing && limitAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_isEditing && limitAsync.hasError) {
      return Center(
        child: Text('Ошибка загрузки лимита: ${limitAsync.error}'),
      );
    }

    // В Riverpod 3.x у AsyncValue используется .value (valueOrNull удалён).
    final currentLimit = limitAsync.value;

    // Как только лимит загружен — префиллим поля (один раз).
    if (_isEditing && currentLimit != null && !_isPrefilled) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _applyPrefill(currentLimit),
      );
    }

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return const Center(
            child: Text('Сначала создайте категории расходов'),
          );
        }
        // При редактировании форма готова только после префилла,
        // чтобы выпадающий список сразу показал текущую категорию.
        if (_isEditing && !_isPrefilled) {
          return const Center(child: CircularProgressIndicator());
        }
        final existingLimits = limitsAsync.value ?? const <BudgetLimit>[];
        return _buildForm(categories, existingLimits, currentLimit);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Ошибка: $e')),
    );
  }

  Widget _buildForm(
    List<Category> categories,
    List<BudgetLimit> existingLimits,
    BudgetLimit? currentLimit,
  ) {
    final limitedCategoryIds =
        existingLimits.map((l) => l.categoryId).toSet();

    // Категории с уже заданным лимитом убираем из выбора.
    // Исключение — собственная категория редактируемого лимита.
    final availableCategories = categories.where((c) {
      if (c.type != 'expense') return false;
      final isOwnCategory =
          currentLimit != null && c.id == currentLimit.categoryId;
      if (isOwnCategory) return true;
      return !limitedCategoryIds.contains(c.id);
    }).toList();

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            initialValue: _selectedCategoryId,
            decoration: const InputDecoration(
              labelText: 'Категория',
              border: OutlineInputBorder(),
            ),
            items: availableCategories
                .map((c) => DropdownMenuItem<String>(
                      value: c.id,
                      child: Text(c.name),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategoryId = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Выберите категорию';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Сумма лимита (₽)',
              hintText: 'Например: 10000',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Введите сумму';
              }
              final kopecks = MoneyInputParser.parseKopecks(value);
              if (kopecks == null || kopecks <= 0) {
                return 'Введите корректную сумму';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text('Алерт при достижении:'),
              const SizedBox(width: 16),
              Expanded(
                child: Slider(
                  value: _alertPercent.toDouble(),
                  min: 50,
                  max: 100,
                  divisions: 10,
                  label: '$_alertPercent%',
                  onChanged: (value) {
                    setState(() {
                      _alertPercent = value.round();
                    });
                  },
                ),
              ),
              Text('$_alertPercent%'),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategoryId == null) return;

    setState(() {
      _isSaving = true;
    });

    final useCase = ref.read(upsertBudgetLimitUseCaseProvider);
    final userId = ref.read(currentUserIdProvider);
    final now = DateTime.now();

    final kopecks = MoneyInputParser.parseKopecks(_amountController.text) ?? 0;

    final result = await useCase(
      id: widget.limitId,
      spaceId: null,
      userId: userId,
      categoryId: _selectedCategoryId!,
      year: now.year,
      month: now.month,
      limitAmount: kopecks,
      alertPercent: _alertPercent,
    );

    setState(() {
      _isSaving = false;
    });

    result.fold(
      onSuccess: (_) {
        // Принудительно инвалидируем кэш аналитики, чтобы прогресс
        // обновился сразу, не дожидаясь следующего события стрима.
        ref.invalidate(monthlyPnlForCurrentMonthProvider);
        ref.invalidate(effectiveLimitForCategoryProvider);
        if (mounted) context.pop();
      },
      onError: (_) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Ошибка сохранения')),
          );
        }
      },
    );
  }
}