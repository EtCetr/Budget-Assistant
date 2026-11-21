import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/spaces/domain/usecases/leave_space_usecase.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: выход из пространства — 4 сценария (ТЗ 6.3.51.3 / 6.3.39.6).
/// Расформирование = soft-delete (D17-12); мои операции группы уходят в архив.
void main() {
  final skip = sqliteSkipReason();

  group('LeaveSpaceUseCase (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late LeaveSpaceUseCase useCase;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      await seed.user(kOtherUserId);
      await seed.user('u3');
      useCase = LeaveSpaceUseCase(db: db);
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> member({
      required String id,
      required String userId,
      String role = 'member',
      String status = 'active',
    }) async {
      await db.into(db.memberships).insert(MembershipsCompanion.insert(
            id: id,
            userId: userId,
            spaceId: kSpaceId,
            joinedAt: DateTime.now().toUtc(),
            role: Value(role),
            status: Value(status),
          ));
    }

    Future<String> roleOf(String id) async {
      final row = await (db.select(db.memberships)
            ..where((m) => m.id.equals(id)))
          .getSingle();
      return row.role;
    }

    Future<String> statusOf(String id) async {
      final row = await (db.select(db.memberships)
            ..where((m) => m.id.equals(id)))
          .getSingle();
      return row.status;
    }

    group('evaluate', () {
      test('нет активного членства — StateError', () async {
        await expectLater(
          useCase.evaluate(userId: kUserId, spaceId: kSpaceId),
          throwsA(isA<StateError>()),
        );
      });

      test('обычный участник — простой выход', () async {
        await member(id: 'm1', userId: kUserId);
        await member(id: 'm2', userId: kOtherUserId, role: 'admin');

        final e = await useCase.evaluate(userId: kUserId, spaceId: kSpaceId);

        expect(e.scenario, LeaveSpaceScenario.simpleLeave);
      });

      test('админ при другом админе — простой выход', () async {
        await member(id: 'm1', userId: kUserId, role: 'admin');
        await member(id: 'm2', userId: kOtherUserId, role: 'admin');

        final e = await useCase.evaluate(userId: kUserId, spaceId: kSpaceId);

        expect(e.scenario, LeaveSpaceScenario.simpleLeave);
      });

      test('единственный админ один в группе — расформирование', () async {
        await member(id: 'm1', userId: kUserId, role: 'admin');

        final e = await useCase.evaluate(userId: kUserId, spaceId: kSpaceId);

        expect(e.scenario, LeaveSpaceScenario.dissolveSolo);
      });

      test('единственный админ и 2 участника — автоповышение', () async {
        await member(id: 'm1', userId: kUserId, role: 'admin');
        await member(id: 'm2', userId: kOtherUserId);

        final e = await useCase.evaluate(userId: kUserId, spaceId: kSpaceId);

        expect(e.scenario, LeaveSpaceScenario.autoPromote);
      });

      test('единственный админ и 3+ участников — выбор преемника', () async {
        await member(id: 'm1', userId: kUserId, role: 'admin');
        await member(id: 'm2', userId: kOtherUserId);
        await member(id: 'm3', userId: 'u3');

        final e = await useCase.evaluate(userId: kUserId, spaceId: kSpaceId);

        expect(e.scenario, LeaveSpaceScenario.chooseSuccessor);
        expect(e.candidates.length, 2);
        expect(e.candidates.every((c) => c.userId != kUserId), isTrue);
      });

      test('вышедший участник не считается активным', () async {
        await member(id: 'm1', userId: kUserId, role: 'admin');
        await member(id: 'm2', userId: kOtherUserId, status: 'left');

        final e = await useCase.evaluate(userId: kUserId, spaceId: kSpaceId);

        expect(e.scenario, LeaveSpaceScenario.dissolveSolo);
      });
    });

    group('Действия', () {
      test('простой выход: только моё членство, операции в архив', () async {
        await member(id: 'm1', userId: kUserId);
        await member(id: 'm2', userId: kOtherUserId, role: 'admin');
        await seed.tx(
          id: 'mine',
          amountKopecks: 1000,
          categoryId: 'c1',
          spaceId: kSpaceId,
        );
        await seed.tx(
          id: 'other',
          amountKopecks: 2000,
          categoryId: 'c1',
          spaceId: kSpaceId,
          userId: kOtherUserId,
        );

        await useCase.simpleLeave(userId: kUserId, spaceId: kSpaceId);

        expect(await statusOf('m1'), 'left');
        expect(await statusOf('m2'), 'active');
        final mine = await (db.select(db.transactions)
              ..where((t) => t.id.equals('mine')))
            .getSingle();
        final other = await (db.select(db.transactions)
              ..where((t) => t.id.equals('other')))
            .getSingle();
        expect(mine.isArchivedForSpace, isTrue);
        expect(other.isArchivedForSpace, isFalse);
      });

      test('автоповышение: оставшийся становится админом', () async {
        await member(id: 'm1', userId: kUserId, role: 'admin');
        await member(id: 'm2', userId: kOtherUserId);

        await useCase.leaveWithAutoPromote(
          userId: kUserId,
          spaceId: kSpaceId,
        );

        expect(await roleOf('m2'), 'admin');
        expect(await statusOf('m1'), 'left');
        expect(await statusOf('m2'), 'active');
      });

      test('выбор преемника: повышен именно выбранный', () async {
        await member(id: 'm1', userId: kUserId, role: 'admin');
        await member(id: 'm2', userId: kOtherUserId);
        await member(id: 'm3', userId: 'u3');

        await useCase.leaveWithSuccessor(
          userId: kUserId,
          spaceId: kSpaceId,
          successorUserId: 'u3',
        );

        expect(await roleOf('m3'), 'admin');
        expect(await roleOf('m2'), 'member');
        expect(await statusOf('m1'), 'left');
      });

      test('расформирование: группа dissolved, все членства left', () async {
        await member(id: 'm1', userId: kUserId, role: 'admin');

        await useCase.dissolveSolo(userId: kUserId, spaceId: kSpaceId);

        final space = await (db.select(db.spaces)
              ..where((s) => s.id.equals(kSpaceId)))
            .getSingle();
        expect(space.status, 'dissolved');
        expect(space.dissolvedBy, kUserId);
        expect(space.dissolvedAt, isNotNull);
        expect(space.syncStatus, 'pending');
        expect(await statusOf('m1'), 'left');
      });

      test('повторный выход не падает и не меняет другие группы', () async {
        await seed.space('s2');
        await member(id: 'm1', userId: kUserId);
        await db.into(db.memberships).insert(MembershipsCompanion.insert(
              id: 'm2',
              userId: kUserId,
              spaceId: 's2',
              joinedAt: DateTime.now().toUtc(),
              role: const Value('admin'),
            ));

        await useCase.simpleLeave(userId: kUserId, spaceId: kSpaceId);
        await useCase.simpleLeave(userId: kUserId, spaceId: kSpaceId);

        expect(await statusOf('m1'), 'left');
        expect(await statusOf('m2'), 'active');
      });
    });
  }, skip: skip);
}