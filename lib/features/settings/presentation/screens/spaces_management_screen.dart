// lib/features/settings/presentation/screens/spaces_management_screen.dart
// Этап 21 (ТЗ 6.3.51): управление пространствами.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/providers/security_providers.dart' as sec;
import 'package:budget_assistant/core/router/app_router.dart' as ar;
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import 'package:budget_assistant/features/settings/presentation/providers/spaces_management_providers.dart';
import 'package:budget_assistant/features/settings/presentation/widgets/join_space_dialog.dart';
import 'package:budget_assistant/features/settings/presentation/widgets/leave_space_dialogs.dart';
import 'package:budget_assistant/features/settings/presentation/widgets/space_card.dart';
import 'package:budget_assistant/features/spaces/domain/entities/space_membership_info.dart';
import 'package:budget_assistant/features/spaces/presentation/widgets/create_space_dialog.dart';

class SpacesManagementScreen extends ConsumerWidget {
  const SpacesManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(spacesManagementProvider);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceBackground,
        title: const Text('Управление пространствами'),
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Не удалось загрузить пространства',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(spacesManagementProvider),
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
        data: (all) {
          final active = all.where((s) => !s.isDissolved).toList();
          final dissolved = all.where((s) => s.isDissolved).toList();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _stats(all.length, active.length, dissolved.length),
              const SizedBox(height: 16),
              const Text(
                '🟢 Активные пространства',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              if (active.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.group_outlined,
                        size: 48,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'У вас пока нет пространств',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Создайте семейное пространство или присоединитесь по приглашению',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                )
              else
                for (final info in active)
                  SpaceCard(
                    info: info,
                    mode: mode,
                    formatter: formatter,
                    onOpenSettings: info.isAdmin
                        ? () => _openSpaceSettings(ref, context, info)
                        : null,
                    onLeave: () {
                      HapticFeedback.lightImpact();
                      showLeaveSpaceFlow(context, ref, info);
                    },
                  ),
              if (dissolved.isNotEmpty) ...[
                const SizedBox(height: 16),
                const Text(
                  '🗑 Архив (расформированные)',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                for (final info in dissolved)
                  SpaceCard(
                    info: info,
                    mode: mode,
                    formatter: formatter,
                    onOpenArchive: () {
                      HapticFeedback.lightImpact();
                      context.push('/spaces/${info.spaceId}/archive');
                    },
                  ),
              ],
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  CreateSpaceDialog.show(context);
                },
                icon: const Icon(Icons.add),
                label: const Text('Создать новое пространство'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  JoinSpaceDialog.show(context);
                },
                icon: const Icon(Icons.mail_outline),
                label: const Text('Присоединиться по приглашению'),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  void _openSpaceSettings(
    WidgetRef ref,
    BuildContext context,
    SpaceMembershipInfo info,
  ) {
    HapticFeedback.lightImpact();
    // Настройки пространства админ-скоупные: переключаем активное пространство
    // в обоих провайдерах (D17-14), затем открываем экран Этапа 18.
    ref.read(ar.currentSpaceIdProvider.notifier).setSpaceId(info.spaceId);
    ref.read(sec.currentSpaceIdProvider.notifier).set(info.spaceId);
    context.push('/admin/space-settings');
  }

  Widget _stats(int total, int active, int archived) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _stat('🏠', 'Пространств:', total),
          _stat('🟢', 'Активных:', active),
          _stat('🗑', 'Архив:', archived),
        ],
      ),
    );
  }

  Widget _stat(String icon, String label, int value) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(
          '$label $value',
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
        ),
      ],
    );
  }
}