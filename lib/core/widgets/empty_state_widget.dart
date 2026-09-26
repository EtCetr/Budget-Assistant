import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Пустое состояние для списков (ТЗ 6.8).
/// Анимации Lottie удалены по решению владельца — статичная иконка.
class EmptyStateAction {
  const EmptyStateAction({
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
  });

  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
}

class EmptyStateWidget extends StatelessWidget {
  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.primaryAction,
    this.secondaryAction,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final EmptyStateAction? primaryAction;
  final EmptyStateAction? secondaryAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.spacing32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 96, color: AppColors.textSecondary),
            const SizedBox(height: AppSpacing.spacing24),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.spacing12),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
            if (primaryAction != null) ...[
              const SizedBox(height: AppSpacing.spacing24),
              primaryAction!.isPrimary
                  ? ElevatedButton(
                      onPressed: primaryAction!.onPressed,
                      child: Text(primaryAction!.label),
                    )
                  : OutlinedButton(
                      onPressed: primaryAction!.onPressed,
                      child: Text(primaryAction!.label),
                    ),
            ],
            if (secondaryAction != null) ...[
              const SizedBox(height: AppSpacing.spacing12),
              secondaryAction!.isPrimary
                  ? ElevatedButton(
                      onPressed: secondaryAction!.onPressed,
                      child: Text(secondaryAction!.label),
                    )
                  : OutlinedButton(
                      onPressed: secondaryAction!.onPressed,
                      child: Text(secondaryAction!.label),
                    ),
            ],
          ],
        ),
      ),
    );
  }
}