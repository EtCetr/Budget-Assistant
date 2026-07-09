// lib/features/categories/presentation/widgets/category_tree_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/category_providers.dart';
import 'category_list_item.dart';
import '../../domain/entities/category.dart';

class CategoryTreeView extends ConsumerWidget {
  final List<Category> categories;
  final String userId;

  const CategoryTreeView({
    super.key,
    required this.categories,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Filter root categories (parentId == null)
    final rootCategories = categories.where((c) => c.isRoot).toList();

    if (rootCategories.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No root categories'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rootCategories.map((category) {
        return _CategoryTreeItem(category: category, userId: userId, level: 0);
      }).toList(),
    );
  }
}

class _CategoryTreeItem extends ConsumerStatefulWidget {
  final Category category;
  final String userId;
  final int level;

  const _CategoryTreeItem({
    required this.category,
    required this.userId,
    required this.level,
  });

  @override
  ConsumerState<_CategoryTreeItem> createState() => _CategoryTreeItemState();
}

class _CategoryTreeItemState extends ConsumerState<_CategoryTreeItem> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final childrenAsync = ref.watch(
      childCategoriesProvider(widget.category.id),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CategoryListItem(
          category: widget.category,
          level: widget.level,
          hasChildren: (childrenAsync.value ?? []).isNotEmpty,
          isExpanded: _isExpanded,
          onTap: () {
            // Handle category tap
          },
          onExpandToggle: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
        ),
        if (_isExpanded)
          childrenAsync.when(
            data: (children) {
              if (children.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children.map((child) {
                  return _CategoryTreeItem(
                    category: child,
                    userId: widget.userId,
                    level: widget.level + 1,
                  );
                }).toList(),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            error: (error, stack) => Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Error: $error'),
            ),
          ),
      ],
    );
  }
}
