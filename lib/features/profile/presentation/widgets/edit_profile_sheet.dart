// lib/features/profile/presentation/widgets/edit_profile_sheet.dart
// Этап 21 (ТЗ 6.3.39.3): BottomSheet редактирования профиля.
// D21-28: сжатие аватара 512×512/80% — параметрами image_picker.
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/debts/domain/usecases/decline_name_usecase.dart';
import 'package:budget_assistant/features/profile/presentation/providers/profile_providers.dart';

class EditProfileSheet extends ConsumerStatefulWidget {
  const EditProfileSheet({super.key, required this.user});

  final User user;

  static Future<void> show(BuildContext context, User user) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceCard,
      builder: (_) => EditProfileSheet(user: user),
    );
  }

  @override
  ConsumerState<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends ConsumerState<EditProfileSheet> {
  late TextEditingController _nameController;
  late TextEditingController _dativeController;
  String? _avatarPath;
  bool _clearAvatar = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.displayName);
    _dativeController =
        TextEditingController(text: widget.user.displayNameDative ?? '');
    _avatarPath = widget.user.avatarPath;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dativeController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar(ImageSource source) async {
    HapticFeedback.selectionClick();
    try {
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (picked == null) return;
      final dir = await getApplicationDocumentsDirectory();
      final avDir = Directory('${dir.path}/avatars');
      await avDir.create(recursive: true);
      final target = File('${avDir.path}/${widget.user.id}.jpg');
      await File(picked.path).copy(target.path);
      if (!mounted) return;
      setState(() {
        _avatarPath = target.path;
        _clearAvatar = false;
      });
    } catch (e, st) {
      AppLogger.e('Avatar pick failed', e, st);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Не удалось выбрать фото')),
        );
      }
    }
  }

  Future<void> _decline() async {
    HapticFeedback.mediumImpact();
    final result = DeclineNameUseCase()(_nameController.text.trim());
    if (!result.success) {
      if (!mounted) return;
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Не удалось склонить имя — введите дательный падеж вручную'),
        ),
      );
      return;
    }
    _dativeController.text = result.dative;
    if (!mounted) return;
    await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: const Text('✅ Имя просклонено'),
        content: Text(
          'В уведомлениях о долгах мы будем писать: '
          '"Вы должны ${result.dative} 500 ₽ за ЖКХ". Всё верно?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Изменить'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Да, оставить'),
          ),
        ],
      ),
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || name.length > 50) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Имя: от 1 до 50 символов')),
      );
      return;
    }
    setState(() => _saving = true);
    HapticFeedback.mediumImpact();
    try {
      await ref.read(updateProfileUseCaseProvider).call(
        userId: widget.user.id,
        displayName: name,
        displayNameDative: _dativeController.text.trim(),
        avatarPath: _clearAvatar ? null : _avatarPath,
        clearAvatar: _clearAvatar,
      );
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Ошибка сохранения: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Редактировать профиль',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '📷 Аватар',
              style: TextStyle(color: AppColors.textPrimary, fontSize: 15),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: () => _pickAvatar(ImageSource.camera),
                  icon: const Icon(Icons.photo_camera_outlined, size: 18),
                  label: const Text('Сделать фото'),
                ),
                OutlinedButton.icon(
                  onPressed: () => _pickAvatar(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined, size: 18),
                  label: const Text('Выбрать из галереи'),
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    setState(() {
                      _avatarPath = null;
                      _clearAvatar = true;
                    });
                  },
                  icon: const Icon(Icons.text_fields_outlined, size: 18),
                  label: const Text('Инициалы (дефолт)'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: '✏️ Имя',
                hintText: 'Иван Петров',
              ),
            ),
            const Text(
              '💡 Длина: 1-50 символов',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _dativeController,
              decoration: const InputDecoration(
                labelText: '✏️ Имя в дательном падеже',
                hintText: 'Ивану Петровичу',
              ),
            ),
            const Text(
              '💡 Используется в пушах: "Вы должны Ивану Петровичу"',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _decline,
              icon: const Icon(Icons.autorenew, size: 18),
              label: const Text('Склонить автоматически'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                TextButton(
                  onPressed: _saving ? null : () => Navigator.pop(context),
                  child: const Text('Отмена'),
                ),
                const Spacer(),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Сохранить'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}