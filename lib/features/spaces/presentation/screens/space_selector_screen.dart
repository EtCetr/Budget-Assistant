import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/router/app_router.dart' as router;
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/core/widgets/offline_error_card.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import '../../../../core/providers/security_providers.dart' as security;
import '../providers/space_providers.dart';
import '../spaces_strings.dart';

/// Экран выбора пространства (Multi-group).
///
/// Реальный список семейных пространств из БД (userSpacesProvider) +
/// пункт «Личное пространство» (currentSpaceId = NULL).
/// ДОЛГ: в проекте два провайдера currentSpaceIdProvider (security_providers
/// и app_router) — селектор синхронизирует оба; унификация на Этапе 17/21.
class SpaceSelectorScreen extends ConsumerWidget {
  const SpaceSelectorScreen({super.key});

  void _select(WidgetRef ref, BuildContext context, String? spaceId) {
    MotionTokens.selection();
    ref.read(router.currentSpaceIdProvider.notifier).setSpaceId(spaceId);
    ref.read(security.currentSpaceIdProvider.notifier).set(spaceId);
    context.go('/');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacesAsync = ref.watch(userSpacesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(SpacesStrings.screenTitle)),
      body: spacesAsync.when(
        loading: () => ListView(
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          children: const [
            SkeletonShimmer(height: 64),
            SizedBox(height: AppSpacing.spacing12),
            SkeletonShimmer(height: 64),
          ],
        ),
        error: (e, _) => Center(
          child: OfflineErrorCard(
            message: SpacesStrings.loadingError,
            retryLabel: SpacesStrings.retry,
            onRetry: () => ref.invalidate(userSpacesProvider),
          ),
        ),
        data: (spaces) => ListView(
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          children: [
            ListTile(
              leading: const Icon(Icons.person_outline,
                  color: AppColors.colorTransfer),
              title: const Text(SpacesStrings.personalTitle),
              subtitle: const Text(SpacesStrings.personalSubtitle),
              onTap: () => _select(ref, context, null),
            ),
            const SizedBox(height: AppSpacing.spacing16),
            Text(
              SpacesStrings.familySection,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.spacing8),
            if (spaces.isEmpty)
              const Padding(
                padding: EdgeInsets.all(AppSpacing.spacing16),
                child: Column(
                  children: [
                    Icon(Icons.group_outlined,
                        size: 48, color: AppColors.textSecondary),
                    SizedBox(height: AppSpacing.spacing12),
                    Text(SpacesStrings.emptyTitle,
                        style: TextStyle(fontWeight: FontWeight.w600)),
                    SizedBox(height: AppSpacing.spacing4),
                    Text(
                      SpacesStrings.emptySubtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              )
            else
              for (final space in spaces)
                ListTile(
                  leading:
                      const Icon(Icons.group, color: AppColors.colorIncome),
                  title: Text(space.name),
                  onTap: () => _select(ref, context, space.id),
                ),
          ],
        ),
      ),
    );
  }
}