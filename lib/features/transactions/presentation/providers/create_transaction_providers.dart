import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/ports/clock_port.dart';
import 'package:budget_assistant/core/services/elapsed_realtime_service.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';

import '../../data/repositories/transactions_repository_impl.dart';
import '../../domain/repositories/transactions_repository.dart';
import '../../domain/usecases/create_transaction_usecase.dart';

/// Общий экземпляр Logger для провайдеров фичи.
/// ВАЖНО: в logger 2.x конструктор Logger() не принимает имя ни позиционно,
/// ни именованно — тег передаётся через текст сообщения.
final Logger _logger = Logger();

/// Реальный репозиторий транзакций (Drift, Этап 6).
final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  return TransactionsRepositoryImpl(db: AppDatabase(), logger: _logger);
});

/// UseCase создания транзакции (Этап 6).
final createTransactionUseCaseProvider = Provider<CreateTransactionUseCase>(
  (ref) => CreateTransactionUseCase(
    repository: ref.watch(transactionsRepositoryProvider),
    logger: _logger,
    clock: ref.watch(elapsedRealtimeServiceProvider),
  ),
);

/// Id текущего пользователя для формы создания.
final currentUserIdForCreateProvider = Provider<String>(
  (ref) => ref.watch(currentUserIdProvider),
);

/// Боевая реализация монотонных часов через platform channel.
/// Защита sync-lock от перевода часов пользователем.
final elapsedRealtimeServiceProvider = Provider<ClockPort>(
  (ref) => ElapsedRealtimeService(),
);
