import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/router/app_router.dart';

class AppLockScreen extends ConsumerWidget {
  const AppLockScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 80, color: Colors.grey),
              const SizedBox(height: 24),
              const Text(
                'Приложение заблокировано',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Вызвать UseCase проверки PIN/Биометрии
                  // Заглушка: просто снимаем блокировку через мутатор
                  ref.read(appLockProvider.notifier).unlock();
                },
                icon: const Icon(Icons.fingerprint),
                label: const Text('Разблокировать'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
