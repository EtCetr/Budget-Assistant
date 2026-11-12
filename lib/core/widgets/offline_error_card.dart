import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Этап 23 (6.7.3.2): компактная карточка ошибки с кнопкой Retry.
/// Добавлен параметр showIcon и Semantics (Этап 22, WCAG).
class OfflineErrorCard extends StatelessWidget {
  const OfflineErrorCard({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel = 'Retry',
    this.showIcon = true,
  });

  final String message;
  final VoidCallback? onRetry;
  final String retryLabel;
  final bool showIcon;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: message,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.spacing24),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          border: Border.all(color: AppColors.colorExpense, width: 2),
          borderRadius: BorderRadius.circular(AppRadius.radiusLg),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon)
              const Icon(
                Icons.error_outline,
                size: 48,
                color: AppColors.colorExpense,
              ),
            if (showIcon) const SizedBox(height: AppSpacing.spacing16),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.spacing16),
              OutlinedButton(
                onPressed: onRetry,
                child: Text(retryLabel),
              ),
            ],
          ],
        ),
      ),
    );
  }
}