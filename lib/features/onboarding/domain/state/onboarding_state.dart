// lib/features/onboarding/domain/state/onboarding_state.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:budget_assistant/features/onboarding/domain/enums/onboarding_step.dart';

// ВАЖНО: Эта строка связывает файл с генератором freezed
part 'onboarding_state.freezed.dart';

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory OnboardingState({
    @Default(OnboardingStep.welcome) OnboardingStep currentStep,
    String? baseCurrency,
    int? initialBalanceKopecks,
  }) = _OnboardingState;
}
