class MoneyInputParser {
  /// Parses user input like "1 234,56" into kopecks.
  /// Returns null if invalid.
  static int? parseKopecks(String input) {
    final normalized = input
        .replaceAll(RegExp(r'[\s ]'), '')
        .replaceAll(',', '.');

    if (normalized.isEmpty) return null;

    final parts = normalized.split('.');
    if (parts.length > 2) return null;

    final rublesPart = parts[0].isEmpty ? '0' : parts[0];
    final rubles = int.tryParse(rublesPart);
    if (rubles == null || rubles < 0) return null;

    var kopecks = 0;

    if (parts.length == 2) {
      final kopRaw = parts[1];
      if (kopRaw.length > 2) return null;

      final padded = kopRaw.padRight(2, '0');
      final parsed = int.tryParse(padded);
      if (parsed == null || parsed < 0) return null;

      kopecks = parsed;
    }

    return rubles * 100 + kopecks;
  }
}
