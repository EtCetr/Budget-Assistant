import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/features/security/domain/usecases/calculate_security_level_usecase.dart';

/// Этап 24: уровень защиты 0–100% (ТЗ 6.3.28.3).
/// Быстрое скрытие 30 + защита данных 20 + аутентификация 40 + секретность 10.
void main() {
  const useCase = CalculateSecurityLevelUseCase();

  int score({
    bool shake = false,
    bool faceDown = false,
    int timeout = 0,
    bool capture = false,
    bool pin = false,
    bool biometric = false,
    bool biometricAvailable = false,
    bool secrecy = false,
  }) =>
      useCase(
        enableShakeToHide: shake,
        enableFaceDownHide: faceDown,
        autoHideTimeoutSeconds: timeout,
        enableScreenCaptureProtection: capture,
        enablePinCode: pin,
        enableBiometricLogin: biometric,
        biometricAvailable: biometricAvailable,
        enableSecrecyMode: secrecy,
      );

  test('всё выключено — 0', () {
    expect(score(), 0);
  });

  test('всё включено — 100', () {
    expect(
      score(
        shake: true,
        faceDown: true,
        timeout: 30,
        capture: true,
        pin: true,
        biometric: true,
        biometricAvailable: true,
        secrecy: true,
      ),
      100,
    );
  });

  test('быстрое скрытие даёт максимум 30', () {
    expect(score(shake: true), 10);
    expect(score(shake: true, faceDown: true), 20);
    expect(score(shake: true, faceDown: true, timeout: 60), 30);
  });

  test('таймаут 0 не добавляет баллов', () {
    expect(score(timeout: 0), 0);
    expect(score(timeout: 10), 10);
  });

  test('защита от скриншотов даёт 20', () {
    expect(score(capture: true), 20);
  });

  test('PIN даёт 25', () {
    expect(score(pin: true), 25);
  });

  test('биометрия даёт 15 только при доступности на устройстве', () {
    expect(score(biometric: true), 0);
    expect(score(biometric: true, biometricAvailable: true), 15);
    expect(score(biometricAvailable: true), 0);
  });

  test('режим секретности даёт 10', () {
    expect(score(secrecy: true), 10);
  });

  test('сумма групп не превышает 100', () {
    final total = score(
      shake: true,
      faceDown: true,
      timeout: 300,
      capture: true,
      pin: true,
      biometric: true,
      biometricAvailable: true,
      secrecy: true,
    );
    expect(total, lessThanOrEqualTo(100));
  });

  group('title', () {
    test('границы уровней', () {
      expect(useCase.title(0), 'Низкий');
      expect(useCase.title(30), 'Низкий');
      expect(useCase.title(31), 'Средний');
      expect(useCase.title(70), 'Средний');
      expect(useCase.title(71), 'Высокий');
      expect(useCase.title(90), 'Высокий');
      expect(useCase.title(91), 'Максимальный');
      expect(useCase.title(100), 'Максимальный');
    });
  });
}