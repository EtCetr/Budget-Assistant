// lib/features/home/presentation/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Budget Assistant'), centerTitle: true),
      // ✅ УБРАЛИ const снаружи: внутри кнопки с замыканиями onPressed
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_balance_wallet,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to Budget Assistant v6.0',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Core Architecture Initialized.',
              style: TextStyle(color: Colors.grey),
            ),
            ElevatedButton(
              onPressed: () => context.go('/accounts'),
              child: const Text('Счета (QA)'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.go('/categories'),
              child: const Text('Категории (QA)'),
            ),
          ],
        ),
      ),
    );
  }
}
