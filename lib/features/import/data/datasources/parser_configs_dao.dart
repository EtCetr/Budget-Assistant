import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/tables/parser_configs.dart';

part 'parser_configs_dao.g.dart';

@DriftAccessor(tables: [ParserConfigs])
class ParserConfigsDao extends DatabaseAccessor<AppDatabase>
    with _$ParserConfigsDaoMixin {
  ParserConfigsDao(super.db);

  /// Все конфиги, популярные первыми.
  Future<List<ParserConfigDb>> getAll() {
    return (select(parserConfigs)
          ..orderBy([
            (t) => OrderingTerm.desc(t.isPopular),
            (t) => OrderingTerm.desc(t.usageCount),
            (t) => OrderingTerm.asc(t.bankName),
          ]))
        .get();
  }

  Stream<List<ParserConfigDb>> watchAll() {
    return (select(parserConfigs)
          ..orderBy([
            (t) => OrderingTerm.desc(t.isPopular),
            (t) => OrderingTerm.desc(t.usageCount),
            (t) => OrderingTerm.asc(t.bankName),
          ]))
        .watch();
  }

  Future<ParserConfigDb?> getByBankCode(String bankCode) {
    return (select(parserConfigs)
          ..where((t) => t.bankCode.equals(bankCode)))
        .getSingleOrNull();
  }

  /// Поиск по названию (LIKE, case-insensitive).
  Future<List<ParserConfigDb>> searchByName(String query) {
    return (select(parserConfigs)
          ..where((t) => t.bankName.like('%$query%'))
          ..orderBy([(t) => OrderingTerm.asc(t.bankName)]))
        .get();
  }

  Future<void> insertOrReplace(ParserConfigDb row) {
    return into(parserConfigs)
        .insert(row, mode: InsertMode.insertOrReplace);
  }

  Future<void> insertAll(List<ParserConfigDb> rows) {
    return batch((b) => b.insertAll(parserConfigs, rows,
        mode: InsertMode.insertOrReplace));
  }

  /// Инкремент счётчика использования.
  Future<void> incrementUsageCount(String id) async {
    final current = await (select(parserConfigs)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (current == null) return;
    await (update(parserConfigs)..where((t) => t.id.equals(id))).write(
      ParserConfigsCompanion(
        usageCount: Value(current.usageCount + 1),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }
}