// lib/core/router/routes.dart
// Константы для маршрутов

class AppRoutes {
  static const String home = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String spaceSelector = '/space-selector';
  static const String lock = '/lock';
  static const String invite = '/invite';
  static const String join = '/join'; // Для Deep Link

  // Подпути для онбординга (может быть реализовано иначе, например, через индекс шага)
  static const String onboardingWelcome = '$onboarding/welcome';
  static const String onboardingCurrency = '$onboarding/currency';
  static const String onboardingSecurity = '$onboarding/security';
  static const String onboardingSpace = '$onboarding/space';
  static const String onboardingAccount = '$onboarding/account';

  // Подпути для auth (например, /auth/sign-in, /auth/sign-up)
  // static const String authSignIn = '$auth/sign-in';
  // static const String authSignUp = '$auth/sign-up';
}
