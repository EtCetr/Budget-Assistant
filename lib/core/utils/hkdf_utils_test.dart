import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/utils/hkdf_utils.dart';

Uint8List _hexToBytes(String hex) {
  final bytes = <int>[];
  for (int i = 0; i < hex.length; i += 2) {
    bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
  }
  return Uint8List.fromList(bytes);
}

void main() {
  group('HkdfUtils', () {
    test('should derive key correctly (RFC 5869 Test Vector 1)', () {
      final ikm = _hexToBytes('0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b');
      final salt = _hexToBytes('000102030405060708090a0b0c');
      final info = _hexToBytes('f0f1f2f3f4f5f6f7f8f9');
      const length = 42;

      final expectedOkm = _hexToBytes(
          '3cb25f25faacd57a90434f64d0362f2a2d2d0a90cf1a5a4c5db02d56ecc4c5bf34007208d5b887185865');

      final okm = HkdfUtils.deriveKey(
        ikm: ikm,
        salt: salt,
        info: info,
        length: length,
      );

      expect(okm, equals(expectedOkm));
    });
  });
}
