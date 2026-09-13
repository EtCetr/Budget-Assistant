import 'package:logger/logger.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import '../entities/user_space.dart';
import '../repositories/spaces_repository.dart';

/// Создание семейной группы (пространства) с владельцем-admin.
class CreateSpaceUseCase {
  const CreateSpaceUseCase({
    required SpacesRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final SpacesRepository _repository;
  final Logger _logger;

  Future<Result<UserSpace>> call({
    required String userId,
    required String name,
  }) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return const Error(Failure.validation('Название группы не может быть пустым'));
    }
    try {
      final space = await _repository.createSpaceWithAdminMembership(
        userId: userId,
        name: trimmed,
      );
      return Success(space);
    } catch (e, st) {
      _logger.e('CreateSpaceUseCase failed', error: e, stackTrace: st);
      return Error(Failure.database(e.toString()));
    }
  }
}