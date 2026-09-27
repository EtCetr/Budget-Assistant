import 'package:drift/drift.dart';
/// Remote Config для Batch-импорта (ТОМ 2 §19.1).
/// config_json НЕ шифруется E2E — публичные метаданные схем банков.
/// До Этапа 25: локальные сиды, sync_status='pending'.
@DataClassName('ParserConfigDb')
class ParserConfigs extends Table {
  TextColumn get id => text()();
  TextColumn get bankName => text()();
  /// Уникальный код: 'tbank', 'sber', 'alfa'.
  TextColumn get bankCode => text().unique()();
  BoolColumn get isPopular => boolean().withDefault(const Constant(false))();
  IntColumn get usageCount => integer().withDefault(const Constant(0))();
  /// JSON-массив: ["csv","xlsx","pdf"].
  TextColumn get supportedFormats => text()();
  /// JSON маппинг колонок. ОТКРЫТЫЙ (не E2E).
  TextColumn get configJson => text()();
  /// JSON с шагами инструкции и скриншотами.
  TextColumn get instructionText => text().nullable()();
  TextColumn get webExportUrl => text().nullable()();
  /// Hex-код цвета бренда.
  TextColumn get brandColor => text().nullable()();
  TextColumn get iconAsset => text().nullable()();
  IntColumn get version => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncStatus =>
      text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}