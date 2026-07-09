// lib/features/categories/presentation/screens/categories_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateCategoryDialog(context, ref),
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
                    ref.refresh(categoriesGroupedByTypeProvider(userId)),
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
              onPressed: () => _showCreateCategoryDialog(context, ref),
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
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  void _showCreateCategoryDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _CreateCategoryDialog(userId: userId),
    );
  }
}

class _CreateCategoryDialog extends ConsumerStatefulWidget {
  final String userId;

  const _CreateCategoryDialog({required this.userId});

  @override
  ConsumerState<_CreateCategoryDialog> createState() =>
      _CreateCategoryDialogState();
}

class _CreateCategoryDialogState extends ConsumerState<_CreateCategoryDialog> {
  final _nameController = TextEditingController();
  String _selectedType = 'expense';
  String? _selectedEmoji;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Category'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Category Name',
              hintText: 'e.g., Groceries, Salary',
            ),
            autofocus: true,
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
              });
            },
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Emoji Icon (optional)',
              hintText: '🛒',
            ),
            onChanged: (value) {
              setState(() {
                _selectedEmoji = value.isEmpty ? null : value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _createCategory,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }

  Future<void> _createCategory() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category name is required')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final useCase = ref.read(createCategoryUseCaseProvider);
    final result = await useCase.execute(
      userId: widget.userId,
      name: name,
      type: _selectedType,
      iconEmoji: _selectedEmoji,
    );

    setState(() => _isLoading = false);

    result.when(
      success: (category) {
        Navigator.of(context).pop();
        ref.invalidate(categoriesGroupedByTypeProvider(widget.userId));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Category "${category.name}" created')),
        );
      },
      failure: (failure) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${failure.message}')));
      },
    );
  }
}
