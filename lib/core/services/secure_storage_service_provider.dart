import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'secure_storage_service.dart';

part 'secure_storage_service_provider.g.dart';

@Riverpod(keepAlive: true)
SecureStorageService secureStorageService(Ref ref) {
  return SecureStorageService();
}
