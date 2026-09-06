// lib/features/security/data/repositories/pin_code_repository.dart
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/services/secure_storage_service.dart';
import 'package:budget_assistant/core/utils/result.dart';

abstract class PinCodeRepository {
  Future<Result<void>> savePin(String pin);
  Future<Result<bool>> verifyPin(String pin);
  Future<Result<bool>> hasPin();
}

class PinCodeRepositoryImpl implements PinCodeRepository {
  final SecureStorageService _secureStorage;
  static const String _pinKey = 'pin_code_hash';
  static const String _pinSaltKey = 'pin_code_salt';

  PinCodeRepositoryImpl(this._secureStorage);

  @override
  Future<Result<void>> savePin(String pin) async {
    try {
      final salt = DateTime.now().millisecondsSinceEpoch.toString();
      final hash = sha256.convert(utf8.encode(pin + salt)).toString();

      // ✅ ПОЗИЦИОННЫЕ аргументы — как требует ваш SecureStorageService
      await _secureStorage.write(_pinKey, hash);
      await _secureStorage.write(_pinSaltKey, salt);

      AppLogger.i('PIN saved successfully');
      return Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to save PIN', e, stackTrace);
      return Result.failure(
        Failure.unexpected('Failed to save PIN: $e', stackTrace),
      );
    }
  }

  @override
  Future<Result<bool>> verifyPin(String pin) async {
    try {
      final savedHash = await _secureStorage.read(_pinKey);
      final savedSalt = await _secureStorage.read(_pinSaltKey);

      if (savedHash == null || savedSalt == null) {
        return Result.success(false);
      }

      final hash = sha256.convert(utf8.encode(pin + savedSalt)).toString();
      return Result.success(hash == savedHash);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to verify PIN', e, stackTrace);
      return Result.failure(
        Failure.unexpected('Failed to verify PIN: $e', stackTrace),
      );
    }
  }

  @override
  Future<Result<bool>> hasPin() async {
    try {
      final hash = await _secureStorage.read(_pinKey);
      return Result.success(hash != null && hash.isNotEmpty);
    } catch (e, stackTrace) {
      AppLogger.e('Failed to check PIN existence', e, stackTrace);
      return Result.failure(
        Failure.unexpected('Failed to check PIN: $e', stackTrace),
      );
    }
  }
}
