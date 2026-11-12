import 'package:drift/drift.dart';
import 'users.dart';
import 'spaces.dart';

/// Этап 23.6c (D23.6-6): личный флаг участника «Подключить мои личные
/// транзакции». Хранится отдельно для каждой пары (участник, пространство).
/// Включение — разовая акция присоединения; выключение данные НЕ удаляет.
@DataClassName('PersonalShareFlagDb')
class PersonalShareFlags extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get spaceId => text().references(Spaces, #id)();
  BoolColumn get isEnabled => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastAttachedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  @override
  Set<Column> get primaryKey => {id};
}