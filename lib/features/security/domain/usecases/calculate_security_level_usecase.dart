// lib/features/security/domain/usecases/calculate_security_level_usecase.dart
// Этап 21 (ТЗ 6.3.28.3): расчёт уровня защиты 0-100%.
class CalculateSecurityLevelUseCase {
  const CalculateSecurityLevelUseCase();

  int call({
    required bool enableShakeToHide,
    required bool enableFaceDownHide,
    required int autoHideTimeoutSeconds,
    required bool enableScreenCaptureProtection,
    required bool enablePinCode,
    required bool enableBiometricLogin,
    required bool biometricAvailable,
    required bool enableSecrecyMode,
  }) {
    var score = 0;
    // Быстрое скрытие (макс 30%).
    if (enableShakeToHide) score += 10;
    if (enableFaceDownHide) score += 10;
    if (autoHideTimeoutSeconds > 0) score += 10;
    // Защита данных (макс 20%).
    if (enableScreenCaptureProtection) score += 20;
    // Аутентификация (макс 40%).
    if (enablePinCode) score += 25;
    if (enableBiometricLogin && biometricAvailable) score += 15;
    // Режим секретности (макс 10%).
    if (enableSecrecyMode) score += 10;
    return score.clamp(0, 100);
  }

  /// Текстовый уровень для баннера (без цвета — цвет решает UI).
  String title(int score) {
    if (score <= 30) return 'Низкий';
    if (score <= 70) return 'Средний';
    if (score <= 90) return 'Высокий';
    return 'Максимальный';
  }
}