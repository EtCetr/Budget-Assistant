import 'package:drift/drift.dart';
import 'users.dart';

/// Локальный черновик формы добавления/редактирования карты
/// (автосейв каждые 5 сек, ТЗ 6.3.20.13.10).
/// Без sync_status — не участвует в синхронизации (ТОМ 2 §23).
@DataClassName('LoyaltyCardDraftDb')
class LoyaltyCardDrafts extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();

  /// NULL = новая карта, UUID = редактирование.
  TextColumn get cardId => text().nullable()();
  TextColumn get formDataJson => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}