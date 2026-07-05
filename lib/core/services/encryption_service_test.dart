import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:budget_assistant/core/services/secure_storage_service.dart';
import 'package:budget_assistant/core/services/encryption_service.dart';
import 'package:budget_assistant/core/exceptions/security_exceptions.dart';
import 'dart:convert';

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late MockSecureStorageService mockSecureStorage;
  late EncryptionService encryptionService;
  const testSpaceId = 'test_space_123';

  // 32 байтный ключ для AES-256
  final testKey = Uint8List.fromList(List.generate(32, (i) => i));
  final testKeyBase64 = base64Encode(testKey);

  setUp(() {
    mockSecureStorage = MockSecureStorageService();
    encryptionService = EncryptionService(secureStorage: mockSecureStorage);

    when(() => mockSecureStorage.read('enc_key_$testSpaceId'))
        .thenAnswer((_) async => testKeyBase64);
  });

  group('EncryptionService', () {
    test('encryptString and decryptString should be reversible', () async {
      const originalText = 'Секретная транзакция на 1000₽';

      final encrypted =
          await encryptionService.encryptString(originalText, testSpaceId);
      expect(encrypted, isNotEmpty);
      expect(encrypted, isNot(equals(originalText)));

      final decrypted =
          await encryptionService.decryptString(encrypted, testSpaceId);
      expect(decrypted, equals(originalText));
    });

    test('encryptInt and decryptInt should be reversible (kopecks)', () async {
      const originalInt = 1234567890;

      final encrypted =
          await encryptionService.encryptInt(originalInt, testSpaceId);
      expect(encrypted, isNotEmpty);

      final decrypted =
          await encryptionService.decryptInt(encrypted, testSpaceId);
      expect(decrypted, equals(originalInt));
    });

    test('decryptString should throw DecryptionException on tampered payload',
        () async {
      final encrypted =
          await encryptionService.encryptString('test', testSpaceId);

      final payloadBytes = base64Decode(encrypted);
      payloadBytes[15] = payloadBytes[15] ^ 0xFF; // Повреждаем Ciphertext
      final tamperedPayload = base64Encode(payloadBytes);

      expect(
        () => encryptionService.decryptString(tamperedPayload, testSpaceId),
        throwsA(isA<DecryptionException>()),
      );
    });

    test('should throw MissingEncryptionKeyException if key is not found',
        () async {
      when(() => mockSecureStorage.read('enc_key_unknown_space'))
          .thenAnswer((_) async => null);

      expect(
        () => encryptionService.encryptString('test', 'unknown_space'),
        throwsA(isA<MissingEncryptionKeyException>()),
      );
    });
  });
}
