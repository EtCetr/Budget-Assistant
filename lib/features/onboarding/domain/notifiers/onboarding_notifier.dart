import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:budget_assistant/features/onboarding/domain/state/onboarding_state.dart';
import 'package:budget_assistant/features/onboarding/domain/enums/onboarding_step.dart';

part 'onboarding_notifier.g.dart';

@riverpod
class OnboardingNotifier extends _$OnboardingNotifier {
  @override
  OnboardingState build() {
    return const OnboardingState();
  }

  void goToNextStep() {
    final nextStep = switch (state.currentStep) {
      OnboardingStep.welcome => OnboardingStep.baseCurrency,
      OnboardingStep.baseCurrency => OnboardingStep.securitySetup,
      OnboardingStep.securitySetup => OnboardingStep.spaceDecision,
      OnboardingStep.spaceDecision => OnboardingStep.transferProfile,
      OnboardingStep.transferProfile ||
      OnboardingStep.completed => OnboardingStep.completed,
    };
    state = state.copyWith(currentStep: nextStep);
  }

  void setBaseCurrency(String currencyCode) {
    state = state.copyWith(baseCurrency: currencyCode);
  }

  void completeOnboarding() {
    state = state.copyWith(currentStep: OnboardingStep.completed);
  }
}