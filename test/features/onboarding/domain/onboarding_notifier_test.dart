import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/features/onboarding/domain/enums/onboarding_step.dart';
import 'package:budget_assistant/features/onboarding/domain/notifiers/onboarding_notifier.dart';
import 'package:budget_assistant/features/onboarding/domain/state/onboarding_state.dart';

/// Этап 24: онбординг (D18-14). Шаг создания счёта удалён,
/// вместо него — данные для детекции переводов.
///
/// ВАЖНО: riverpod_generator 4.x отбрасывает суффикс Notifier —
/// сгенерированный провайдер называется onboardingProvider.
void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  OnboardingNotifier notifier() =>
      container.read(onboardingProvider.notifier);

  OnboardingState state() => container.read(onboardingProvider);

  test('начальное состояние: welcome, валюта не выбрана', () {
    expect(state().currentStep, OnboardingStep.welcome);
    expect(state().baseCurrency, isNull);
    expect(state().initialBalanceKopecks, isNull);
  });

  test('шаги идут по порядку до completed', () {
    final expected = [
      OnboardingStep.baseCurrency,
      OnboardingStep.securitySetup,
      OnboardingStep.spaceDecision,
      OnboardingStep.transferProfile,
      OnboardingStep.completed,
    ];

    for (final step in expected) {
      notifier().goToNextStep();
      expect(state().currentStep, step);
    }
  });

  test('после completed дальнейшие шаги не меняют состояние', () {
    for (var i = 0; i < 8; i++) {
      notifier().goToNextStep();
    }

    expect(state().currentStep, OnboardingStep.completed);
  });

  test('базовая валюта сохраняется', () {
    notifier().setBaseCurrency('USD');

    expect(state().baseCurrency, 'USD');
    expect(state().currentStep, OnboardingStep.welcome);
  });

  test('completeOnboarding завершает с любого шага', () {
    notifier().goToNextStep();
    notifier().completeOnboarding();

    expect(state().currentStep, OnboardingStep.completed);
  });

  test('в порядке шагов нет создания счёта (D18-14)', () {
    expect(
      OnboardingStep.values.map((e) => e.name),
      isNot(contains('firstAccount')),
    );
    expect(OnboardingStep.values, contains(OnboardingStep.transferProfile));
  });
}