import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/providers/transactions_trigger_provider.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/spaces/domain/entities/user_space.dart';
import 'package:budget_assistant/features/spaces/presentation/providers/space_providers.dart';
import '../providers/transaction_scope_providers.dart';
import '../providers/transactions_log_providers.dart';

/// Этап 23.6: шит «Пространство» — состав группы копий операции.
Future<void> showTransactionSpaceSheet({
  required BuildContext context,
  required WidgetRef ref,
  required String transactionId,
}) async {
  await showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => _SpaceSheet(transactionId: transactionId),
  );
}

class _SpaceSheet extends ConsumerStatefulWidget {
  const _SpaceSheet({required this.transactionId});
  final String transactionId;

  @override
  ConsumerState<_SpaceSheet> createState() => _SpaceSheetState();
}

class _SpaceSheetState extends ConsumerState<_SpaceSheet> {
  bool _personal = true;
  Set<String> _spaces = <String>{};
  bool _loaded = false;
  bool _busy = false;

  Future<void> _save() async {
    if (!_personal && _spaces.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Оставьте хотя бы одно пространство')),
      );
      return;
    }
    setState(() => _busy = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(setTransactionSpacesUseCaseProvider)(
        transactionId: widget.transactionId,
        personal: _personal,
        spaceIds: _spaces,
        userId: ref.read(currentUserIdProvider),
      );
      ref.read(transactionsTriggerProvider.notifier).bump();
      ref.invalidate(transactionsLogProvider);
      ref.invalidate(transactionGroupScopesProvider(widget.transactionId));
      if (!mounted) return;
      Navigator.of(context).pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Пространства операции обновлены')),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(SnackBar(content: Text('Ошибка: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scopes =
        ref.watch(transactionGroupScopesProvider(widget.transactionId));
    final spaces = ref.watch(userSpacesProvider).value ?? const <UserSpace>[];
    scopes.whenData((s) {
      if (!_loaded) {
        _loaded = true;
        _personal = s.personal;
        _spaces = {...s.spaceIds};
      }
    });
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.spacing16,
          right: AppSpacing.spacing16,
          top: AppSpacing.spacing16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Пространство операции',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text(
              'Отметьте, где операция должна учитываться. '
              'Копии связаны: правка и удаление применятся ко всем.',
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.spacing12),
            CheckboxListTile(
              value: _personal,
              onChanged: (v) => setState(() => _personal = v ?? false),
              title: const Text('Личное'),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
            ),
            for (final s in spaces)
              CheckboxListTile(
                value: _spaces.contains(s.id),
                onChanged: (v) => setState(() {
                  if (v == true) {
                    _spaces.add(s.id);
                  } else {
                    _spaces.remove(s.id);
                  }
                }),
                title: Text(s.name),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
            const SizedBox(height: AppSpacing.spacing12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _busy ? null : () => Navigator.of(context).pop(),
                    child: const Text('Отмена'),
                  ),
                ),
                const SizedBox(width: AppSpacing.spacing12),
                Expanded(
                  child: FilledButton(
                    onPressed: _busy ? null : _save,
                    child: _busy
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Применить'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}