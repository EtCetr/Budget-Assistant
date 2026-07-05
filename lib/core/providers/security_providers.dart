import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/secure_storage_service.dart';
import '../services/encryption_service.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

// Заглушка для активного пространства.
// Будет обновлена в Фазе 1 (Этап 3) при реализации Multi-Group.
final currentSpaceIdProvider = StateProvider<String?>((ref) => null);

final encryptionServiceProvider = Provider<EncryptionService>((ref) {
  final secureStorage = ref.watch(secureStorageServiceProvider);
  return EncryptionService(secureStorage: secureStorage);
});
