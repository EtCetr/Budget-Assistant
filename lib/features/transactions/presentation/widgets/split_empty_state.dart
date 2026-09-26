import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import '../split_strings.dart';

/// Пустое состояние экрана разделения (6.3.15.11).
class SplitEmptyState extends StatelessWidget {
  const SplitEmptyState({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.content_cut,
              size: 96,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.spacing24),
            Text(
              SplitStrings.emptyTitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.spacing12),
            Text(
              SplitStrings.emptySubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const SizedBox(height: AppSpacing.spacing24),
            FilledButton.icon(
              onPressed: onAdd,
              icon: const Icon(Icons.add),
              label: const Text(SplitStrings.emptyAction),
            ),
          ],
        ),
      ),
    );
  }
}