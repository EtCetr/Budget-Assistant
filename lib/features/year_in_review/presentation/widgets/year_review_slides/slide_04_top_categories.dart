import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';
import '../../../domain/models/year_in_review_data.dart';
import '../../year_review_strings.dart';
import '../year_review_slide_scaffold.dart';

/// SLIDE 4: Топ-3 категории трат (медали + суммы + проценты).
/// Круговая диаграмма заменена на ранжированный список: в скрытых режимах
/// график всё равно блокируется, а список читается лучше (отклонение).
class SlideTopCategories extends StatelessWidget {
  const SlideTopCategories({
    super.key,
    required this.data,
    required this.pf,
    required this.mode,
  });

  final YearInReviewData data;
  final PrivacyFormatter pf;
  final BalanceVisibilityMode mode;

  static const _medals = ['🥇', '🥈', '🥉'];

  Color _color(String? hex) {
    if (hex == null || hex.isEmpty) return AppColors.surfaceElevated;
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AppColors.surfaceElevated;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cats = data.topCategories;
    return YearReviewSlideScaffold(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            YearReviewStrings.topCategories,
            style: Theme.of(context)
                .textTheme
                .headlineLarge
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 32),
          for (var i = 0; i < cats.length && i < 3; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  Text(_medals[i], style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _color(cats[i].color),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${cats[i].emoji ?? ''} ${pf.formatName(cats[i].name, mode)}'
                          .trim(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        pf.formatAmount(
                            cats[i].amount, data.baseCurrency, mode),
                        style: const TextStyle(
                            color: AppColors.textPrimary, fontSize: 16),
                      ),
                      // Процент не раскрывает абсолютную сумму — виден всегда.
                      Text('${cats[i].percent}%',
                          style: const TextStyle(
                              color: AppColors.textSecondary)),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}