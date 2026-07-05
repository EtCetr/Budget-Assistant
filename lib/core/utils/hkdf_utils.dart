import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import '../exceptions/security_exceptions.dart';

/// Утилита для деривации ключей по стандарту HKDF (RFC 5869).
/// Используется для безопасной передачи мастер-ключа пространства через invite_token.
class HkdfUtils {
  /// HMAC-based Extract
  static Uint8List extract(Uint8List salt, Uint8List ikm) {
    try {
      final hmac = Hmac(sha256, salt);
      return Uint8List.fromList(hmac.convert(ikm).bytes);
    } catch (e) {
      throw SecurityException('HKDF Extract failed', e);
    }
  }

  /// HMAC-based Expand
  static Uint8List expand(Uint8List prk, Uint8List info, int length) {
    try {
      final hashLen = 32; // SHA-256 output length
      final n = (length + hashLen - 1) ~/ hashLen;
      var okm = <int>[];
      var t = Uint8List(0);

      for (int i = 1; i <= n; i++) {
        final hmac = Hmac(sha256, prk);
        final input = <int>[...t, ...info, i];
        t = Uint8List.fromList(hmac.convert(input).bytes);
        okm.addAll(t);
      }
      return Uint8List.fromList(okm.sublist(0, length));
    } catch (e) {
      throw SecurityException('HKDF Expand failed', e);
    }
  }

  /// Полный цикл деривации ключа
  static Uint8List deriveKey({
    required Uint8List ikm,
    required Uint8List salt,
    required Uint8List info,
    required int length,
  }) {
    final prk = extract(salt, ikm);
    return expand(prk, info, length);
  }
}
