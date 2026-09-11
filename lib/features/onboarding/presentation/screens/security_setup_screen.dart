import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/features/onboarding/domain/notifiers/onboarding_notifier.dart';

class SecuritySetupScreen extends ConsumerWidget {
  const SecuritySetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройка безопасности')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Защитите ваши данные',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Настройте PIN-код и биометрию для безопасного доступа к вашим финансам. Данные шифруются локально на устройстве.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),
              OutlinedButton.icon(
                onPressed: () async {
                  // 1. Запускаем PinOnboardingScreen
                  // Согласно ТЗ 6.0 (6.3.29), на STEP 4 он сам предложит биометрию, если она доступна.
                  final pinResult = await context.push<bool>(
                    '/security/pin-onboarding',
                  );

                  // 2. Если PIN успешно установлен, переходим к следующему шагу онбординга
                  if (pinResult == true && context.mounted) {
                    ref
                        .read(onboardingProvider.notifier)
                        .goToNextStep();
                  }
                },
                icon: const Icon(Icons.lock_outline),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Установить PIN-код',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () async {
                  // Альтернативный путь: настройка только биометрии
                  // (если PIN уже установлен ранее или пользователь хочет включить её отдельно)
                  final bioResult = await context.push<bool>(
                    '/security/biometric-onboarding',
                  );

                  if (bioResult == true && context.mounted) {
                    ref
                        .read(onboardingProvider.notifier)
                        .goToNextStep();
                  }
                },
                icon: const Icon(Icons.fingerprint),
                label: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Настроить биометрию',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  // Пропустить настройку безопасности и перейти к следующему шагу (Space Decision)
                  ref.read(onboardingProvider.notifier).goToNextStep();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Продолжить без настройки',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
