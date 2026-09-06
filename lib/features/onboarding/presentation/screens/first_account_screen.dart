// lib/features/onboarding/presentation/screens/first_account_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/core/router/routes.dart';
import 'package:budget_assistant/features/onboarding/domain/notifiers/onboarding_notifier.dart';
import 'package:budget_assistant/core/utils/amount_utils.dart';
import 'package:budget_assistant/features/accounts/presentation/providers/account_providers.dart';
import 'package:budget_assistant/core/providers/auth_providers.dart';
import 'package:budget_assistant/core/logger.dart';

class FirstAccountScreen extends ConsumerStatefulWidget {
  const FirstAccountScreen({super.key});

  @override
  ConsumerState<FirstAccountScreen> createState() => _FirstAccountScreenState();
}

class _FirstAccountScreenState extends ConsumerState<FirstAccountScreen> {
  final _initialBalanceController = TextEditingController();
  bool _isCreating = false;

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
              onPressed: _isCreating ? null : _createAccountAndComplete,
              child: _isCreating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createAccountAndComplete() async {
    final balanceStr = _initialBalanceController.text.trim();

    if (balanceStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an initial balance.')),
      );
      return;
    }

    setState(() => _isCreating = true);

    try {
      final balanceInRubles = double.tryParse(balanceStr) ?? 0.0;
      final balanceInKopecks = rublesToKopecks(balanceInRubles);

      debugPrint('Creating account with balance: $balanceInKopecks kopecks');

      // Получаем текущего пользователя
      final authRepo = ref.read(authRepositoryProvider);
      final currentUserResult = await authRepo.getCurrentUser();

      // ✅ ФИКС 1 (строка 92): when() возвращает String СИНХРОННО — await не нужен
      final userId = currentUserResult.when(
        success: (user) => user?.id ?? 'unknown_user',
        failure: (error) {
          AppLogger.e('Failed to get current user', error, StackTrace.current);
          return 'unknown_user';
        },
      );

      // Создаём первый счёт через UseCase
      final useCase = ref.read(createAccountUseCaseProvider);
      final result = await useCase.execute(
        userId: userId,
        bankName: 'Default Bank',
        customName: 'My First Account',
        accountType: 'debit',
        currency: 'RUB',
        currentBalance: balanceInKopecks,
      );

      // ✅ ФИКС 2 (строки 121-122): complete()/completeOnboarding() возвращают void —
      // убираем await и async-колбэки
      result.when(
        success: (account) {
          AppLogger.i('First account created: ${account.id}');

          // Сохраняем баланс в онбординг-стейт
          ref
              .read(onboardingProvider.notifier)
              .setInitialBalance(balanceInKopecks);

          // Завершаем онбординг (void-методы, без await)
          ref.read(onboardingStatusProvider.notifier).complete();
          ref.read(onboardingProvider.notifier).completeOnboarding();

          // ✅ ЯВНАЯ НАВИГАЦИЯ на главный экран
          if (mounted) {
            context.go(AppRoutes.home);
          }
        },
        failure: (failure) {
          AppLogger.e(
            'Failed to create first account',
            failure,
            StackTrace.current,
          );

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to create account: ${failure.message}'),
              ),
            );
          }
        },
      );
    } catch (e, stackTrace) {
      AppLogger.e(
        'Unexpected error in _createAccountAndComplete',
        e,
        stackTrace,
      );

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
      }
    }
  }
}
