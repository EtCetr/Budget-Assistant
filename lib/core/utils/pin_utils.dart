import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

// Generates a random salt
String generateSalt() {
  final randomBytes = Uint8List.fromList(
    List.generate(16, (index) => index),
  ); // Use proper crypto random
  return base64Encode(randomBytes);
}

// Hashes the PIN combined with the salt using SHA256
String hashPinWithSalt(String pin, String salt) {
  final bytes = utf8.encode(pin + salt);
  final digest = sha256.convert(bytes);
  return base64Encode(digest.bytes);
}
