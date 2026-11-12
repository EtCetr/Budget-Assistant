import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/admin/presentation/providers/admin_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/features/spaces/presentation/providers/personal_share_providers.dart';

/// Принятие приглашения + разовый чекбокс подключения личных транзакций
/// (Этап 23.6c).
class AcceptInviteScreen extends ConsumerStatefulWidget {
  const AcceptInviteScreen({super.key, this.token});
  final String? token;

  @override
  ConsumerState<AcceptInviteScreen> createState() => _AcceptInviteScreenState();
}

class _AcceptInviteScreenState extends ConsumerState<AcceptInviteScreen> {
  bool _busy = false;
  bool _attachExisting = false;
  String? _error;

  Future<void> _accept() async {
    final token = widget.token;
    if (token == null || token.isEmpty) {
      setState(() => _error = 'Ссылка приглашения повреждена');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final userId = ref.read(currentUserIdProvider);
      final newSpaceId = await ref
          .read(acceptInvitationUseCaseProvider)
          .call(linkToken: token, userId: userId);
      if (_attachExisting) {
        try {
          await ref.read(setPersonalShareUseCaseProvider)(
            userId: userId,
            spaceId: newSpaceId,
            enabled: true,
          );
        } catch (e, st) {
          AppLogger.e('Attach personal on join failed', e, st);
        }
      }
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Icon(Icons.group_add, size: 64, color: Colors.blue),
              const SizedBox(height: 24),
              const Text(
                'Вас пригласили в семейное пространство',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                'Код: ${token != null && token.length > 8 ? '${token.substring(0, 8)}...' : 'неизвестен'}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 16),
              CheckboxListTile(
                value: _attachExisting,
                onChanged: _busy
                    ? null
                    : (v) => setState(() => _attachExisting = v ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
                title: const Text('Подключить мои личные транзакции'),
                subtitle: const Text(
                  'Операции, созданные до группы, станут видны её участникам. '
                  'Действие разовое и необратимое.',
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 16),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _busy ? null : _accept,
                  child: _busy
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Присоединиться'),
                ),
              ),
              const SizedBox(height: AppSpacing.spacing12),
              TextButton(
                onPressed: () => context.go('/'),
                child: const Text('Отмена'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}