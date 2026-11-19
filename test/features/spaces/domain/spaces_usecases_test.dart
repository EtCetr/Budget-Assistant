import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/features/spaces/domain/entities/space_membership_info.dart';
import 'package:budget_assistant/features/spaces/domain/entities/user_space.dart';
import 'package:budget_assistant/features/spaces/domain/usecases/attach_personal_transactions_usecase.dart';
import 'package:budget_assistant/features/spaces/domain/usecases/create_space_usecase.dart';
import '../../../helpers/fake_spaces_repository.dart';

/// Этап 24: пространства (Multi-group, ТЗ 6.3.51).
/// Создание группы и разовое подключение личных операций.
void main() {
  late FakeSpacesRepository repo;
  late Logger logger;
  late CreateSpaceUseCase create;
  late AttachPersonalTransactionsUseCase attach;

  setUp(() {
    repo = FakeSpacesRepository();
    logger = Logger(level: Level.off);
    create = CreateSpaceUseCase(repository: repo, logger: logger);
    attach = AttachPersonalTransactionsUseCase(
      repository: repo,
      logger: logger,
    );
  });

  group('Модели', () {
    test('UserSpace — пара id и имя для селектора', () {
      const s = UserSpace(id: 's1', name: 'Семья');
      expect(s.id, 's1');
      expect(s.name, 'Семья');
    });

    test('isAdmin только для роли admin', () {
      final admin = SpaceMembershipInfo(
        spaceId: 's1',
        spaceName: 'Семья',
        spaceStatus: 'active',
        role: 'admin',
        joinedAt: DateTime.utc(2026),
        memberCount: 3,
      );
      final member = SpaceMembershipInfo(
        spaceId: 's1',
        spaceName: 'Семья',
        spaceStatus: 'active',
        role: 'member',
        joinedAt: DateTime.utc(2026),
        memberCount: 3,
      );

      expect(admin.isAdmin, isTrue);
      expect(member.isAdmin, isFalse);
      expect(admin.isDissolved, isFalse);
    });

    test('isDissolved для расформированной группы', () {
      final info = SpaceMembershipInfo(
        spaceId: 's1',
        spaceName: 'Семья',
        spaceStatus: 'dissolved',
        dissolvedAt: DateTime.utc(2026, 7, 1),
        role: 'admin',
        joinedAt: DateTime.utc(2026),
        memberCount: 1,
      );

      expect(info.isDissolved, isTrue);
    });
  });

  group('CreateSpaceUseCase', () {
    test('пустое название отклоняется без записи', () async {
      final r = await create(userId: 'u1', name: '   ');

      expect(r, isA<Error<UserSpace>>());
      expect((r as Error<UserSpace>).failure, isA<ValidationFailure>());
      expect(repo.created, isEmpty);
    });

    test('название обрезается перед созданием', () async {
      final r = await create(userId: 'u1', name: '  Семья  ');

      expect(r, isA<Success<UserSpace>>());
      expect((r as Success<UserSpace>).value.name, 'Семья');
      expect(repo.created.single.name, 'Семья');
    });

    test('создание возвращает пространство с id', () async {
      final r = await create(userId: 'u1', name: 'Семья');

      expect((r as Success<UserSpace>).value.id, isNotEmpty);
      expect(repo.created.single.userId, 'u1');
    });

    test('ошибка репозитория превращается в DatabaseFailure', () async {
      repo.error = Exception('db down');

      final r = await create(userId: 'u1', name: 'Семья');

      expect(r, isA<Error<UserSpace>>());
      expect((r as Error<UserSpace>).failure, isA<DatabaseFailure>());
    });
  });

  group('AttachPersonalTransactionsUseCase', () {
    test('возвращает количество подключённых операций', () async {
      repo.attachCount = 12;

      final r = await attach(userId: 'u1', spaceId: 's1');

      expect((r as Success<int>).value, 12);
      expect(repo.attached.single.spaceId, 's1');
    });

    test('ошибка репозитория превращается в DatabaseFailure', () async {
      repo.error = Exception('db down');

      final r = await attach(userId: 'u1', spaceId: 's1');

      expect(r, isA<Error<int>>());
      expect((r as Error<int>).failure, isA<DatabaseFailure>());
    });
  });
}