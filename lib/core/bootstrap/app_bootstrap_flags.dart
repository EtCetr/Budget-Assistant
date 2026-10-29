/// Кэш флагов, загруженных в main() ДО runApp.
/// Riverpod-провайдеры не могут await в build(),
/// поэтому SecureStorage читаем заранее.
class AppBootstrapFlags {
  /// Маршрут из тапа по пушу (pending_deep_link, ТОМ 5 §3.2.2.c).
  static String? pendingDeepLink;
  AppBootstrapFlags._();

  /// 'not_started' | 'completed'
  static String onboardingStatus = 'not_started';
}
