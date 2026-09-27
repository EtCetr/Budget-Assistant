import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../providers/reminders_screen_providers.dart';

/// Бейдж ответственного (имя из memberships + цвет семьи).
/// В hidden скрывается целиком (shouldShowFamilyColors = false).
class AssigneeBadge extends ConsumerWidget {
  const AssigneeBadge({super.key, required this.assigneeId});

  final String? assigneeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (assigneeId == null) return const SizedBox.shrink();
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    if (!formatter.shouldShowFamilyColors(mode)) return const SizedBox.shrink();
    final names = ref.watch(assigneeNameMapProvider);
    final name = names[assigneeId] ?? '';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.colorTransfer.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.person_outline,
              size: 14, color: AppColors.colorTransfer),
          const SizedBox(width: 4),
          Text(
            formatter.formatName(name, mode),
            style:
                const TextStyle(color: AppColors.colorTransfer, fontSize: 12),
          ),
        ],
      ),
    );
  }
}