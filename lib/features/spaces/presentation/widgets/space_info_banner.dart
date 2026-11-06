// lib/features/spaces/presentation/widgets/space_info_banner.dart
// Этап 21 (ТЗ 6.3.52.2): баннер расформированного пространства.
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';
import 'package:budget_assistant/features/spaces/presentation/providers/space_archive_providers.dart';

class SpaceInfoBanner extends StatelessWidget {
  const SpaceInfoBanner({
    super.key,
    required this.info,
    required this.mode,
    required this.formatter,
  });

  final SpaceArchiveInfo info;
  final BalanceVisibilityMode mode;
  final PrivacyFormatter formatter;

  @override
  Widget build(BuildContext context) {
    final df = DateFormat('dd.MM.yyyy');
    final dissolvedLabel = info.dissolvedAt == null
        ? '—'
        : df.format(info.dissolvedAt!.toLocal());
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: AppColors.colorWarning.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text('🗑', style: TextStyle(fontSize: 28)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  formatter.formatSpaceName(info.name, mode),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Расформировано $dissolvedLabel · ${info.membersCount} участников',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 4),
          const Text(
            'ℹ️ Данные доступны только для просмотра',
            style: TextStyle(color: AppColors.colorWarning, fontSize: 12),
          ),
        ],
      ),
    );
  }
}