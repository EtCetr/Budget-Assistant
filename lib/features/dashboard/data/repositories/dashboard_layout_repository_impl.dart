import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import '../../domain/entities/dashboard_widget_item.dart';
import '../../domain/entities/dashboard_widget_type.dart';

class DashboardLayoutRepositoryImpl {
  DashboardLayoutRepositoryImpl({required AppDatabase db, required Logger logger})
      : _db = db,
        _logger = logger;

  final AppDatabase _db;
  final Logger _logger;

  Future<void> ensureDefaults(String userId) async {
    try {
      final row = await _db.customSelect(
        'SELECT COUNT(*) AS c FROM dashboard_widgets WHERE user_id = ?',
        variables: [Variable.withString(userId)],
      ).getSingle();

      final count = row.read<int>('c');
      if (count == 0) {
        await _insertDefaults(userId);
      }
    } catch (e, st) {
      _logger.e('DashboardLayoutRepository.ensureDefaults failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  Stream<List<DashboardWidgetItem>> watchLayout(String userId) {
    try {
      return (_db.select(_db.dashboardWidgets)
            ..where((t) => t.userId.equals(userId))
            ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
          .watch()
          .map((rows) => rows.map(_fromRow).toList());
    } catch (e, st) {
      _logger.e('DashboardLayoutRepository.watchLayout failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<void> saveLayout(String userId, List<DashboardWidgetItem> items) async {
    try {
      final now = DateTime.now().toUtc();

      await _db.transaction(() async {
        for (final item in items) {
          await _db.into(_db.dashboardWidgets).insertOnConflictUpdate(
                DashboardWidgetsCompanion(
                  id: Value(item.id),
                  userId: Value(userId),
                  widgetType: Value(item.type.name),
                  isVisible: Value(item.isVisible),
                  sortOrder: Value(item.sortOrder),
                  updatedAt: Value(now),
                  syncStatus: const Value('pending'),
                ),
              );
        }
      });
    } catch (e, st) {
      _logger.e('DashboardLayoutRepository.saveLayout failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<void> _insertDefaults(String userId) async {
    final now = DateTime.now().toUtc();

    final defaults = <DashboardWidgetsCompanion>[
      _defaultRow(userId, DashboardWidgetType.balanceSummary, true, 0, now),
      _defaultRow(userId, DashboardWidgetType.expenseFlowChart, true, 1, now),
      _defaultRow(userId, DashboardWidgetType.activeCashbackCategories, true, 2, now),
      _defaultRow(userId, DashboardWidgetType.limitCards, false, 3, now),
    ];

    await _db.batch((b) => b.insertAll(_db.dashboardWidgets, defaults));
  }

  DashboardWidgetsCompanion _defaultRow(
    String userId,
    DashboardWidgetType type,
    bool visible,
    int order,
    DateTime now,
  ) {
    return DashboardWidgetsCompanion(
      id: Value('dash_$userId${type.name}'),
      userId: Value(userId),
      widgetType: Value(type.name),
      isVisible: Value(visible),
      sortOrder: Value(order),
      createdAt: Value(now),
      updatedAt: Value(now),
      syncStatus: const Value('pending'),
    );
  }

  DashboardWidgetItem _fromRow(dynamic row) {
    final type = DashboardWidgetType.values.firstWhere(
      (e) => e.name == row.widgetType as String,
      orElse: () => DashboardWidgetType.balanceSummary,
    );

    return DashboardWidgetItem(
      id: row.id as String,
      type: type,
      isVisible: row.isVisible as bool,
      sortOrder: row.sortOrder as int,
    );
  }
}