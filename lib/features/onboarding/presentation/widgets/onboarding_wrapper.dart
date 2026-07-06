// lib/features/onboarding/presentation/widgets/onboarding_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/features/onboarding/domain/enums/onboarding_step.dart';
import 'package:budget_assistant/features/onboarding/domain/notifiers/onboarding_notifier.dart';
import 'package:budget_assistant/features/onboarding/presentation/screens/welcome_screen.dart';
import 'package:budget_assistant/features/onboarding/presentation/screens/base_currency_screen.dart';
import 'package:budget_assistant/features/onboarding/presentation/screens/security_setup_screen.dart';
import 'package:budget_assistant/features/onboarding/presentation/screens/space_decision_screen.dart';
import 'package:budget_assistant/features/onboarding/presentation/screens/first_account_screen.dart';

class OnboardingWrapper extends ConsumerWidget {
  const OnboardingWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch возвращает OnboardingState, а не Enum
    final state = ref.watch(onboardingProvider);
    final currentStep = state.currentStep;

    Widget currentScreen = const SizedBox.shrink();

    switch (currentStep) {
      case OnboardingStep.welcome:
        currentScreen = const WelcomeScreen();
        break;
      case OnboardingStep.baseCurrency:
        currentScreen = const BaseCurrencyScreen();
        break;
      case OnboardingStep.securitySetup:
        currentScreen = const SecuritySetupScreen();
        break;
      case OnboardingStep.spaceDecision:
        currentScreen = const SpaceDecisionScreen();
        break;
      case OnboardingStep.firstAccount:
        currentScreen = const FirstAccountScreen();
        break;
      case OnboardingStep.completed:
        currentScreen = const Scaffold(
          body: Center(child: Text('Onboarding Completed! Redirecting...')),
        );
        break;
    }

    return currentScreen;
  }
}
