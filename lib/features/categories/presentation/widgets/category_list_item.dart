// lib/features/categories/presentation/widgets/category_list_item.dart
import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';

class CategoryListItem extends StatelessWidget {
  final Category category;
  final int level;
  final bool hasChildren;
  final bool isExpanded;
  final VoidCallback? onTap;
  final VoidCallback? onExpandToggle;

  const CategoryListItem({
    super.key,
    required this.category,
    required this.level,
    this.hasChildren = false,
    this.isExpanded = false,
    this.onTap,
    this.onExpandToggle,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(
          left: 16.0 + (level * 24.0),
          right: 16.0,
          top: 12.0,
          bottom: 12.0,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            if (hasChildren)
              IconButton(
                icon: Icon(
                  isExpanded ? Icons.expand_more : Icons.chevron_right,
                  size: 20,
                ),
                onPressed: onExpandToggle,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            if (!hasChildren) const SizedBox(width: 32),
            if (category.iconEmoji != null) ...[
              Text(category.iconEmoji!, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (category.isSystem)
                    Text(
                      'System',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
            if (category.isPinnedForCashback)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '💰 Cashback',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            if (category.syncStatus == 'pending')
              Icon(Icons.cloud_off, size: 20, color: Colors.grey.shade600),
          ],
        ),
      ),
    );
  }
}
