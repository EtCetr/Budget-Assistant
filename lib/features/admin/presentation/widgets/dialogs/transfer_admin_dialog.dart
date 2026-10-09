import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';

/// D17-6: сейчас — confirm-диалог с вводом слова «ПЕРЕДАТЬ».
/// PIN-подтверждение — долг Этапа 21.
class TransferAdminDialog extends StatefulWidget {
  const TransferAdminDialog({super.key, required this.target});
  final MemberInfo target;
  @override
  State<TransferAdminDialog> createState() => _TransferAdminDialogState();
}

class _TransferAdminDialogState extends State<TransferAdminDialog> {
  final _controller = TextEditingController();
  static const _keyword = 'ПЕРЕДАТЬ';

  @override
  void dispose() { _controller.dispose(); super.dispose(); }

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