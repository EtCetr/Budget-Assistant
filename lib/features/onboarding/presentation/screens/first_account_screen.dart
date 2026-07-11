import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/core/router/routes.dart';
import 'package:budget_assistant/features/onboarding/domain/notifiers/onboarding_notifier.dart';
import 'package:budget_assistant/core/utils/amount_utils.dart';

class FirstAccountScreen extends ConsumerStatefulWidget {
  const FirstAccountScreen({super.key});

  @override
  ConsumerState<FirstAccountScreen> createState() => _FirstAccountScreenState();
}

class _FirstAccountScreenState extends ConsumerState<FirstAccountScreen> {
  final _initialBalanceController = TextEditingController();

  @override
  void dispose() {
    _initialBalanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Your First Account')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Let\'s start by adding an account with an initial balance.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _initialBalanceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Initial Balance (₽)',
                prefixIcon: Icon(Icons.money),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final balanceStr = _initialBalanceController.text.trim();
                if (balanceStr.isNotEmpty) {
                  try {
                    final balanceInRubles = double.tryParse(balanceStr) ?? 0.0;
                    final balanceInKopecks = rublesToKopecks(balanceInRubles);

                    debugPrint(
                      'Creating account with balance: $balanceInKopecks kopecks',
                    );

                    // Сохраняем баланс
                    ref
                        .read(onboardingProvider.notifier)
                        .setInitialBalance(balanceInKopecks);

                    // TODO: Вызвать CreateAccountUseCase перед completeOnboarding
                    
                    // Завершаем онбординг
                    ref.read(onboardingStatusProvider.notifier).complete();
                    ref.read(onboardingProvider.notifier).completeOnboarding();
                    
                    // ✅ ЯВНАЯ НАВИГАЦИЯ на главный экран
                    context.go(AppRoutes.home);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid amount: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please enter an initial balance.'),
                    ),
                  );
                }
              },
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}
