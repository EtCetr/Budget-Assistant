import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/providers/transactions_trigger_provider.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/transactions/presentation/providers/transactions_log_providers.dart';
import 'package:budget_assistant/features/year_budget/presentation/providers/year_budget_providers.dart';
import '../providers/personal_share_providers.dart';

/// Этап 23.6c: личный чекбокс участника «Подключить мои личные транзакции».
/// Доступен всем ролям. Включение — разовая акция; выключение ничего не удаляет.
class PersonalShareTile extends ConsumerWidget {
  const PersonalShareTile({super.key, required this.spaceId});
  final String spaceId;

  Future<void> _toggle(
    BuildContext context,
    WidgetRef ref,
    String userId,
    bool next,
  ) async {
    HapticFeedback.selectionClick();
    final messenger = ScaffoldMessenger.of(context);
    final useCase = ref.read(setPersonalShareUseCaseProvider);
    final count = next ? await useCase.countPersonal(userId: userId) : 0;
    if (!context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: Text(next
            ? 'Подключить личные транзакции?'
            : 'Отключить подключение?'),
        content: Text(
          next
              ? 'Будет подключено операций: $count.\n\n'
                  'Они станут видны участникам группы. Это разовое действие: '
                  'новые личные операции останутся личными.'
              : 'Ранее подключённые операции ОСТАНУТСЯ в группе и будут видны '
                  'её участникам.\n\nОтключение ничего не удаляет — оно только '
                  'останавливает новые подключения.',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(d).pop(false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(d).pop(true),
            child: Text(next ? 'Подключить' : 'Отключить'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      final attached = await useCase(
        userId: userId,
        spaceId: spaceId,
        enabled: next,
      );
      ref.invalidate(personalShareFlagProvider('$userId|$spaceId'));
      ref.invalidate(transactionsLogProvider);
      ref.invalidate(yearBudgetDataProvider);
      ref.read(transactionsTriggerProvider.notifier).bump();
      HapticFeedback.mediumImpact();
      messenger.showSnackBar(SnackBar(
        content: Text(next
            ? 'Подключено транзакций: $attached'
            : 'Подключение отключено. Данные сохранены в группе'),
      ));
    } catch (e) {
      HapticFeedback.vibrate();
      messenger.showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = ref.watch(currentUserIdProvider);
    final enabled =
        ref.watch(personalShareFlagProvider('$userId|$spaceId')).value ?? false;
    return CheckboxListTile(
      value: enabled,
      onChanged: (v) => _toggle(context, ref, userId, v ?? false),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      title: const Text(
        'Подключить мои личные транзакции',
        style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
      ),
      subtitle: const Text(
        'Разово: прошлые личные операции станут видны участникам. '
        'Выключение их не удаляет.',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
    );
  }
}