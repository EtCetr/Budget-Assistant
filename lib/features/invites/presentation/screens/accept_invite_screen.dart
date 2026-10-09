import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/admin/presentation/providers/admin_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/core/router/app_router.dart';

/// Принятие приглашения (deep link budgetassistant://join?token=...).
/// TODO(Этап 25): cross-device приём инвайта (Supabase RPC). Локальный флоу закрыт на Этапе 17:
/// HKDF -> decrypt encrypted_salt -> enc_key_{space_id} -> membership -> Home.
class AcceptInviteScreen extends ConsumerStatefulWidget {
  const AcceptInviteScreen({super.key, this.token});
  final String? token;
  @override
  ConsumerState<AcceptInviteScreen> createState() => _AcceptInviteScreenState();
}

class _AcceptInviteScreenState extends ConsumerState<AcceptInviteScreen> {
  bool _busy = false;
  String? _error;

  Future<void> _accept() async {
    final token = widget.token;
    if (token == null || token.isEmpty) {
      setState(() => _error = 'Ссылка приглашения повреждена');
      return;
    }
    setState(() { _busy = true; _error = null; });
    try {
      final userId = ref.read(currentUserIdProvider);
      final newSpaceId = await ref.read(acceptInvitationUseCaseProvider)
          .call(linkToken: token, userId: userId);
      if (mounted) {
        ref.read(currentSpaceIdProvider.notifier).setSpaceId(newSpaceId);
        context.go('/');
      }
    } catch (e) {
      if (mounted) setState(() => _error = '$e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final token = widget.token;
    return Scaffold(
      appBar: AppBar(title: const Text('Присоединение к пространству')),
      body: Center(child: Padding(padding: const EdgeInsets.all(24.0),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.group_add, size: 64, color: Colors.blue),
        const SizedBox(height: 24),
        const Text('Вас пригласили в семейное пространство', textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Text('Код: ${token != null && token.length > 8 ? '${token.substring(0, 8)}...' : 'неизвестен'}',
            style: const TextStyle(color: Colors.grey)),
        if (_error != null) ...[
          const SizedBox(height: 16),
          Text(_error!, textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.red)),
        ],
        const SizedBox(height: 32),
        SizedBox(width: double.infinity, child: ElevatedButton(
          onPressed: _busy ? null : _accept,
          child: _busy
              ? const SizedBox(width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Присоединиться'),
        )),
        const SizedBox(height: AppSpacing.spacing12),
        TextButton(onPressed: () => context.go('/'), child: const Text('Отмена')),
      ]))),
    );
  }
}
