import 'package:budget_assistant/features/spaces/domain/entities/user_space.dart';
import 'package:budget_assistant/features/spaces/domain/repositories/spaces_repository.dart';

/// Этап 24: заглушка репозитория пространств для доменных тестов.
class FakeSpacesRepository implements SpacesRepository {
  List<UserSpace> spaces = <UserSpace>[];
  int attachCount = 0;
  Object? error;

  final List<String> calls = <String>[];
  final List<({String userId, String name})> created =
      <({String userId, String name})>[];
  final List<({String userId, String spaceId})> attached =
      <({String userId, String spaceId})>[];

  void _enter(String name) {
    calls.add(name);
    final e = error;
    if (e != null) throw e;
  }

  @override
  Stream<List<UserSpace>> watchUserSpaces(String userId) async* {
    _enter('watchUserSpaces');
    yield spaces;
  }

  @override
  Future<UserSpace> createSpaceWithAdminMembership({
    required String userId,
    required String name,
  }) async {
    _enter('createSpaceWithAdminMembership');
    created.add((userId: userId, name: name));
    final space = UserSpace(id: 'space-new', name: name);
    spaces = [...spaces, space];
    return space;
  }

  @override
  Future<int> attachPersonalTransactionsToSpace({
    required String userId,
    required String spaceId,
  }) async {
    _enter('attachPersonalTransactionsToSpace');
    attached.add((userId: userId, spaceId: spaceId));
    return attachCount;
  }
}