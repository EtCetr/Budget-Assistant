import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import '../exceptions/security_exceptions.dart';

/// Утилита для деривации ключей по стандарту HKDF (RFC 5869).
class HkdfUtils {
  /// HMAC-based Extract
  static Uint8List extract(Uint8List salt, Uint8List ikm) {
    try {
      // RFC 5869 Section 2.2: если salt пустой, заменяем на HashLen нулей
      final effectiveSalt = salt.isEmpty ? Uint8List(32) : salt;

      final hmac = Hmac(sha256, effectiveSalt);
      return Uint8List.fromList(hmac.convert(ikm).bytes);
    } catch (e) {
      throw SecurityException('HKDF Extract failed', e);
    }
  }

  /// HMAC-based Expand
  static Uint8List expand(Uint8List prk, Uint8List info, int length) {
    try {
      const hashLen = 32; // SHA-256 output length

      // RFC 5869 Section 2.3: L <= 255 * HashLen
      if (length < 0 || length > 255 * hashLen) {
        throw SecurityException(
          'HKDF Expand: length must be 0..8160, got $length',
        );
      }

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
