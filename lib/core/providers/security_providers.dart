import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/secure_storage_service.dart';
import '../services/encryption_service.dart';

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

// ИСПРАВЛЕНО: StateProvider удален в Riverpod 3.x.
// Используем NotifierProvider для управления состоянием без code generation.
class CurrentSpaceIdNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? spaceId) {
    state = spaceId;
  }
}

final currentSpaceIdProvider =
    NotifierProvider<CurrentSpaceIdNotifier, String?>(
      CurrentSpaceIdNotifier.new,
    );

final encryptionServiceProvider = Provider<EncryptionService>((ref) {
  final secureStorage = ref.watch(secureStorageServiceProvider);
  return EncryptionService(secureStorage: secureStorage);
});
