import '../entities/recurring_transaction.dart';

/// Группа кандидатов (ТЗ 6.3.9.5): системные категории по паттернам
/// нормализованного мерчанта (нормализация убирает пунктуацию,
/// поэтому паттерны пишутся слитно).
class RecurringCandidateGroup {
  const RecurringCandidateGroup({
    required this.key,
    required this.emoji,
    required this.candidates,
  });

  final String key;
  final String emoji;
  final List<RecurringTransaction> candidates;
}

class GroupRecurringCandidatesUseCase {
  static const Map<String, List<String>> _patterns = {
    'subscriptions': [
      'netflix',
      'spotify',
      'youtube',
      'yandexplus',
      'okko',
      'ivi',
      'applemusic',
      'kinopoisk',
    ],
    'utilities': [
      'mts',
      'beeline',
      'megafon',
      'rostelecom',
      'zhkh',
      'energosbyt',
      'internet',
    ],
    'transport': [
      'yandextaxi',
      'sitimobil',
      'troika',
      'podorozhnik',
      'taxi',
    ],
    'cloud': [
      'icloud',
      'googleone',
      'yandexdisk',
      'dropbox',
    ],
    'games': [
      'steam',
      'playstation',
      'xbox',
      'appstore',
      'googleplay',
    ],
  };

  static const Map<String, String> _emojis = {
    'subscriptions': '🎬',
    'utilities': '💡',
    'transport': '🚗',
    'cloud': '☁️',
    'games': '🎮',
    'other': '💳',
  };

  /// Ключ группы для мерчанта; 'other' если паттерн не найден.
  String groupKeyFor(String merchantNormalized) {
    for (final entry in _patterns.entries) {
      for (final p in entry.value) {
        if (merchantNormalized.contains(p)) return entry.key;
      }
    }
    return 'other';
  }

  String emojiFor(String key) => _emojis[key] ?? _emojis['other']!;

  /// Группировка + сортировка групп по количеству кандидатов DESC.
  List<RecurringCandidateGroup> call(List<RecurringTransaction> candidates) {
    final map = <String, List<RecurringTransaction>>{};
    for (final c in candidates) {
      final key = groupKeyFor(c.merchantNameNormalized);
      map.putIfAbsent(key, () => <RecurringTransaction>[]).add(c);
    }
    final groups = [
      for (final entry in map.entries)
        RecurringCandidateGroup(
          key: entry.key,
          emoji: emojiFor(entry.key),
          candidates: entry.value,
        ),
    ];
    groups.sort((a, b) => b.candidates.length.compareTo(a.candidates.length));
    return groups;
  }
}