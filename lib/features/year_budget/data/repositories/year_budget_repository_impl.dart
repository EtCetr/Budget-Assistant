import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/daos/year_budget_dao.dart';
import '../../domain/models/year_budget_models.dart';
import '../../domain/repositories/year_budget_repository.dart';

class YearBudgetRepositoryImpl implements YearBudgetRepository {
  YearBudgetRepositoryImpl({required AppDatabase db, required Logger logger})
      : _db = db,
        _dao = YearBudgetDao(db),
        _logger = logger;

  final AppDatabase _db;
  final YearBudgetDao _dao;
  final Logger _logger;

  @override
  Future<List<YearCatMonthSum>> expenseMatrix({
    required String userId,
    required String? spaceId,
    required int year,
  }) async {
    try {
      final raw = await _dao.expenseMatrix(
          userId: userId, spaceId: spaceId, year: year);
      return _merge(raw);
    } catch (e, st) {
      _logger.e('expenseMatrix failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<YearCatMonthSum>> incomeMatrix({
    required String userId,
    required String? spaceId,
    required int year,
  }) async {
    try {
      final raw = await _dao.incomeMatrix(
          userId: userId, spaceId: spaceId, year: year);
      return _merge(raw);
    } catch (e, st) {
      _logger.e('incomeMatrix failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  List<YearCatMonthSum> _merge(List<CatMonthSum> raw) {
    final acc = <String, int>{};
    for (final r in raw) {
      final k = '${r.categoryId}|${r.month}';
      acc[k] = (acc[k] ?? 0) + r.total;
    }
    return acc.entries.map((e) {
      final parts = e.key.split('|');
      return YearCatMonthSum(
        categoryId: parts[0],
        month: int.parse(parts[1]),
        totalKopecks: e.value,
      );
    }).toList();
  }

  @override
  Future<List<CategoryInfo>> categories({
    required String userId,
    required String? spaceId,
  }) async {
    final rows = await _dao.scopeCategories(userId: userId, spaceId: spaceId);
    return rows
        .map((c) => CategoryInfo(
              id: c.id,
              name: c.name,
              type: c.type,
              colorHex: c.colorHex,
              emoji: c.iconEmoji,
            ))
        .toList();
  }

  @override
  Future<Map<String, Map<int, int>>> limitsYear({
    required String userId,
    required String? spaceId,
    required int year,
  }) async {
    final result = <String, Map<int, int>>{};
    for (var m = 1; m <= 12; m++) {
      final rows = await _dao.limitsForMonth(
          userId: userId, spaceId: spaceId, year: year, month: m);
      for (final r in rows) {
        final byMonth = result.putIfAbsent(r.categoryId, () => {});
        byMonth[r.month] = (byMonth[r.month] ?? 0) + r.limitAmount;
      }
    }
    return result;
  }

  @override
  Future<List<int>> availableYears({
    required String userId,
    required String? spaceId,
  }) =>
      _dao.availableYears(userId: userId, spaceId: spaceId);

  @override
  Future<List<MonthTxRow>> monthTransactions({
    required String userId,
    required String? spaceId,
    required int year,
    required int month,
    required String type,
  }) async {
    final rows = await _dao.monthTransactions(
        userId: userId, spaceId: spaceId, year: year, month: month, type: type);
    return rows
        .map((r) => MonthTxRow(
              id: r.read<String>('id'),
              dateUtc: DateTime.fromMillisecondsSinceEpoch(
                  r.read<int>('d') * 1000,
                  isUtc: true),
              accountName: r.read<String>('acc'),
              categoryName: r.read<String>('cat'),
              amountKopecks: r.read<int>('amt'),
              comment: r.readNullable<String>('cmt'),
              isSplitPosition: r.read<int>('ispos') == 1,
            ))
        .toList();
  }

  @override
  Future<int?> allocated({
    required String userId,
    required String? spaceId,
    required int year,
    required int month,
  }) async {
    final q = _db.select(_db.monthlyBudgets)
      ..where((t) =>
          t.year.equals(year) &
          t.month.equals(month) &
          (spaceId == null
              ? (t.spaceId.equals('') & t.userId.equals(userId))
              : t.spaceId.equals(spaceId)))
      ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
      ..limit(1);
    final row = await q.getSingleOrNull();
    return row?.allocatedAmount;
  }

  @override
  Future<void> saveAllocated({
    required String userId,
    required String? spaceId,
    required int year,
    required int month,
    required int kopecks,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      final q = _db.select(_db.monthlyBudgets)
        ..where((t) =>
            t.year.equals(year) &
            t.month.equals(month) &
            (spaceId == null
                ? (t.spaceId.equals('') & t.userId.equals(userId))
                : t.spaceId.equals(spaceId)))
        ..limit(1);
      final row = await q.getSingleOrNull();
      if (row != null) {
        await (_db.update(_db.monthlyBudgets)
              ..where((t) => t.id.equals(row.id)))
            .write(MonthlyBudgetsCompanion(
          allocatedAmount: Value(kopecks),
          updatedAt: Value(now),
          syncStatus: const Value('pending'),
        ));
        return;
      }
      await _db.into(_db.monthlyBudgets).insert(
            MonthlyBudgetsCompanion.insert(
              id: const Uuid().v4(),
              userId: userId,
              spaceId: Value(spaceId ?? ''),
              year: year,
              month: month,
              allocatedAmount: kopecks,
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );
    } catch (e, st) {
      _logger.e('saveAllocated failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> saveLimit({
    required String userId,
    required String? spaceId,
    required int year,
    required int month,
    required String categoryId,
    required int kopecks,
  }) async {
    try {
      final now = DateTime.now().toUtc();
      if (spaceId != null) {
        // Семья: одна таблица на группу — убираем строки других участников.
        await (_db.delete(_db.budgetLimits)
              ..where((b) =>
                  b.spaceId.equals(spaceId) &
                  b.categoryId.equals(categoryId) &
                  b.year.equals(year) &
                  b.month.equals(month) &
                  b.userId.equals(userId).not()))
            .go();
      }
      final existing = await _db.budgetLimitsDao.getForCategory(
        userId: userId,
        spaceId: spaceId,
        categoryId: categoryId,
        year: year,
        month: month,
      );
      if (existing != null) {
        await (_db.update(_db.budgetLimits)
              ..where((b) => b.id.equals(existing.id)))
            .write(BudgetLimitsCompanion(
          limitAmount: Value(kopecks),
          updatedAt: Value(now),
          syncStatus: const Value('pending'),
        ));
        return;
      }
      await _db.into(_db.budgetLimits).insert(BudgetLimitsCompanion.insert(
            id: const Uuid().v4(),
            userId: userId,
            spaceId: Value(spaceId),
            categoryId: categoryId,
            year: year,
            month: month,
            limitAmount: kopecks,
            createdAt: now,
            updatedAt: now,
          ));
    } catch (e, st) {
      _logger.e('saveLimit failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<Map<String, int>> limitsForMonth({
    required String userId,
    required String? spaceId,
    required int year,
    required int month,
  }) async {
    final rows = await _dao.limitsForMonth(
        userId: userId, spaceId: spaceId, year: year, month: month);
    final out = <String, int>{};
    for (final r in rows) {
      out[r.categoryId] = (out[r.categoryId] ?? 0) + r.limitAmount;
    }
    return out;
  }

  @override
  Future<({int year, int month})?> previousBudgetMonth({
    required String userId,
    required String? spaceId,
    required int year,
    required int month,
  }) async {
    var y = year;
    var m = month;
    for (var i = 0; i < 24; i++) {
      m--;
      if (m == 0) {
        m = 12;
        y--;
      }
      final limits = await limitsForMonth(
          userId: userId, spaceId: spaceId, year: y, month: m);
      final alloc = await allocated(
          userId: userId, spaceId: spaceId, year: y, month: m);
      if (limits.isNotEmpty || alloc != null) {
        return (year: y, month: m);
      }
    }
    return null;
  }

  @override
  Future<int> carryOver({
    required String userId,
    required String? spaceId,
    required int fromYear,
    required int fromMonth,
    required int toYear,
    required int toMonth,
  }) async {
    var copied = 0;
    final limits = await limitsForMonth(
        userId: userId, spaceId: spaceId, year: fromYear, month: fromMonth);
    for (final e in limits.entries) {
      await saveLimit(
        userId: userId,
        spaceId: spaceId,
        year: toYear,
        month: toMonth,
        categoryId: e.key,
        kopecks: e.value,
      );
      copied++;
    }
    final alloc = await allocated(
        userId: userId, spaceId: spaceId, year: fromYear, month: fromMonth);
    final target = await allocated(
        userId: userId, spaceId: spaceId, year: toYear, month: toMonth);
    if (alloc != null && target == null) {
      await saveAllocated(
        userId: userId,
        spaceId: spaceId,
        year: toYear,
        month: toMonth,
        kopecks: alloc,
      );
      copied++;
    }
    return copied;
  }
}