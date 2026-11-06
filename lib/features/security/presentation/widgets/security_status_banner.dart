// lib/features/security/presentation/widgets/security_status_banner.dart
// Этап 21 (ТЗ 6.3.28.3): индикатор уровня защиты.
import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/security/domain/usecases/calculate_security_level_usecase.dart';

class SecurityStatusBanner extends StatelessWidget {
  const SecurityStatusBanner({
    super.key,
    required this.score,
    required this.recommendation,
  });

  final int score;
  final String recommendation;

  Color get _levelColor {
    if (score <= 30) return AppColors.colorExpense;
    if (score <= 70) return AppColors.colorWarning;
    return AppColors.colorIncome;
  }

  @override
  Widget build(BuildContext context) {
    const useCase = CalculateSecurityLevelUseCase();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: _levelColor.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_outlined, color: _levelColor, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Уровень защиты: ${useCase.title(score)}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ),
              Text(
                '$score%',
                style: TextStyle(
                  color: _levelColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 8,
              color: _levelColor,
              backgroundColor: AppColors.surfaceElevated,
            ),
          ),
          if (recommendation.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              recommendation,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ],
      ),
    );
  }
}