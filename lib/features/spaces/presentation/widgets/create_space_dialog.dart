import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/core/providers/security_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../providers/space_providers.dart';

/// Минимальный диалог создания семейной группы.
///
/// Создаёт space + membership(admin) локально и делает группу активной.
/// Чекбокс «Подключить личные транзакции» (дефолт ВЫКЛ — приватность):
/// при галочке история с space_id = NULL сразу уходит в новую группу.
/// Приглашения, роли и HKDF-передача ключей — Этап 17.
class CreateSpaceDialog extends ConsumerStatefulWidget {
  const CreateSpaceDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(context: context, builder: (_) => const CreateSpaceDialog());
  }

  @override
  ConsumerState<CreateSpaceDialog> createState() => _CreateSpaceDialogState();
}

class _CreateSpaceDialogState extends ConsumerState<CreateSpaceDialog> {
  final _nameController = TextEditingController();
  bool _saving = false;
  bool _attachExisting = false;
  String? _error;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = 'Введите название группы');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final userId = ref.read(currentUserIdProvider);
      final result =
          await ref.read(createSpaceUseCaseProvider)(userId: userId, name: name);
      switch (result) {
        case Success(:final value):
          // Делаем новую группу активной для семейного скоупа.
          ref.read(currentSpaceIdProvider.notifier).set(value.id);
          var message = 'Группа «${value.name}» создана';
          if (_attachExisting) {
            final attachResult =
                await ref.read(attachPersonalTransactionsUseCaseProvider)(
              userId: userId,
              spaceId: value.id,
            );
            if (attachResult is Success<int>) {
              message = 'Группа «${value.name}» создана. '
                  'Подключено транзакций: ${attachResult.value}';
            } else {
              message = 'Группа «${value.name}» создана, '
                  'но транзакции подключить не удалось';
            }
          }
          if (!mounted) return;
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        case Error(:final failure):
          if (!mounted) return;
          setState(() {
            _saving = false;
            _error = failure.message;
          });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Не удалось создать группу: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Новая семейная группа'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Название группы',
                hintText: 'напр. Семья Ивановых',
                errorText: _error,
              ),
              onChanged: (_) => setState(() => _error = null),
            ),
            CheckboxListTile(
              value: _attachExisting,
              onChanged: (v) => setState(() => _attachExisting = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: const Text('Подключить мои личные транзакции'),
              subtitle: const Text(
                'Операции, созданные до группы, станут видны её участникам',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        FilledButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Создать'),
        ),
      ],
    );
  }
}