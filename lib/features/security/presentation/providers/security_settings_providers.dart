// lib/features/security/presentation/providers/security_settings_providers.dart
// Этап 21 (ТЗ 6.3.28): провайдеры экрана безопасности.
import 'package:drift/drift.dart' show Variable;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/core/services/secure_storage_service.dart';
import 'package:budget_assistant/features/security/data/repositories/pin_code_repository.dart';
import 'package:budget_assistant/features/security/domain/usecases/calculate_security_level_usecase.dart';
import 'package:budget_assistant/features/security/services/biometric_service.dart';
import 'package:budget_assistant/features/security/domain/usecases/export_encryption_keys_usecase.dart';
import 'package:budget_assistant/features/settings/presentation/providers/settings_providers.dart';

final pinCodeRepositoryProvider = Provider<PinCodeRepository>(
  (ref) => PinCodeRepositoryImpl(SecureStorageService()),
);

/// Доступность биометрии на устройстве (асинхронно, LocalAuthentication).
final biometricAvailableProvider = FutureProvider<bool>(
  (ref) => BiometricService.isAvailable(),
);

/// Есть ли сохранённый хэш PIN в SecureStorage.
final pinCodeStoredProvider = FutureProvider<bool>((ref) async {
  final repo = ref.watch(pinCodeRepositoryProvider);
  final result = await repo.hasPin();
  return result.when(
    success: (hasPin) => hasPin,
    failure: (_) => false,
  );
});

/// Уровень защиты 0-100 (ТЗ 6.3.28.3).
final securityLevelProvider = Provider<int>((ref) {
  final s = ref.watch(appSettingsRowProvider).value;
  if (s == null) return 0;
  final bio = ref.watch(biometricAvailableProvider).value ?? false;
  return const CalculateSecurityLevelUseCase().call(
    enableShakeToHide: s.enableShakeToHide,
    enableFaceDownHide: s.enableFaceDownHide,
    autoHideTimeoutSeconds: s.autoHideTimeoutSeconds,
    enableScreenCaptureProtection: s.enableScreenCaptureProtection,
    enablePinCode: s.enablePinCode,
    enableBiometricLogin: s.enableBiometricLogin,
    biometricAvailable: bio,
    enableSecrecyMode: s.enableSecrecyMode,
  );
});

/// Рекомендация под прогресс-баром.
final securityRecommendationProvider = Provider<String>((ref) {
  final s = ref.watch(appSettingsRowProvider).value;
  if (s == null) return '';
  final level = ref.watch(securityLevelProvider);
  if (level >= 100) return '🎉 Максимальная защита активна';
  if (!s.enablePinCode) return '💡 Включите PIN-код для максимальной защиты';
  final bio = ref.watch(biometricAvailableProvider).value ?? false;
  if (bio && !s.enableBiometricLogin) {
    return '💡 Включите биометрию для быстрого входа';
  }
  if (!s.enableScreenCaptureProtection) {
    return '💡 Включите защиту от скриншотов';
  }
  if (!s.enableSecrecyMode) {
    return '💡 Включите режим секретности для подарков';
  }
  return '💡 Включите встряхивание и автоматическое скрытие';
});

/// Количество секретных транзакций (бейдж кнопки проверки).
final secretTransactionsCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.customSelect(
    'SELECT COUNT(*) AS c FROM transactions WHERE is_hidden_by_calendar = 1',
    readsFrom: {db.transactions},
  ).watch().map((rows) => rows.first.read<int>('c'));
});

/// Праздники в ближайшие 30 дней (бейдж кнопки управления праздниками).
final upcomingHolidaysCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final now = DateTime.now().toUtc();
  final end = now.add(const Duration(days: 30));
  return db.customSelect(
    'SELECT COUNT(*) AS c FROM holidays WHERE date >= ? AND date <= ?',
    variables: [
      Variable.withInt(now.millisecondsSinceEpoch ~/ 1000),
      Variable.withInt(end.millisecondsSinceEpoch ~/ 1000),
    ],
    readsFrom: {db.holidays},
  ).watch().map((rows) => rows.first.read<int>('c'));
});

/// Экспорт ключей шифрования (ТЗ 6.3.28.17, D21-35).
final exportEncryptionKeysUseCaseProvider =
    Provider<ExportEncryptionKeysUseCase>(
  (ref) => ExportEncryptionKeysUseCase(storage: SecureStorageService()),
);