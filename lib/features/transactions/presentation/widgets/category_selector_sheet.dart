import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/features/transactions/presentation/providers/transactions_log_providers.dart';
import '../split_strings.dart';

/// BottomSheet выбора категории для позиции сплита (6.3.15.5).
Future<String?> showCategorySelectorSheet(BuildContext context) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) => Consumer(
      builder: (context, ref, _) {
        final categoriesAsync = ref.watch(transactionCategoryLookupProvider);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  SplitStrings.categorySheetTitle,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              Expanded(
                child: categoriesAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (categories) => ListView(
                    shrinkWrap: true,
                    children: [
                      for (final category in categories)
                        ListTile(
                          title: Text(category.name),
                          onTap: () {
                            HapticFeedback.selectionClick();
                            Navigator.of(sheetContext).pop(category.id);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ),
  );
}