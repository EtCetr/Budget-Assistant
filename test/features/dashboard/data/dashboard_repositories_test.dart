import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/dashboard/data/repositories/dashboard_data_repository_impl.dart';
import 'package:budget_assistant/features/dashboard/data/repositories/dashboard_layout_repository_impl.dart';
import 'package:budget_assistant/features/dashboard/domain/entities/dashboard_widget_item.dart';
import 'package:budget_assistant/features/dashboard/domain/entities/dashboard_widget_type.dart';
import 'package:budget_assistant/features/dashboard/domain/usecases/update_dashboard_layout_usecase.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: раскладка дашборда (локальная, без синка) и виджет
/// «Активный кэшбэк» на реальной БД (Drift in-memory).
void main() {
  final skip = sqliteSkipReason();

  group('DashboardLayoutRepositoryImpl (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late DashboardLayoutRepositoryImpl repo;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.user(kUserId);
      repo = DashboardLayoutRepositoryImpl(
        db: db,
        logger: Logger(level: Level.off),
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('по умолчанию 4 виджета, «Лимиты» скрыт', () async {
      await repo.ensureDefaults(kUserId);

      final items = await repo.watchLayout(kUserId).first;

      expect(items.length, 4);
      expect(items.map((e) => e.type).toList(), DashboardWidgetType.values);
      expect(items.map((e) => e.sortOrder).toList(), [0, 1, 2, 3]);
      expect(
        items
            .firstWhere((e) => e.type == DashboardWidgetType.limitCards)
            .isVisible,
        isFalse,
      );
      expect(
        items
            .where((e) => e.type != DashboardWidgetType.limitCards)
            .every((e) => e.isVisible),
        isTrue,
      );
    });

    test('повторный ensureDefaults не плодит дубли', () async {
      await repo.ensureDefaults(kUserId);
      await repo.ensureDefaults(kUserId);

      expect((await repo.watchLayout(kUserId).first).length, 4);
    });

    test('ensureDefaults не трогает уже настроенную раскладку', () async {
      final now = DateTime.now().toUtc();
      await db.into(db.dashboardWidgets).insert(
            DashboardWidgetsCompanion.insert(
              id: 'only-one',
              userId: kUserId,
              widgetType: DashboardWidgetType.balanceSummary.name,
              isVisible: const Value(false),
              sortOrder: const Value(7),
              createdAt: Value(now),
              updatedAt: Value(now),
            ),
          );

      await repo.ensureDefaults(kUserId);

      final items = await repo.watchLayout(kUserId).first;
      expect(items.length, 1);
      expect(items.single.id, 'only-one');
      expect(items.single.isVisible, isFalse);
      expect(items.single.sortOrder, 7);
    });

    test('saveLayout меняет видимость и порядок, ставит pending', () async {
      await repo.ensureDefaults(kUserId);
      final items = await repo.watchLayout(kUserId).first;

      final reordered = <DashboardWidgetItem>[
        items[3].copyWith(isVisible: true, sortOrder: 0),
        items[0].copyWith(isVisible: false, sortOrder: 1),
        items[1].copyWith(sortOrder: 2),
        items[2].copyWith(sortOrder: 3),
      ];
      await repo.saveLayout(kUserId, reordered);

      final next = await repo.watchLayout(kUserId).first;
      expect(next.map((e) => e.type).toList(), [
        DashboardWidgetType.limitCards,
        DashboardWidgetType.balanceSummary,
        DashboardWidgetType.expenseFlowChart,
        DashboardWidgetType.activeCashbackCategories,
      ]);
      expect(next.first.isVisible, isTrue);
      expect(next[1].isVisible, isFalse);

      final rows = await db.select(db.dashboardWidgets).get();
      expect(rows.length, 4);
      expect(rows.every((r) => r.syncStatus == 'pending'), isTrue);
    });

    test('повторное сохранение обновляет те же строки', () async {
      await repo.ensureDefaults(kUserId);
      final items = await repo.watchLayout(kUserId).first;

      await repo.saveLayout(kUserId, items);
      await repo.saveLayout(kUserId, items);

      expect((await db.select(db.dashboardWidgets).get()).length, 4);
    });

    test('UseCase делегирует сохранение в репозиторий', () async {
      await repo.ensureDefaults(kUserId);
      final items = await repo.watchLayout(kUserId).first;
      final useCase = UpdateDashboardLayoutUseCase(
        repository: repo,
        logger: Logger(level: Level.off),
      );

      await useCase(
        userId: kUserId,
        items: [items.first.copyWith(isVisible: false)],
      );

      final next = await repo.watchLayout(kUserId).first;
      expect(next.first.isVisible, isFalse);
    });

    test('ошибка репозитория пробрасывается из UseCase', () async {
      final broken = openTestDb();
      await broken.close();
      final useCase = UpdateDashboardLayoutUseCase(
        repository: DashboardLayoutRepositoryImpl(
          db: broken,
          logger: Logger(level: Level.off),
        ),
        logger: Logger(level: Level.off),
      );

      // Список должен быть непустым: при пустом списке репозиторий
      // не выполняет ни одного запроса и закрытая БД не падает.
      const item = DashboardWidgetItem(
        id: 'broken-item',
        type: DashboardWidgetType.balanceSummary,
        isVisible: true,
        sortOrder: 0,
      );

      await expectLater(
        useCase(userId: kUserId, items: const [item]),
        throwsA(anything),
      );
    });
  }, skip: skip);

  group('DashboardDataRepository.getActiveCashback (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late DashboardDataRepositoryImpl repo;
    final now = DateTime.now().toUtc();

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      await seed.user(kOtherUserId);
      await seed.account(id: 'a2', userId: kOtherUserId);
      repo = DashboardDataRepositoryImpl(
        db: db,
        logger: Logger(level: Level.off),
      );
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> entry({
      required String id,
      String accountId = kAccountId,
      String status = 'approved',
      DateTime? expiresAt,
      String categoryName = 'Продукты',
    }) async {
      await db.into(db.cashbackMatrix).insert(CashbackMatrixCompanion.insert(
            id: id,
            accountId: accountId,
            categoryName: categoryName,
            percentBps: 500,
            expiresAt: expiresAt ?? now.add(const Duration(days: 10)),
            status: Value(status),
            createdAt: now,
            updatedAt: now,
          ));
    }

    test('берётся только подтверждённый кэшбэк', () async {
      await entry(id: 'ok');
      await entry(id: 'pending', status: 'potential');

      final items = await repo.getActiveCashback(kUserId);

      expect(items.map((e) => e.id), ['ok']);
      expect(items.single.percentBps, 500);
      expect(items.single.categoryName, 'Продукты');
    });

    test('истёкшие категории исключены', () async {
      await entry(id: 'ok');
      await entry(
        id: 'old',
        expiresAt: now.subtract(const Duration(days: 1)),
      );

      expect((await repo.getActiveCashback(kUserId)).map((e) => e.id), ['ok']);
    });

    test('категории чужого счёта не попадают', () async {
      await entry(id: 'mine');
      await entry(id: 'foreign', accountId: 'a2');

      expect(
        (await repo.getActiveCashback(kUserId)).map((e) => e.id),
        ['mine'],
      );
    });

    test('сортировка по ближайшей дате окончания', () async {
      await entry(id: 'later');
      await entry(
        id: 'sooner',
        expiresAt: now.add(const Duration(days: 2)),
      );

      expect(
        (await repo.getActiveCashback(kUserId)).map((e) => e.id).toList(),
        ['sooner', 'later'],
      );
    });
  }, skip: skip);

  group('DashboardWidgetType', () {
    test('у каждого виджета есть человекочитаемое название', () {
      expect(DashboardWidgetType.balanceSummary.title, 'Общий баланс');
      expect(DashboardWidgetType.expenseFlowChart.title, 'Движение расходов');
      expect(
        DashboardWidgetType.activeCashbackCategories.title,
        'Активный кэшбэк',
      );
      expect(DashboardWidgetType.limitCards.title, 'Лимиты');
    });
  });
}