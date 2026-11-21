import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/notifications/domain/models/notification_type.dart';
import 'package:budget_assistant/features/notifications/domain/usecases/generate_notification_usecase.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: генерация локального пуша (ТОМ 5 §2/§4.4).
/// Дедуп тип+сущность за 24ч (critical — всегда), ночной режим 22:00-08:00
/// блокирует ВСЕ пуши в единой точке (D21-16/D21-40).
///
/// Ночное окно нельзя注入了 — UseCase берёт DateTime.now(), поэтому окна
/// в тестах строятся относительно текущего момента.
String _hhmm(DateTime d) =>
    '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

void main() {
  final skip = sqliteSkipReason();

  group('GenerateNotificationUseCase (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late GenerateNotificationUseCase useCase;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      await db.appSettingsDao.getForUser(kUserId);
      useCase = GenerateNotificationUseCase(db);
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> setNightMode({
      required bool on,
      required String start,
      required String end,
    }) async {
      await db.customStatement(
        'UPDATE app_settings SET night_mode_enabled = ?, '
        'night_mode_start = ?, night_mode_end = ? WHERE user_id = ?',
        [on ? 1 : 0, start, end, kUserId],
      );
    }

    Future<int> count() async =>
        (await db.select(db.notifications).get()).length;

    Future<bool> generate({
      NotificationType type = NotificationType.debtCreated,
      String? entityId = 'd1',
      String? spaceId,
      Duration window = const Duration(hours: 24),
    }) =>
        useCase(
          userId: kUserId,
          type: type,
          title: 'Заголовок',
          body: 'Текст',
          spaceId: spaceId,
          relatedEntityId: entityId,
          dedupWindow: window,
        );

    test('пуш создаётся с типом из enum и возвращается true', () async {
      expect(await generate(), isTrue);

      final row = await db.select(db.notifications).getSingle();
      expect(row.type, NotificationType.debtCreated.dbValue);
      expect(row.userId, kUserId);
      expect(row.relatedEntityId, 'd1');
      expect(row.isRead, isFalse);
    });

    test('повтор того же типа и сущности в окне 24ч отсекается', () async {
      expect(await generate(), isTrue);

      expect(await generate(), isFalse);
      expect(await count(), 1);
    });

    test('другая сущность того же типа создаёт новый пуш', () async {
      await generate(entityId: 'd1');

      expect(await generate(entityId: 'd2'), isTrue);
      expect(await count(), 2);
    });

    test('без сущности повтор тоже отсекается', () async {
      expect(await generate(entityId: null), isTrue);

      expect(await generate(entityId: null), isFalse);
      expect(await count(), 1);
    });

    test('critical тип игнорирует дедупликацию', () async {
      expect(await generate(type: NotificationType.syncConflictManual), isTrue);

      expect(await generate(type: NotificationType.syncConflictManual), isTrue);
      expect(await count(), 2);
    });

    test('запись старше окна дедупликации не блокирует новый пуш', () async {
      final old = DateTime.now().toUtc().subtract(const Duration(hours: 25));
      await db.into(db.notifications).insert(NotificationsCompanion.insert(
            id: 'old',
            userId: kUserId,
            type: NotificationType.debtCreated.dbValue,
            title: 'Старый',
            body: 'Текст',
            relatedEntityId: const Value('d1'),
            createdAt: Value(old),
          ));

      expect(await generate(), isTrue);
      expect(await count(), 2);
    });

    test('ночной режим, покрывающий текущий момент, блокирует пуш', () async {
      final now = DateTime.now();
      await setNightMode(
        on: true,
        start: _hhmm(now.subtract(const Duration(hours: 1))),
        end: _hhmm(now.add(const Duration(hours: 1))),
      );

      expect(await generate(), isFalse);
      expect(await count(), 0);
    });

    test('ночной режим вне текущего момента не блокирует', () async {
      final now = DateTime.now();
      await setNightMode(
        on: true,
        start: _hhmm(now.add(const Duration(hours: 2))),
        end: _hhmm(now.add(const Duration(hours: 3))),
      );

      expect(await generate(), isTrue);
    });

    test('выключенный ночной режим не блокирует', () async {
      final now = DateTime.now();
      await setNightMode(
        on: false,
        start: _hhmm(now.subtract(const Duration(hours: 1))),
        end: _hhmm(now.add(const Duration(hours: 1))),
      );

      expect(await generate(), isTrue);
    });

    test('семейный скоуп сохраняется в записи', () async {
      await generate(spaceId: kSpaceId);

      final row = await db.select(db.notifications).getSingle();
      expect(row.spaceId, kSpaceId);
    });
  }, skip: skip);
}