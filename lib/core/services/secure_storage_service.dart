import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import '../exceptions/security_exceptions.dart';

/// Сервис-обёртка над flutter_secure_storage.
/// Гарантирует, что все ошибки работы с Android Keystore перехватываются и логируются.
class SecureStorageService {
  final FlutterSecureStorage _storage;
  final Logger _logger;

  SecureStorageService({
    FlutterSecureStorage? storage,
    Logger? logger,
  })  : _storage = storage ?? const FlutterSecureStorage(),
        _logger = logger ?? Logger();

  Future<String?> read(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e, s) {
      _logger.e('SecureStorage read error for key: $key',
          error: e, stackTrace: s);
      throw SecurityException('Failed to read from SecureStorage', e);
    }
  }

  Future<void> write(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e, s) {
      _logger.e('SecureStorage write error for key: $key',
          error: e, stackTrace: s);
      throw SecurityException('Failed to write to SecureStorage', e);
    }
  }

  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e, s) {
      _logger.e('SecureStorage delete error for key: $key',
          error: e, stackTrace: s);
      throw SecurityException('Failed to delete from SecureStorage', e);
    }
  }

  Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e, s) {
      _logger.e('SecureStorage containsKey error for key: $key',
          error: e, stackTrace: s);
      return false;
    }
  }
}
