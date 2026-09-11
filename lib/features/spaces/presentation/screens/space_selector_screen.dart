import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/router/app_router.dart';

class SpaceSelectorScreen extends ConsumerWidget {
  const SpaceSelectorScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Выбор пространства')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_tree, size: 64, color: Colors.blue),
            const SizedBox(height: 24),
            const Text(
              'Выберите пространство',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // TODO: Загрузить реальный список пространств из БД
                // Заглушка: устанавливаем личный space_id через мутатор
                ref
                    .read(currentSpaceIdProvider.notifier)
                    .setSpaceId('personal_space_mock_id');
              },
              child: const Text('Личное пространство'),
            ),
          ],
        ),
      ),
    );
  }
}
