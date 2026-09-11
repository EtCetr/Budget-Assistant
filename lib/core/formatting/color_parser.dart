import 'dart:ui';

class ColorParser {
  static Color fromHex(String hex, {Color fallback = const Color(0xFF9CA3AF)}) {
    try {
      var cleaned = hex.replaceAll('#', '').trim();
      if (cleaned.length == 6) {
        cleaned = 'FF$cleaned';
      }

      if (cleaned.length != 8) {
        return fallback;
      }

      return Color(int.parse(cleaned, radix: 16));
    } catch (_) {
      return fallback;
    }
  }
}
