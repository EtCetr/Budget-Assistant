import 'package:drift/drift.dart';
import 'users.dart';
import 'spaces.dart';

/// Кэш годовых итогов (Year in Review, ТЗ 6.3.37, ТОМ 2 §20.2).
/// Локально data_json открыт для мгновенного чтения; E2E — только при sync
/// (Этап 25), как у целей/долгов (решение Этапа 16).
@DataClassName('YearlyAggregateDb')
class YearlyAggregates extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();

  /// NULL = личная статистика (спека 6.3.37.7).
  TextColumn get spaceId => text().nullable().references(Spaces, #id)();
  IntColumn get year => integer()();
  TextColumn get dataJson => text()();
  BoolColumn get isViewed => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastCalculatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}