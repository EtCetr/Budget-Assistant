import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/features/settings/presentation/providers/settings_providers.dart';

/// D17-6: сейчас — confirm-диалог с вводом слова «ПЕРЕДАТЬ».
/// PIN-подтверждение — долг Этапа 21.
class TransferAdminDialog extends ConsumerStatefulWidget {
  const TransferAdminDialog({super.key, required this.target});
  final MemberInfo target;
  @override
  ConsumerState<TransferAdminDialog> createState() => _TransferAdminDialogState();
}

class _TransferAdminDialogState extends ConsumerState<TransferAdminDialog> {
  final _controller = TextEditingController();
  static const _keyword = 'ПЕРЕДАТЬ';

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _guardPin());
  }

  /// D17-6 закрыт: PIN-подтверждение перед передачей роли
  /// (если require_pin_for_sensitive && enable_pin_code).
  Future<void> _guardPin() async {
    if (!mounted) return;
    try {
      final s = await ref.read(appSettingsRowProvider.future);
      if (!mounted) return;
      if (s == null || !s.requirePinForSensitive || !s.enablePinCode) return;
      final ok = await context.push('/security/pin-entry?mode=verify');
      if (ok != true) {
        if (!mounted) return;
        Navigator.of(context).pop(false);
      }
    } catch (e) {
      // Настройки недоступны — PIN не настроен, передачу разрешаем.
    }
  }

  @override
  Widget build(BuildContext context) {
    final ok = _controller.text.trim() == _keyword;
    return AlertDialog(
      backgroundColor: AppColors.surfaceCard,
      title: const Text('Передача роли администратора',
          style: TextStyle(color: AppColors.textPrimary)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        Text('Вы передаёте свою роль администратора участнику '
            '${widget.target.displayName}. После передачи вы станете обычным участником.',
            style: const TextStyle(color: AppColors.textSecondary)),
        const SizedBox(height: AppSpacing.spacing16),
        TextField(
          controller: _controller,
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            hintText: 'Введите слово «ПЕРЕДАТЬ»',
            hintStyle: const TextStyle(color: AppColors.textSecondary),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
        ),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена')),
        FilledButton(
          onPressed: ok ? () => Navigator.of(context).pop(true) : null,
          style: FilledButton.styleFrom(backgroundColor: AppColors.colorExpense),
          child: const Text('Передать'),
        ),
      ],
    );
  }
}