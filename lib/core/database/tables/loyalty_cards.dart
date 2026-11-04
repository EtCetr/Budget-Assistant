import 'package:drift/drift.dart';
import 'users.dart';
import 'spaces.dart';

/// Скидочные карты (ТОМ 2 §16.2; ТЗ 6.3.19-6.3.21).
///
/// E2E-стратегия (прецедент Этапа 16): локально store_name / card_number /
/// barcode_data хранятся ОТКРЫТО (генерация штрих-кодов без расшифровки);
/// AES-256-GCM — только для sync-пейлоада (Этап 25).
/// sort_order и preferred_orientation — [LOCAL], не синхронизируются.
@DataClassName('LoyaltyCardDb')
class LoyaltyCards extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text().references(Users, #id)();

  /// NULL = личная карта, UUID = семейная (Multi-group).
  TextColumn get spaceId => text().nullable().references(Spaces, #id)();

  TextColumn get storeName => text()(); // [E2E при sync]

  /// Номер карты (для типа manual); у сканированных обычно равен barcodeData.
  TextColumn get cardNumber => text().nullable()(); // [E2E при sync]

  /// 'ean13' | 'code128' | 'qr' | 'pdf417' | 'manual'.
  TextColumn get barcodeType =>
      text().withDefault(const Constant('manual'))();

  TextColumn get barcodeData => text()(); // [E2E при sync]

  /// Бренд-цвет (#RRGGBB), открытые метаданные.
  TextColumn get brandColor => text().nullable()();

  /// Эмодзи/ассет, открытые метаданные.
  TextColumn get iconAsset => text().nullable()();

  /// 'grocery' | 'pharmacy' | 'clothing' | 'fuel' | 'other'.
  TextColumn get category => text().withDefault(const Constant('other'))();

  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();

  /// Видимость семье (ТЗ 6.3.19): FALSE — карту видит только создатель.
  BoolColumn get isShared => boolean().withDefault(const Constant(true))();

  /// [LOCAL] локальная сортировка (drag-and-drop), не синхронизируется.
  IntColumn get sortOrder => integer().nullable()();

  /// [LOCAL] 'portrait' | 'landscape' (ТЗ 6.3.21.13.8; отклонение от ТОМ 2 —
  /// будет зафиксировано в DECISIONS как D20).
  TextColumn get preferredOrientation => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {id};
}