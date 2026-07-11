import 'package:local_auth/local_auth.dart';
import 'package:budget_assistant/core/logger.dart';

class BiometricService {
  static final _localAuth = LocalAuthentication();

  static Future<bool> isAvailable() async {
    try {
      final canCheck = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return canCheck && isDeviceSupported;
    } catch (e, st) {
      AppLogger.e('Biometric availability check failed', e, st);
      return false;
    }
  }

  static Future<bool> authenticate({required String reason}) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false, // Разрешаем PIN как fallback
        ),
      );
    } catch (e, st) {
      AppLogger.e('Biometric authentication failed', e, st);
      return false;
    }
  }
}
