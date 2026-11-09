// lib/features/security/domain/usecases/export_encryption_keys_usecase.dart
// Этап 21 (ТЗ 6.3.28.17): экспорт ключей шифрования в зашифрованном виде.
// D21-35: полный снапшот SecureStorage (readAll) — надмножество списка спеки,
// надёжнее для восстановления. Файл .enc = JSON{version, salt, data(AES-GCM)}.
// Ключ файла: SHA-256(password + salt) -> 32 байта.
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:budget_assistant/core/crypto/aes_gcm_cipher.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/services/secure_storage_service.dart';

class ExportEncryptionKeysUseCase {
  const ExportEncryptionKeysUseCase({required SecureStorageService storage})
      : _storage = storage;

  final SecureStorageService _storage;

  Future<String> call(String password) async {
    try {
      final all = await _storage.readAll();
      final rnd = Random.secure();
      final saltBytes =
          Uint8List.fromList(List.generate(16, (_) => rnd.nextInt(256)));
      final saltB64 = base64Encode(saltBytes);
      final key = Uint8List.fromList(
        sha256.convert(utf8.encode(password + saltB64)).bytes,
      );
      final payload = AesGcmCipher().encrypt(
        plaintext: jsonEncode(all),
        key: key,
      );
      final out = jsonEncode({
        'version': 1,
        'exported_at': DateTime.now().toUtc().toIso8601String(),
        'kdf': 'sha256(password+salt)',
        'salt': saltB64,
        'data': payload,
      });
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/budget_assistant_keys_${DateTime.now().millisecondsSinceEpoch}.enc';
      await File(path).writeAsString(out);
      AppLogger.i('Encryption keys exported: $path (${all.length} keys)');
      return path;
    } catch (e, st) {
      AppLogger.e('ExportEncryptionKeys failed', e, st);
      rethrow;
    }
  }
}