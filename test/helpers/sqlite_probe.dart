import 'package:sqlite3/sqlite3.dart';

/// Этап 24: проба нативного SQLite для тестов БД на Windows.
///
/// Если библиотеки нет, тесты БД помечаются skip с понятной причиной,
/// а остальные тесты остаются зелёными.
String? _reason;
String? _version;
bool _checked = false;

/// null = SQLite доступен; строка = причина пропуска тестов.
String? sqliteSkipReason() {
  if (_checked) return _reason;
  _checked = true;
  try {
    final db = sqlite3.openInMemory();
    try {
      db.execute('CREATE TABLE probe (x INTEGER)');
      db.execute('INSERT INTO probe VALUES (1)');
      final rows = db.select('SELECT sqlite_version() AS v');
      _version = rows.first['v'] as String?;
    } finally {
      db.close();
    }
    _reason = null;
  } catch (e) {
    _reason = 'SQLite native недоступен ($e). '
        'Положи sqlite3.dll в корень проекта и повтори flutter test.';
  }
  return _reason;
}

/// Версия SQLite, если проба прошла успешно.
String? get sqliteVersion => _version;