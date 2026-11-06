// lib/features/settings/presentation/widgets/join_space_dialog.dart
// Этап 21 (ТЗ 6.3.51.5): присоединение по ссылке-приглашению.
// D21-21: парсим token из deep link и передаём в существующий AcceptInviteScreen
// (роут /join); HKDF-приём уже реализован в Этапе 17.
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/logger.dart';

class JoinSpaceDialog extends StatefulWidget {
  const JoinSpaceDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(context: context, builder: (_) => const JoinSpaceDialog());
  }

  @override
  State<JoinSpaceDialog> createState() => _JoinSpaceDialogState();
}

class _JoinSpaceDialogState extends State<JoinSpaceDialog> {
  final _controller = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String? _extractToken(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;
    final fromQuery = Uri.tryParse(trimmed)?.queryParameters['token'];
    if (fromQuery != null && fromQuery.isNotEmpty) return fromQuery;
    if (!trimmed.contains(' ')) return trimmed;
    return null;
  }

  void _submit() {
    final token = _extractToken(_controller.text);
    if (token == null) {
      setState(() => _error = 'Вставьте ссылку-приглашение или код');
      return;
    }
    final router = GoRouter.of(context);
    AppLogger.i('Join space: token extracted, routing to /join');
    Navigator.of(context).pop();
    router.push('/join?token=$token');
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('📩 Присоединиться по приглашению'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: 'Ссылка-приглашение',
          hintText: 'budgetassistant://join?token=...',
          errorText: _error,
        ),
        onChanged: (_) => setState(() => _error = null),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Отмена'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Продолжить')),
      ],
    );
  }
}