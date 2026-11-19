import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/spaces/domain/usecases/attach_personal_transactions_usecase.dart';
import 'package:budget_assistant/features/spaces/domain/usecases/set_personal_share_usecase.dart';
import '../../../helpers/fake_spaces_repository.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: личный флаг «Подключить мои личные транзакции» (D23.6-6/7).
/// Включение — разовое присоединение; выключение меняет только флаг.
void main() {
  final skip = sqliteSkipReason();

  group('SetPersonalShareUseCase (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late FakeSpacesRepository repo;
    late SetPersonalShareUseCase useCase;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      await seed.tx(id: 'p1', amountKopecks: 1000, categoryId: 'c1');
      await seed.tx(id: 'p2', amountKopecks: 2000, categoryId: 'c1');
      await seed.tx(
        id: 'f1',
        amountKopecks: 3000,
        categoryId: 'c1',
        spaceId: kSpaceId,
      );
      repo = FakeSpacesRepository()..attachCount = 2;
      final logger = Logger(level: Level.off);
      useCase = SetPersonalShareUseCase(
        db: db,
        attach: AttachPersonalTransactionsUseCase(
          repository: repo,
          logger: logger,
        ),
        logger: logger,
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('countPersonal считает только операции без пространства', () async {
      expect(await useCase.countPersonal(userId: kUserId), 2);
    });

    test('флаг по умолчанию выключен', () async {
      expect(
        await useCase.isEnabled(userId: kUserId, spaceId: kSpaceId),
        isFalse,
      );
    });

    test('включение присоединяет операции и ставит флаг', () async {
      final attached = await useCase(
        userId: kUserId,
        spaceId: kSpaceId,
        enabled: true,
      );

      expect(attached, 2);
      expect(repo.attached.length, 1);
      expect(
        await useCase.isEnabled(userId: kUserId, spaceId: kSpaceId),
        isTrue,
      );
      final row = await db.select(db.personalShareFlags).getSingle();
      expect(row.lastAttachedAt, isNotNull);
      expect(row.syncStatus, 'pending');
    });

    test('выключение меняет только флаг, присоединение не выполняется',
        () async {
      await useCase(userId: kUserId, spaceId: kSpaceId, enabled: true);
      repo.calls.clear();

      final attached = await useCase(
        userId: kUserId,
        spaceId: kSpaceId,
        enabled: false,
      );

      expect(attached, 0);
      expect(repo.calls, isNot(contains('attachPersonalTransactionsToSpace')));
      expect(
        await useCase.isEnabled(userId: kUserId, spaceId: kSpaceId),
        isFalse,
      );
      expect((await db.select(db.personalShareFlags).get()).length, 1);
    });

    test('performAttach = false ставит флаг без присоединения', () async {
      final attached = await useCase(
        userId: kUserId,
        spaceId: kSpaceId,
        enabled: true,
        performAttach: false,
      );

      expect(attached, 0);
      expect(repo.attached, isEmpty);
      expect(
        await useCase.isEnabled(userId: kUserId, spaceId: kSpaceId),
        isTrue,
      );
    });
  }, skip: skip);
}