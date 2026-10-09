import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/services/secure_storage_service.dart';
import 'package:budget_assistant/core/utils/hkdf_utils.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';

/// Криптография инвайтов: HKDF (через существующий HkdfUtils) + AES-256-GCM
/// (pointycastle, как в EncryptionService, но с произвольным ключом — не по spaceId).
class InviteCryptoService {
  InviteCryptoService({SecureStorageService? storage})
      : _storage = storage ?? SecureStorageService();

  final SecureStorageService _storage;
  static const String _info = 'ba-invite-v1';
  final Random _random = Random.secure();

  /// Читает мастер-ключ пространства из SecureStorage, шифрует его HKDF-ключом
  /// из случайного IKM-токена. Возвращает (token-base64, encryptedSalt-base64).
  Future<({String token, String encryptedSalt})> packSpaceSalt({required String spaceId}) async {
    try {
      final salt = await _ensureSpaceKey(spaceId);
      final ikm = _randomBytes(32);
      final key = HkdfUtils.deriveKey(
        ikm: ikm,
        salt: Uint8List.fromList(utf8.encode(spaceId)),
        info: Uint8List.fromList(utf8.encode(_info)),
        length: 32,
      );
      final encrypted = _aesGcmEncrypt(key, utf8.encode(salt));
      return (token: base64Url.encode(ikm), encryptedSalt: base64.encode(encrypted));
    } catch (e, st) {
      AppLogger.e('packSpaceSalt failed', e, st);
      rethrow;
    }
  }

  Future<String> unpackSpaceSalt(InviteBundle bundle) async {
    try {
      final key = HkdfUtils.deriveKey(
        ikm: base64Url.decode(base64Url.normalize(bundle.t)),
        salt: Uint8List.fromList(utf8.encode(bundle.s)),
        info: Uint8List.fromList(utf8.encode(_info)),
        length: 32,
      );
      final payload = base64.decode(bundle.e);
      final plaintext = _aesGcmDecrypt(key, payload);
      return utf8.decode(plaintext);
    } catch (e, st) {
      AppLogger.e('unpackSpaceSalt failed', e, st);
      throw const AdminFailure('Не удалось расшифровать ключ пространства');
    }
  }

  Future<void> writeSpaceKey(String spaceId, String saltBase64) async {
    try {
      await _storage.write('enc_key_$spaceId', saltBase64);
    } catch (e, st) {
      AppLogger.e('writeSpaceKey failed', e, st);
      rethrow;
    }
  }

  /// Repair (D17-13): пространства Этапа 3 не писали enc_key_{spaceId}.
  /// Нет ключа -> генерируем 32 байта и пишем в формат ТОМ 3 §2.1.
  Future<String> _ensureSpaceKey(String spaceId) async {
    final existing = await _storage.read('enc_key_$spaceId');
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    final key = base64.encode(_randomBytes(32));
    await _storage.write('enc_key_$spaceId', key);
    AppLogger.w('Space master key repaired (generated) for $spaceId');
    return key;
  }

  Uint8List _randomBytes(int len) =>
      Uint8List.fromList(List<int>.generate(len, (_) => _random.nextInt(256)));

  Uint8List _aesGcmEncrypt(Uint8List key, Uint8List plaintext) {
    final iv = Uint8List.fromList(List<int>.generate(12, (_) => _random.nextInt(256)));
    final cipher = GCMBlockCipher(AESEngine());
    cipher.init(true, AEADParameters(KeyParameter(key), 128, iv, Uint8List(0)));
    final ct = cipher.process(plaintext);
    final out = Uint8List(iv.length + ct.length);
    out.setAll(0, iv);
    out.setAll(iv.length, ct);
    return out;
  }

  Uint8List _aesGcmDecrypt(Uint8List key, Uint8List payload) {
    if (payload.length < 28) {
      throw const AdminFailure('Некорректный payload шифр-соли');
    }
    final iv = payload.sublist(0, 12);
    final ct = payload.sublist(12);
    final cipher = GCMBlockCipher(AESEngine());
    cipher.init(false, AEADParameters(KeyParameter(key), 128, iv, Uint8List(0)));
    return cipher.process(ct);
  }
}