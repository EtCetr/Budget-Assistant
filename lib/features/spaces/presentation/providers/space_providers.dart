import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../../data/repositories/spaces_repository_impl.dart';
import '../../domain/entities/user_space.dart';
import '../../domain/repositories/spaces_repository.dart';
import '../../domain/usecases/attach_personal_transactions_usecase.dart';
import '../../domain/usecases/create_space_usecase.dart';

final Logger _logger = Logger();

final spacesRepositoryProvider = Provider<SpacesRepository>((ref) {
  return SpacesRepositoryImpl(
    db: ref.watch(appDatabaseProvider),
    logger: _logger,
    uuid: const Uuid(),
  );
});

final createSpaceUseCaseProvider = Provider<CreateSpaceUseCase>(
  (ref) => CreateSpaceUseCase(
    repository: ref.watch(spacesRepositoryProvider),
    logger: _logger,
  ),
);

final attachPersonalTransactionsUseCaseProvider =
    Provider<AttachPersonalTransactionsUseCase>(
  (ref) => AttachPersonalTransactionsUseCase(
    repository: ref.watch(spacesRepositoryProvider),
    logger: _logger,
  ),
);

/// Активные пространства текущего пользователя.
/// Реактивный стрим: создание/выход/архив группы обновляет все селекторы.
final userSpacesProvider = StreamProvider<List<UserSpace>>((ref) {
  final repo = ref.watch(spacesRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  return repo.watchUserSpaces(userId);
});