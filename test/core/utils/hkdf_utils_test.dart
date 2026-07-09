import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/utils/hkdf_utils.dart';

/// Утилита для конвертации HEX-строк из RFC 5869 в байты
Uint8List _hexToBytes(String hex) {
  final bytes = <int>[];
  for (int i = 0; i < hex.length; i += 2) {
    bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
  }
  return Uint8List.fromList(bytes);
}

void main() {
  group('HkdfUtils', () {
    test('RFC 5869 Test Vector 1 - базовая деривация', () {
      final ikm = _hexToBytes('0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b');
      final salt = _hexToBytes('000102030405060708090a0b0c');
      final info = _hexToBytes('f0f1f2f3f4f5f6f7f8f9');
      const length = 42;

      // Ожидаемый OKM из RFC 5869
      final expectedOkm = _hexToBytes(
        '3cb25f25faacd57a90434f64d0362f2a'
        '2d2d0a90cf1a5a4c5db02d56ecc4c5bf'
        '34007208d5b887185865',
      );

      final okm = HkdfUtils.deriveKey(
        ikm: ikm,
        salt: salt,
        info: info,
        length: length,
      );

      expect(okm, equals(expectedOkm));
    });

    test('RFC 5869 Test Vector 2 - более длинный IKM', () {
      final ikm = _hexToBytes(
        '000102030405060708090a0b0c0d0e0f'
        '101112131415161718191a1b1c1d1e1f'
        '202122232425262728292a2b2c2d2e2f'
        '303132333435363738393a3b3c3d3e3f'
        '404142434445464748494a4b4c4d4e4f',
      );
      final salt = _hexToBytes(
        '606162636465666768696a6b6c6d6e6f'
        '707172737475767778797a7b7c7d7e7f'
        '808182838485868788898a8b8c8d8e8f'
        '909192939495969798999a9b9c9d9e9f'
        'a0a1a2a3a4a5a6a7a8a9aaabacadaeaf',
      );
      final info = _hexToBytes(
        'b0b1b2b3b4b5b6b7b8b9babbbcbdbebf'
        'c0c1c2c3c4c5c6c7c8c9cacbcccdcecf'
        'd0d1d2d3d4d5d6d7d8d9dadbdcdddedf'
        'e0e1e2e3e4e5e6e7e8e9eaebecedeeef'
        'f0f1f2f3f4f5f6f7f8f9fafbfcfdfeff',
      );
      const length = 82;

      final expectedOkm = _hexToBytes(
        'b11e398dc80327a1c8e7f78c596a4934'
        '4f012eda2d4efad8a050cc4c19afa97c'
        '59045a99cac7827271cb41c65e590e09'
        'da3275600c2f09b8367793a9aca3db71'
        'cc30c58179ec3e87c14c01d5c1f3434f'
        '1d87',
      );

      final okm = HkdfUtils.deriveKey(
        ikm: ikm,
        salt: salt,
        info: info,
        length: length,
      );

      expect(okm, equals(expectedOkm));
    });

    test(
      'RFC 5869 Test Vector 3 - пустой salt (должен замениться на 32 нуля)',
      () {
        final ikm = _hexToBytes('0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b0b');
        final salt = Uint8List(0); // Пустой salt
        final info = Uint8List(0); // Пустой info
        const length = 42;

        final expectedOkm = _hexToBytes(
          '8da4e775a563c18f715f802a063c5a31'
          'b8a11f5c5ee1879ec3454e5f3c738d2d'
          '9d201395faa4b61a96c8',
        );

        final okm = HkdfUtils.deriveKey(
          ikm: ikm,
          salt: salt,
          info: info,
          length: length,
        );

        expect(okm, equals(expectedOkm));
      },
    );

    test('deriveKey с length=0 возвращает пустой Uint8List', () {
      final ikm = Uint8List.fromList([1, 2, 3]);
      final salt = Uint8List.fromList([4, 5, 6]);
      final info = Uint8List.fromList([7, 8, 9]);

      final okm = HkdfUtils.deriveKey(
        ikm: ikm,
        salt: salt,
        info: info,
        length: 0,
      );

      expect(okm.length, equals(0));
    });
  });
}
