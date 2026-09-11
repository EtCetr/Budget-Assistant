// lib/features/onboarding/presentation/screens/base_currency_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/features/onboarding/domain/notifiers/onboarding_notifier.dart';

class CurrencyOption {
  final String code;
  final String name;
  final String symbol;
  const CurrencyOption(this.code, this.name, this.symbol);
}

class BaseCurrencyScreen extends ConsumerWidget {
  const BaseCurrencyScreen({super.key});

  static const List<CurrencyOption> _currencies = [
    CurrencyOption('RUB', 'Russian Ruble', '₽'),
    CurrencyOption('USD', 'US Dollar', '\$'),
    CurrencyOption('EUR', 'Euro', '€'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Base Currency')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: _currencies.length,
          itemBuilder: (context, index) {
            final currency = _currencies[index];
            return Card(
              child: ListTile(
                title: Text('${currency.name} (${currency.code})'),
                subtitle: Text('Symbol: ${currency.symbol}'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  // 1. Сохраняем выбор в состояние
                  ref
                      .read(onboardingProvider.notifier)
                      .setBaseCurrency(currency.code);
                  // 2. Переходим к следующему шагу
                  ref.read(onboardingProvider.notifier).goToNextStep();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
