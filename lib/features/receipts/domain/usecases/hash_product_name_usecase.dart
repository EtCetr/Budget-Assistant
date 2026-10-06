import 'dart:convert';
import 'package:crypto/crypto.dart';

/// SHA-256 от lowercase(trim(original_name)) — открытый ключ поиска алиаса
/// без расшифровки E2E-имени (ТОМ 2 17.4).
class HashProductNameUseCase {
  String call(String originalName) =>
      sha256.convert(utf8.encode(originalName.trim().toLowerCase())).toString();
}