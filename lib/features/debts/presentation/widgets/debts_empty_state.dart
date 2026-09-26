import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import '../debts_strings.dart';

/// Пустые состояния экрана долгов (6.3.13.13): 3 варианта.
/// Lottie удалён решением владельца — статичные иконки.
class DebtsEmptyState extends StatelessWidget {
  const DebtsEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.primaryLabel,
    this.onPrimary,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? primaryLabel;
  final VoidCallback? onPrimary;

  factory DebtsEmptyState.noDebts({required VoidCallback onAdd}) {
    return DebtsEmptyState(
      icon: Icons.volunteer_activism_outlined,
      title: DebtsStrings.emptyNoDebtsTitle,
      subtitle: DebtsStrings.emptyNoDebtsSubtitle,
      primaryLabel: DebtsStrings.emptyNoDebtsAction,
      onPrimary: onAdd,
    );
  }

  factory DebtsEmptyState.filtered({required VoidCallback onReset}) {
    return DebtsEmptyState(
      icon: Icons.search_off,
      title: DebtsStrings.emptyFilterTitle,
      subtitle: DebtsStrings.emptyFilterSubtitle,
      primaryLabel: DebtsStrings.emptyFilterAction,
      onPrimary: onReset,
    );
  }

  factory DebtsEmptyState.allResolved({required VoidCallback onHistory}) {
    return DebtsEmptyState(
      icon: Icons.verified_outlined,
      title: DebtsStrings.emptyAllResolvedTitle,
      subtitle: DebtsStrings.emptyAllResolvedSubtitle,
      primaryLabel: DebtsStrings.emptyAllResolvedAction,
      onPrimary: onHistory,
    );
  }

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
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.spacing12),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            if (primaryLabel != null && onPrimary != null) ...[
              const SizedBox(height: AppSpacing.spacing24),
              ElevatedButton(onPressed: onPrimary, child: Text(primaryLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}