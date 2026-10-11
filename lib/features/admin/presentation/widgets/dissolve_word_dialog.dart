import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';

/// Шаг 2 подтверждения расформирования (6.3.36.8): кодовое слово
/// «РАСФОРМИРОВАТЬ» (регистр и пробелы игнорируются). PIN запрашивается отдельно.
class DissolveWordDialog extends StatefulWidget {
  const DissolveWordDialog({super.key});
  @override
  State<DissolveWordDialog> createState() => _DissolveWordDialogState();
}

class _DissolveWordDialogState extends State<DissolveWordDialog> {
  final _controller = TextEditingController();
  static const String _keyword = 'РАСФОРМИРОВАТЬ';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _ok =>
      _controller.text.replaceAll(' ', '').trim().toUpperCase() == _keyword;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.surfaceCard,
      title: const Text('🔐 Подтвердите расформирование',
          style: TextStyle(color: AppColors.textPrimary)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Для подтверждения введите слово: РАСФОРМИРОВАТЬ',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.spacing12),
          TextField(
            controller: _controller,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              filled: true,
              fillColor: AppColors.surfaceElevated,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Отмена'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.colorExpense),
          onPressed: _ok ? () => Navigator.of(context).pop(true) : null,
          child: const Text('Расформировать'),
        ),
      ],
    );
  }
}