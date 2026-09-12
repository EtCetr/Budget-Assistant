import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:pointycastle/export.dart';

/// AES-256-GCM cipher for E2E payload encryption.
///
/// Output format:
/// base64(iv).base64(ciphertext+tag)
///
/// Key must be 32 bytes.
class AesGcmCipher {
  static const int _ivLength = 12;
  static const int _macBits = 128;

  String encrypt({
    required String plaintext,
    required Uint8List key,
    String? aad,
  }) {
    _validateKey(key);

    final iv = _randomBytes(_ivLength);
    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        true,
        AEADParameters(
          KeyParameter(key),
          _macBits,
          iv,
          Uint8List.fromList(utf8.encode(aad ?? '')),
        ),
      );

    final input = Uint8List.fromList(utf8.encode(plaintext));
    final output = cipher.process(input);

    return '${base64Encode(iv)}.${base64Encode(output)}';
  }

  String decrypt({
    required String payload,
    required Uint8List key,
    String? aad,
  }) {
    _validateKey(key);

    final parts = payload.split('.');
    if (parts.length != 2) {
      throw const FormatException('Invalid AES-GCM payload format');
    }

    final iv = base64Decode(parts[0]);
    final data = base64Decode(parts[1]);

    final cipher = GCMBlockCipher(AESEngine())
      ..init(
        false,
        AEADParameters(
          KeyParameter(key),
          _macBits,
          iv,
          Uint8List.fromList(utf8.encode(aad ?? '')),
        ),
      );

    final output = cipher.process(data);
    return utf8.decode(output);
  }

  void _validateKey(Uint8List key) {
    if (key.length != 32) {
      throw ArgumentError.value(
        key.length,
        'key',
        'AES-256-GCM requires a 32-byte key',
      );
    }
  }

  Uint8List _randomBytes(int length) {
    final rnd = Random.secure();
    return Uint8List.fromList(List.generate(length, (_) => rnd.nextInt(256)));
  }
}
