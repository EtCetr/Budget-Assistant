import 'package:drift/drift.dart';
import 'users.dart';

/// Этап 23.5: «Выделено» на месяц (лично и per-space). D23.5-5.
/// space_id = '' — личный скоуп (прецедент D20-5: '' вместо NULL для UNIQUE).
@DataClassName('MonthlyBudgetDb')
class MonthlyBudgets extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get spaceId => text().withDefault(const Constant(''))();
  IntColumn get year => integer()();
  IntColumn get month => integer()();
  IntColumn get allocatedAmount => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  @override
  Set<Column> get primaryKey => {id};
}