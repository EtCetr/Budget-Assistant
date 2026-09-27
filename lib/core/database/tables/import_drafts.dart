import 'package:drift/drift.dart';
import 'users.dart';

/// Локальный черновик состояния wizard'а импорта (ТОМ 2 §23.1).
/// Автосейв каждые 5 сек. Без sync_status, без синхронизации.
/// Очистка: старше 7 дней через WorkManager.
@DataClassName('ImportDraftDb')
class ImportDrafts extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get bankName => text().nullable()();
  TextColumn get filePath => text().nullable()();
  /// JSON: текущий шаг, выбранный формат, опции.
  TextColumn get wizardStateJson => text().nullable()();
  /// JSON распарсенных строк (до подтверждения).
  TextColumn get parsedDataJson => text().nullable()();
  /// JSON маппинга колонок.
  TextColumn get mappingJson => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}