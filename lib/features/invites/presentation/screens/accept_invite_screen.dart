import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AcceptInviteScreen extends ConsumerWidget {
  final String? token;

  const AcceptInviteScreen({super.key, this.token});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Присоединение к пространству')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
                'Токен: ${token != null ? '${token!.substring(0, 8)}...' : 'неизвестен'}',
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // TODO: Вызвать AcceptInvitationUseCase
                    // 1. HKDF деривация ключа из token
                    // 2. Расшифровка encrypted_salt
                    // 3. Сохранение SpaceMasterKey в SecureStorage
                    // 4. Редирект на Home
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Принятие инвайта (Заглушка)'),
                        ),
                      );
                    }
                  },
                  child: const Text('Принять приглашение'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
