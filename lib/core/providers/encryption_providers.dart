import 'package:flutter_riverpod/flutter_riverpod.dart';

class MockEncryptionService {
  Future<String> generateKey() async => 'mock_master_key_123';
}

final encryptionServiceProvider = Provider<MockEncryptionService>((ref) {
  return MockEncryptionService();
});
