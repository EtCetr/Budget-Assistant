import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/admin/presentation/widgets/family_colors.dart';

/// Шит редактирования identity пространства (6.3.36.3):
/// 12 эмодзи + 12 цветов палитры семьи + название (1-50 символов).
Future<void> showEditSpaceIdentitySheet(
  BuildContext context, {
  required String initialName,
  required String initialEmoji,
  required String initialColor,
  required Future<void> Function(String name, String emoji, String color) onSave,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.surfaceCard,
    builder: (_) => _EditSpaceIdentitySheet(
      initialName: initialName,
      initialEmoji: initialEmoji,
      initialColor: initialColor,
      onSave: onSave,
    ),
  );
}

class _EditSpaceIdentitySheet extends StatefulWidget {
  const _EditSpaceIdentitySheet({
    required this.initialName,
    required this.initialEmoji,
    required this.initialColor,
    required this.onSave,
  });
  final String initialName;
  final String initialEmoji;
  final String initialColor;
  final Future<void> Function(String name, String emoji, String color) onSave;
  @override
  State<_EditSpaceIdentitySheet> createState() => _EditSpaceIdentitySheetState();
}

class _EditSpaceIdentitySheetState extends State<_EditSpaceIdentitySheet> {
  static const List<String> _emojis = [
    '👨‍👩‍👧', '💼', '', '', '🎮', '✈️',
    '🛒', '', '👕', '🎂', '', '🎁',
  ];
  late final TextEditingController _name =
      TextEditingController(text: widget.initialName);
  late String _emoji = widget.initialEmoji;
  late String _color = widget.initialColor;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    HapticFeedback.mediumImpact();
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.onSave(_name.text, _emoji, _color);
      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _busy = false;
          _error = '$e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.spacing16,
          right: AppSpacing.spacing16,
          top: AppSpacing.spacing16,
          bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.spacing16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Редактировать пространство',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.spacing12),
            const Text('👨‍👩‍👧 Иконка',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: AppSpacing.spacing8),
            Wrap(
              spacing: AppSpacing.spacing8,
              runSpacing: AppSpacing.spacing8,
              children: [
                for (final e in _emojis)
                  InkWell(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _emoji = e);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.spacing8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: e == _emoji
                              ? AppColors.colorFAB
                              : AppColors.borderDivider,
                          width: e == _emoji ? 2 : 1,
                        ),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
                      ),
                      child: Text(e, style: const TextStyle(fontSize: 22)),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.spacing12),
            const Text('🎨 Цвет фона',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: AppSpacing.spacing8),
            Wrap(
              spacing: AppSpacing.spacing8,
              runSpacing: AppSpacing.spacing8,
              children: [
                for (final c in kFamilyPalette)
                  InkWell(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setState(() => _color = '#${c.toARGB32().toRadixString(16).padLeft(8, '0')}');
                    },
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _color == '#${c.toARGB32().toRadixString(16).padLeft(8, '0')}'
                              ? Colors.white
                              : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.spacing12),
            const Text('✏️ Название',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: AppSpacing.spacing8),
            TextField(
              controller: _name,
              maxLength: 50,
              decoration: const InputDecoration(
                hintText: 'Например, Семья Ивановых',
                filled: true,
                fillColor: AppColors.surfaceElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
                ),
              ),
            ),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: AppColors.colorExpense)),
            const SizedBox(height: AppSpacing.spacing8),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Отмена'),
                  ),
                ),
                const SizedBox(width: AppSpacing.spacing12),
                Expanded(
                  child: FilledButton(
                    onPressed: _busy ? null : _save,
                    child: _busy
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Сохранить'),
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