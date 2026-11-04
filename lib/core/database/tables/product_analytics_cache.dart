import 'package:drift/drift.dart';
import 'users.dart';

/// Предвычисленные агрегаты товаров (ТЗ 6.3.24.12.2).
///
/// Отклонения D20 (будут зафиксированы в DECISIONS):
/// - day хранится как TEXT 'YYYY-MM-DD' (локальный день покупки) вместо DATE;
/// - вместо составного PK (user_id, space_id, day, product_hash) — id PK +
///   уникальный индекс: пересчёт идёт атомарным DELETE+INSERT (drift batch);
/// - space_id = '' вместо NULL (личные чеки) — ради уникальности индекса.
/// Деньги — копейки (IntColumn); E2E — только sync-пейлоад (Этап 25).
@DataClassName('ProductAnalyticsCacheDb')
class ProductAnalyticsCache extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();

  /// '' = личные чеки, UUID = семейное пространство.
  TextColumn get spaceId => text().withDefault(const Constant(''))();

  /// 'YYYY-MM-DD' — локальный день покупки.
  TextColumn get day => text()();

  /// SHA-256(lowercase(normalized_name)) — ключ группировки без расшифровки.
  TextColumn get productHash => text()();

  TextColumn get categoryId => text().nullable()();
  IntColumn get purchases => integer().withDefault(const Constant(0))();
  IntColumn get totalSpendKopecks =>
      integer().withDefault(const Constant(0))();

  /// Количество (не деньги — допустим double, ТОМ 2 §17.3).
  RealColumn get totalQuantity => real().withDefault(const Constant(0.0))();
  IntColumn get avgPriceKopecks => integer().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}