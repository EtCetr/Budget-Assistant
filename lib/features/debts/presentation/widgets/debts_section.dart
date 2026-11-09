// lib/features/debts/presentation/widgets/debts_section.dart
// Этап 21 (ТЗ 6.3.39.5): секция долгов для ProfileScreen.
// Заглушка: реальная реализация появится после рефакторинга debts feature.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';

class DebtsSection extends ConsumerWidget {
  const DebtsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '💰 Долги',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Управление долгами появится после рефакторинга',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () {
              HapticFeedback.lightImpact();
              context.push('/debts');
            },
            icon: const Icon(
              Icons.handshake_outlined,
              color: AppColors.colorWarning,
            ),
            label: const Text(
              'Открыть список долгов',
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}