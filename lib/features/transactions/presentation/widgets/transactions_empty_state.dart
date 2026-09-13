import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../labels/transactions_log_labels.dart';

class TransactionsEmptyState extends StatelessWidget {
  const TransactionsEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.primaryLabel,
    this.onPrimary,
    this.secondaryLabel,
    this.onSecondary,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? primaryLabel;
  final VoidCallback? onPrimary;
  final String? secondaryLabel;
  final VoidCallback? onSecondary;

  factory TransactionsEmptyState.noData({
    required VoidCallback onAdd,
    required VoidCallback onImport,
  }) {
    return TransactionsEmptyState(
      icon: Icons.account_balance_wallet_outlined,
      title: TransactionsLogLabels.noDataTitle,
      subtitle: TransactionsLogLabels.noDataSubtitle,
      primaryLabel: TransactionsLogLabels.addTransaction,
      onPrimary: onAdd,
      secondaryLabel: TransactionsLogLabels.importBank,
      onSecondary: onImport,
    );
  }

  factory TransactionsEmptyState.filtered({required VoidCallback onReset}) {
    return TransactionsEmptyState(
      icon: Icons.search_off,
      title: TransactionsLogLabels.nothingFoundTitle,
      subtitle: TransactionsLogLabels.nothingFoundSubtitle,
      primaryLabel: TransactionsLogLabels.resetFilters,
      onPrimary: onReset,
    );
  }

  factory TransactionsEmptyState.error({required VoidCallback onRetry}) {
    return TransactionsEmptyState(
      icon: Icons.error_outline,
      title: TransactionsLogLabels.errorTitle,
      subtitle: TransactionsLogLabels.errorSubtitle,
      primaryLabel: TransactionsLogLabels.retry,
      onPrimary: onRetry,
    );
  }

  /// Семейный скоуп выбран, но пользователь не состоит ни в одной группе.
  factory TransactionsEmptyState.noFamilyGroup({
    required VoidCallback onCreateGroup,
  }) {
    return TransactionsEmptyState(
      icon: Icons.group_add_outlined,
      title: 'Вы не состоите ни в одной семейной группе',
      subtitle:
          'Создайте группу, чтобы вести общий бюджет и видеть операции семьи',
      primaryLabel: 'Создать группу',
      onPrimary: onCreateGroup,
    );
  }

  /// Семейный скоуп: группа есть, но семейных операций пока нет.
  /// Предлагаем подключить личные транзакции к группе (вариант A).
  factory TransactionsEmptyState.noFamilyTransactions({
    required VoidCallback onAttach,
  }) {
    return TransactionsEmptyState(
      icon: Icons.family_restroom_outlined,
      title: 'В семье пока нет операций',
      subtitle:
          'Можно подключить ваши личные транзакции к группе — '
          'они станут видны всем её участникам',
      primaryLabel: 'Подключить мои транзакции',
      onPrimary: onAttach,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 72, color: AppColors.textSecondary),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            if (primaryLabel != null && onPrimary != null)
              FilledButton(onPressed: onPrimary, child: Text(primaryLabel!)),
            if (secondaryLabel != null && onSecondary != null) ...[
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: onSecondary,
                child: Text(secondaryLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}