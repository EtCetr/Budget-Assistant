import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:budget_assistant/core/logger.dart';
import '../exceptions/security_exceptions.dart';

/// Сервис-обёртка над flutter_secure_storage.
/// Гарантирует, что все ошибки работы с Android Keystore перехватываются и логируются.
class SecureStorageService {
  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
    : _storage =
          storage ??
          const FlutterSecureStorage(
            aOptions: AndroidOptions(encryptedSharedPreferences: true),
          );

  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } on PlatformException catch (e) {
      // Android Keystore: ключ инвалидирован (новый отпечаток/PIN)
      if (e.code == '-4' || e.code.contains('KeyPermanentlyInvalidated')) {
        AppLogger.w('Key permanently invalidated for $key: ${e.message}');
        await _storage.delete(key: key);
        throw KeyInvalidatedException(key);
      }
      AppLogger.e('SecureStorage read error: $key - ${e.message}');
      throw SecurityException('Failed to read from SecureStorage', e);
    } catch (e) {
      AppLogger.e('SecureStorage read error: $key - $e');
      throw SecurityException('Failed to read from SecureStorage', e);
    }
  }

  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      AppLogger.e('SecureStorage write error: $key - $e');
      throw SecurityException('Failed to write to SecureStorage', e);
    }
  }

  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      AppLogger.e('SecureStorage delete error: $key - $e');
      throw SecurityException('Failed to delete from SecureStorage', e);
    }
  }

  Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e) {
      AppLogger.e('SecureStorage containsKey error: $key - $e');
      return false;
    }
  }
}
