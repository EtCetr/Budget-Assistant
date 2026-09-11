/// Кэш флагов, загруженных в main() ДО runApp.
/// Riverpod-провайдеры не могут await в build(),
/// поэтому SecureStorage читаем заранее.
class AppBootstrapFlags {
  AppBootstrapFlags._();

  /// 'not_started' | 'completed'
  static String onboardingStatus = 'not_started';
}
