import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/logger.dart';

abstract class PinCodeRepository {
  Future<void> savePin(String pin);
  Future<bool> verifyPin(String pin);
  Future<bool> isPinSet();
  Future<void> clearPin();
}

class PinCodeRepositoryImpl implements PinCodeRepository {
  static const _pinHashKey = 'pin_hash';
  static const _pinSaltKey = 'pin_salt';
  
  final FlutterSecureStorage _secureStorage;

  PinCodeRepositoryImpl(this._secureStorage);

  @override
  Future<void> savePin(String pin) async {
    try {
      // 1. Генерируем случайную соль (16 байт)
      final random = Random.secure();
      final salt = Uint8List.fromList(
        List.generate(16, (_) => random.nextInt(256)),
      );
      
      // 2. Вычисляем SHA-256 хэш (PIN + соль)
      final pinBytes = utf8.encode(pin);
      final combined = Uint8List.fromList(pinBytes + salt);
      final hash = sha256.convert(combined).toString();
      
      // 3. Сохраняем в SecureStorage
      await _secureStorage.write(
        key: _pinHashKey,
        value: hash,
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );
      await _secureStorage.write(
        key: _pinSaltKey,
        value: base64Encode(salt),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );
      
      AppLogger.i('PIN saved successfully');
    } catch (e, st) {
      AppLogger.e('Failed to save PIN', e, st);
      throw Failure.encryption('Failed to save PIN: $e', st);
    }
  }

  @override
  Future<bool> verifyPin(String pin) async {
    try {
      final storedHash = await _secureStorage.read(key: _pinHashKey);
      final storedSaltBase64 = await _secureStorage.read(key: _pinSaltKey);
      
      if (storedHash == null || storedSaltBase64 == null) {
        return false; // PIN не установлен
      }
      
      // Восстанавливаем соль
      final salt = base64Decode(storedSaltBase64);
      
      // Вычисляем хэш введённого PIN
      final pinBytes = utf8.encode(pin);
      final combined = Uint8List.fromList(pinBytes + salt);
      final hash = sha256.convert(combined).toString();
      
      return hash == storedHash;
    } catch (e, st) {
      AppLogger.e('Failed to verify PIN', e, st);
      throw Failure.encryption('Failed to verify PIN: $e', st);
    }
  }

  @override
  Future<bool> isPinSet() async {
    try {
      final hash = await _secureStorage.read(key: _pinHashKey);
      return hash != null;
    } catch (e, st) {
      AppLogger.e('Failed to check PIN status', e, st);
      throw Failure.encryption('Failed to check PIN status: $e', st);
    }
  }

  @override
  Future<void> clearPin() async {
    try {
      await _secureStorage.delete(key: _pinHashKey);
      await _secureStorage.delete(key: _pinSaltKey);
      AppLogger.i('PIN cleared');
    } catch (e, st) {
      AppLogger.e('Failed to clear PIN', e, st);
      throw Failure.encryption('Failed to clear PIN: $e', st);
    }
  }
}