// lib/features/settings/presentation/widgets/leave_space_dialogs.dart
// Этап 21 (ТЗ 6.3.51.3): флоу выхода из пространства — 4 сценария.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import 'package:budget_assistant/features/settings/presentation/providers/spaces_management_providers.dart';
import 'package:budget_assistant/features/spaces/domain/entities/space_membership_info.dart';
import 'package:budget_assistant/features/spaces/domain/usecases/leave_space_usecase.dart';

Future<void> showLeaveSpaceFlow(
  BuildContext context,
  WidgetRef ref,
  SpaceMembershipInfo info,
) async {
  final messenger = ScaffoldMessenger.of(context);
  final useCase = ref.read(leaveSpaceUseCaseProvider);
  final userId = ref.read(currentUserIdProvider);
  try {
    final eval =
        await useCase.evaluate(userId: userId, spaceId: info.spaceId);
    if (!context.mounted) return;
    switch (eval.scenario) {
      case LeaveSpaceScenario.dissolveSolo:
        final ok = await _confirm(
          context,
          '🗑️ Расформировать пространство?',
          'Вы единственный участник. Пространство будет расформировано, '
              'данные перейдут в архив.',
        );
        if (ok == true) {
          await useCase.dissolveSolo(userId: userId, spaceId: info.spaceId);
          messenger.showSnackBar(
            const SnackBar(content: Text('✅ Пространство расформировано')),
          );
        }
      case LeaveSpaceScenario.autoPromote:
        final ok = await _confirm(
          context,
          '🚪 Выйти из пространства?',
          'Оставшийся участник автоматически станет админом.',
        );
        if (ok == true) {
          await useCase.leaveWithAutoPromote(
            userId: userId,
            spaceId: info.spaceId,
          );
          messenger.showSnackBar(
            const SnackBar(content: Text('✅ Вы вышли из пространства')),
          );
        }
      case LeaveSpaceScenario.chooseSuccessor:
        final successor = await _pickSuccessor(context, ref, eval.candidates);
        if (successor != null) {
          await useCase.leaveWithSuccessor(
            userId: userId,
            spaceId: info.spaceId,
            successorUserId: successor,
          );
          messenger.showSnackBar(
            const SnackBar(content: Text('✅ Вы вышли из пространства')),
          );
        }
      case LeaveSpaceScenario.simpleLeave:
        final ok = await _confirm(
          context,
          '🚪 Выйти из пространства?',
          'Ваши транзакции в пространстве будут скрыты (архив).',
        );
        if (ok == true) {
          await useCase.simpleLeave(userId: userId, spaceId: info.spaceId);
          messenger.showSnackBar(
            const SnackBar(content: Text('✅ Вы вышли из пространства')),
          );
        }
    }
  } catch (e) {
    messenger.showSnackBar(
      SnackBar(content: Text('❌ Не удалось выйти: $e')),
    );
  }
}

Future<bool?> _confirm(BuildContext context, String title, String text) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surfaceCard,
      title: Text(title),
      content: Text(text),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Подтвердить'),
        ),
      ],
    ),
  );
}

Future<String?> _pickSuccessor(
  BuildContext context,
  WidgetRef ref,
  List<Membership> candidates,
) async {
  final db = ref.read(appDatabaseProvider);
  final users = await db.select(db.users).get();
  final names = {for (final u in users) u.id: u.displayName};
  final formatter = ref.read(privacyFormatterProvider);
  if (!context.mounted) return null;
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppColors.surfaceCard,
      title: const Text('👑 Выберите преемника'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            for (final c in candidates)
              ListTile(
                title: Text(
                  formatter.formatName(
                    names[c.userId] ?? c.userId,
                    BalanceVisibilityMode.visible,
                  ),
                  style: const TextStyle(color: AppColors.textPrimary),
                ),
                onTap: () => Navigator.pop(ctx, c.userId),
              ),
          ],
        ),
      ),
    ),
  );
}