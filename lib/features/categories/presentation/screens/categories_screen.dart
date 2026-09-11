// lib/features/categories/presentation/screens/categories_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/utils/result.dart';
import '../providers/category_providers.dart';
import '../widgets/category_tree_view.dart';
import '../../domain/entities/category.dart';

class CategoriesScreen extends ConsumerWidget {
  final String userId;

  const CategoriesScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesGroupedByTypeProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          tooltip: 'Home',
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Manage (edit / delete)',
            onPressed: () => _showManageDialog(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            tooltip: 'Accounts',
            onPressed: () => context.go('/accounts'),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create category',
            onPressed: () => _showCategoryDialog(context, ref),
          ),
        ],
      ),
      body: categoriesAsync.when(
        data: (grouped) => _buildCategoriesList(context, ref, grouped),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading categories: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () =>
                    ref.invalidate(categoriesGroupedByTypeProvider(userId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesList(
    BuildContext context,
    WidgetRef ref,
    Map<String, List<Category>> grouped,
  ) {
    if (grouped.values.every((list) => list.isEmpty)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.category, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No categories yet'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showCategoryDialog(context, ref),
              child: const Text('Create your first category'),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (grouped['expense']?.isNotEmpty ?? false) ...[
          _buildSectionHeader('Expenses', Icons.trending_down, Colors.red),
          CategoryTreeView(categories: grouped['expense']!, userId: userId),
          const SizedBox(height: 24),
        ],
        if (grouped['income']?.isNotEmpty ?? false) ...[
          _buildSectionHeader('Incomes', Icons.trending_up, Colors.green),
          CategoryTreeView(categories: grouped['income']!, userId: userId),
          const SizedBox(height: 24),
        ],
        if (grouped['transfer']?.isNotEmpty ?? false) ...[
          _buildSectionHeader('Transfers', Icons.swap_horiz, Colors.blue),
          CategoryTreeView(categories: grouped['transfer']!, userId: userId),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showCategoryDialog(BuildContext context, WidgetRef ref, {Category? category}) {
    showDialog(
      context: context,
      builder: (context) => _CategoryDialog(userId: userId, category: category),
    );
  }

  void _showManageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _ManageCategoriesDialog(userId: userId),
    );
  }
}

/// Плоский список всех категорий с кнопками Edit / Delete
class _ManageCategoriesDialog extends ConsumerWidget {
  final String userId;

  const _ManageCategoriesDialog({required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesListProvider(userId));

    return AlertDialog(
      title: const Text('Manage Categories'),
      content: SizedBox(
        width: double.maxFinite,
        height: 380,
        child: categoriesAsync.when(
          data: (categories) => categories.isEmpty
              ? const Center(child: Text('No categories yet'))
              : ListView.separated(
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return ListTile(
                      leading: Text(
                        category.iconEmoji ?? '🏷️',
                        style: const TextStyle(fontSize: 22),
                      ),
                      title: Text(category.name),
                      subtitle: Text(category.type),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            tooltip: 'Edit',
                            onPressed: () {
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    _CategoryDialog(userId: userId, category: category),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                            tooltip: 'Delete',
                            onPressed: () => _confirmDelete(context, ref, category),
                          ),
                        ],
                      ),
                    );
                  },
                ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Category category) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete category?'),
        content: Text(
          'Delete "${category.name}"? Child categories will move to its parent.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final useCase = ref.read(deleteCategoryUseCaseProvider);
              final result = await useCase.execute(category.id);
              if (!context.mounted) return;
              result.when(
                success: (_) {
                  ref.invalidate(categoriesListProvider(userId));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Category "${category.name}" deleted')),
                  );
                },
                failure: (failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${failure.message}')),
                  );
                },
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

/// Диалог создания И редактирования категории (с выбором родителя)
class _CategoryDialog extends ConsumerStatefulWidget {
  final String userId;
  final Category? category;

  const _CategoryDialog({required this.userId, this.category});

  @override
  ConsumerState<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends ConsumerState<_CategoryDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _emojiController;
  late String _selectedType;
  late String? _parentId;
  bool _isLoading = false;

  bool get _isEdit => widget.category != null;

  @override
  void initState() {
    super.initState();
    final c = widget.category;
    _nameController = TextEditingController(text: c?.name ?? '');
    _emojiController = TextEditingController(text: c?.iconEmoji ?? '');
    _selectedType = c?.type ?? 'expense';
    _parentId = c?.parentId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emojiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Кандидаты в родители: тот же тип, не сама редактируемая категория
    final parentsAsync = ref.watch(categoriesListProvider(widget.userId));
    final parents = parentsAsync.value ?? const <Category>[];
    final candidates = parents
        .where((c) => c.type == _selectedType && c.id != widget.category?.id)
        .toList();

    return AlertDialog(
      title: Text(_isEdit ? 'Edit Category' : 'Create Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Category Name',
              hintText: 'e.g., Groceries, Salary',
            ),
            autofocus: !_isEdit,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedType,
            decoration: const InputDecoration(labelText: 'Type'),
            items: const [
              DropdownMenuItem(value: 'expense', child: Text('Expense')),
              DropdownMenuItem(value: 'income', child: Text('Income')),
              DropdownMenuItem(value: 'transfer', child: Text('Transfer')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedType = value ?? 'expense';
                // Родитель другого типа недопустим
                if (_parentId != null &&
                    !candidates.any((c) => c.id == _parentId)) {
                  _parentId = null;
                }
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String?>(
            initialValue: _parentId,
            decoration: const InputDecoration(labelText: 'Parent (optional)'),
            items: [
              const DropdownMenuItem(value: null, child: Text('— Root —')),
              for (final c in candidates)
                DropdownMenuItem(value: c.id, child: Text(c.name)),
            ],
            onChanged: (value) {
              setState(() {
                _parentId = value;
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _emojiController,
            decoration: const InputDecoration(
              labelText: 'Emoji Icon (optional)',
              hintText: '🛒',
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _save,
          child: _isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(_isEdit ? 'Save' : 'Create'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category name is required')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final emoji = _emojiController.text.trim();
      final Result<void> result;
      if (_isEdit) {
        result = await ref.read(updateCategoryUseCaseProvider).execute(
              categoryId: widget.category!.id,
              name: name,
              type: _selectedType,
              parentId: _parentId,
              iconEmoji: emoji.isEmpty ? null : emoji,
            );
      } else {
        result = await ref.read(createCategoryUseCaseProvider).execute(
              userId: widget.userId,
              name: name,
              type: _selectedType,
              iconEmoji: emoji.isEmpty ? null : emoji,
              spaceId: null,
              parentId: _parentId,
            );
      }

      result.when(
        success: (_) {
          if (!mounted) return;
          Navigator.of(context).pop();
          ref.invalidate(categoriesListProvider(widget.userId));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Category "$name" ${_isEdit ? 'updated' : 'created'}')),
          );
        },
        failure: (failure) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${failure.message}')),
          );
        },
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}