import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Этап 23 (6.7.3.3): полноэкранная ошибка для критических сбоев.
///
/// БЕЗ Lottie (решение владельца 12.9) — статичная Material-иконка.
/// Кнопка Retry вызывает ref.invalidate провайдера.
class FullScreenError extends StatelessWidget {
  const FullScreenError({
    super.key,
    required this.title,
    this.message,
    this.onRetry,
    this.icon = Icons.error_outline,
    this.retryLabel = 'Retry',
  });

  final String title;
  final String? message;
  final VoidCallback? onRetry;
  final IconData icon;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    final semanticLabel = message == null ? title : '$title. $message';
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.spacing32),
        child: Semantics(
          container: true,
          label: semanticLabel,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ExcludeSemantics(
                child: Icon(icon, size: 96, color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.spacing24),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              if (message != null) ...[
                const SizedBox(height: AppSpacing.spacing12),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: AppColors.textSecondary),
                ),
              ],
              if (onRetry != null) ...[
                const SizedBox(height: AppSpacing.spacing32),
                ElevatedButton(
                  onPressed: onRetry,
                  child: Text(retryLabel),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}