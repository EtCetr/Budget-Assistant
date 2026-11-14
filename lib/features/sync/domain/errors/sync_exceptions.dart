/// Этап 24 (D24-12): удалённая схема не развёрнута — таблицы нет в Supabase.
///
/// Это НЕ сетевой сбой: повторы бесполезны и только держат фоновую задачу
/// занятой (9+ секунд на пустом месте). Таблицы создаются на Этапе 25.
class RemoteSchemaMissingException implements Exception {
  const RemoteSchemaMissingException(this.table, [this.details]);

  final String table;
  final String? details;

  @override
  String toString() => 'RemoteSchemaMissingException($table): $details';
}