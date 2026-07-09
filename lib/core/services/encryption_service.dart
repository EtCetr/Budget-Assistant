import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:budget_assistant/core/logger.dart';
import 'secure_storage_service.dart';
import '../exceptions/security_exceptions.dart';

/// Сервис сквозного шифрования (E2E) AES-256-GCM.
/// Обеспечивает конфиденциальность и проверку целостности (Auth Tag).
class EncryptionService {
  final SecureStorageService _secureStorage;
  final Random _random = Random.secure();

  EncryptionService({required SecureStorageService secureStorage})
    : _secureStorage = secureStorage;

  Future<Uint8List> _getKey(String spaceId) async {
    final keyString = await _secureStorage.read('enc_key_$spaceId');
    if (keyString == null) {
      throw MissingEncryptionKeyException(spaceId);
    }
    return base64Decode(keyString);
  }

  Uint8List _generateIv() {
    // GCM рекомендует 12 байт (96 бит) для IV
    return Uint8List.fromList(List.generate(12, (_) => _random.nextInt(256)));
  }

  Uint8List _encryptAesGcm(Uint8List key, Uint8List iv, Uint8List plaintext) {
    try {
      final cipher = GCMBlockCipher(AESEngine());
      // 128 бит = 16 байт Auth Tag
      final params = AEADParameters(KeyParameter(key), 128, iv, Uint8List(0));
      cipher.init(true, params);
      return cipher.process(plaintext);
    } catch (e, s) {
      AppLogger.e('AES-GCM Encryption failed', e, s);
      throw EncryptionException('AES-GCM Encryption failed', e);
    }
  }

  Uint8List _decryptAesGcm(
    Uint8List key,
    Uint8List iv,
    Uint8List ciphertextWithTag,
  ) {
    try {
      final cipher = GCMBlockCipher(AESEngine());
      final params = AEADParameters(KeyParameter(key), 128, iv, Uint8List(0));
      cipher.init(false, params);
      return cipher.process(ciphertextWithTag);
    } catch (e, s) {
      AppLogger.e('AES-GCM Decryption failed', e, s);
      throw DecryptionException('AES-GCM Decryption failed or invalid tag', e);
    }
  }

  Future<String> encryptString(String plaintext, String spaceId) async {
    try {
      final key = await _getKey(spaceId);
      final iv = _generateIv();
      final plaintextBytes = utf8.encode(plaintext);
      final ciphertextWithTag = _encryptAesGcm(
        key,
        iv,
        Uint8List.fromList(plaintextBytes),
      );

      // Формат payload: IV (12 bytes) + Ciphertext + Tag (16 bytes)
      final payload = Uint8List(iv.length + ciphertextWithTag.length);
      payload.setAll(0, iv);
      payload.setAll(iv.length, ciphertextWithTag);

      return base64Encode(payload);
    } catch (e) {
      if (e is SecurityException) rethrow;
      throw EncryptionException('Failed to encrypt string', e);
    }
  }

  Future<String> decryptString(String payloadBase64, String spaceId) async {
    try {
      final key = await _getKey(spaceId);
      final payload = base64Decode(payloadBase64);

      if (payload.length < 28) {
        // Минимум: 12 (IV) + 16 (Tag)
        throw DecryptionException('Invalid payload length');
      }

      final iv = payload.sublist(0, 12);
      final ciphertextWithTag = payload.sublist(12);

      final plaintextBytes = _decryptAesGcm(key, iv, ciphertextWithTag);
      return utf8.decode(plaintextBytes);
    } catch (e) {
      if (e is SecurityException) rethrow;
      throw DecryptionException('Failed to decrypt string', e);
    }
  }

  Future<String> encryptInt(int value, String spaceId) async {
    try {
      final key = await _getKey(spaceId);
      final iv = _generateIv();
      // Конвертируем Int64 (копейки) в 8 байт Big Endian
      final bytes = ByteData(8)..setInt64(0, value, Endian.big);
      final ciphertextWithTag = _encryptAesGcm(
        key,
        iv,
        bytes.buffer.asUint8List(),
      );

      final payload = Uint8List(iv.length + ciphertextWithTag.length);
      payload.setAll(0, iv);
      payload.setAll(iv.length, ciphertextWithTag);

      return base64Encode(payload);
    } catch (e) {
      if (e is SecurityException) rethrow;
      throw EncryptionException('Failed to encrypt int', e);
    }
  }

  Future<int> decryptInt(String payloadBase64, String spaceId) async {
    try {
      final key = await _getKey(spaceId);
      final payload = base64Decode(payloadBase64);

      if (payload.length < 28) {
        throw DecryptionException('Invalid payload length for int');
      }

      final iv = payload.sublist(0, 12);
      final ciphertextWithTag = payload.sublist(12);

      final plaintextBytes = _decryptAesGcm(key, iv, ciphertextWithTag);
      final byteData = ByteData.sublistView(plaintextBytes);
      return byteData.getInt64(0, Endian.big);
    } catch (e) {
      if (e is SecurityException) rethrow;
      throw DecryptionException('Failed to decrypt int', e);
    }
  }
}
