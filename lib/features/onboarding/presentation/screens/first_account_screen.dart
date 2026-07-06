// lib/features/onboarding/presentation/screens/first_account_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/features/onboarding/domain/notifiers/onboarding_notifier.dart';
import 'package:budget_assistant/core/utils/amount_utils.dart'; // Убедитесь, что этот файл существует

// Изменено на ConsumerStatefulWidget для корректного dispose контроллера
class FirstAccountScreen extends ConsumerStatefulWidget {
  const FirstAccountScreen({super.key});

  @override
  ConsumerState<FirstAccountScreen> createState() => _FirstAccountScreenState();
}

class _FirstAccountScreenState extends ConsumerState<FirstAccountScreen> {
  final TextEditingController _initialBalanceController =
      TextEditingController();

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
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
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
                    // Парсинг в double допустим ТОЛЬКО на UI-слое перед конвертацией
                    final balanceInRubles = double.tryParse(balanceStr) ?? 0.0;
                    final balanceInKopecks = rublesToKopecks(balanceInRubles);

                    debugPrint(
                      'Creating account with balance: $balanceInKopecks kopecks',
                    );

                    // Сохраняем баланс и завершаем онбординг
                    ref
                        .read(onboardingProvider.notifier)
                        .setInitialBalance(balanceInKopecks);

                    // TODO: Вызвать CreateAccountUseCase перед completeOnboarding
                    ref
                        .read(onboardingProvider.notifier)
                        .completeOnboarding();
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
