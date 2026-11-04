import 'dart:convert';

import 'package:crypto/crypto.dart';

/// product_hash = SHA-256(lowercase(normalized_name)) — ТЗ 6.3.24.12.4.
/// Позволяет группировать покупки без расшифровки имён (E2E-прецедент Этапа 16).
abstract final class ProductHashUtil {
  static String hash(String normalizedName) {
    return sha256
        .convert(utf8.encode(normalizedName.trim().toLowerCase()))
        .toString();
  }
}