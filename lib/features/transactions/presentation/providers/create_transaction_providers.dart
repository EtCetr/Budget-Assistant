import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/ports/clock_port.dart';
import 'package:budget_assistant/core/services/elapsed_realtime_service.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction_split.dart';

import '../../data/repositories/transactions_repository_impl.dart';
import '../../domain/repositories/transactions_repository.dart';
import '../../domain/usecases/create_transaction_usecase.dart';
import '../../domain/usecases/update_transaction_usecase.dart';

/// Общий экземпляр Logger для провайдеров фичи.
final Logger _logger = Logger();

/// Реальный репозиторий транзакций (Drift, Этап 6).
final transactionsRepositoryProvider = Provider<TransactionsRepository>((ref) {
  return TransactionsRepositoryImpl(db: AppDatabase(), logger: _logger);
});

/// Боевая реализация монотонных часов через platform channel.
final elapsedRealtimeServiceProvider = Provider<ClockPort>(
  (ref) => ElapsedRealtimeService(),
);

/// UseCase создания транзакции (Этап 6).
final createTransactionUseCaseProvider = Provider<CreateTransactionUseCase>(
  (ref) => CreateTransactionUseCase(
    repository: ref.watch(transactionsRepositoryProvider),
    logger: _logger,
    clock: ref.watch(elapsedRealtimeServiceProvider),
  ),
);

/// UseCase обновления транзакции (Этап 7+).
final updateTransactionUseCaseProvider = Provider<UpdateTransactionUseCase>(
  (ref) => UpdateTransactionUseCase(
    repository: ref.watch(transactionsRepositoryProvider),
    logger: _logger,
    clock: ref.watch(elapsedRealtimeServiceProvider),
  ),
);

/// Id текущего пользователя для формы создания/редактирования.
final currentUserIdForCreateProvider = Provider<String>(
  (ref) => ref.watch(currentUserIdProvider),
);

/// Загрузка транзакции по ID для экрана редактирования.
final editTransactionProvider = FutureProvider.autoDispose
    .family<Transaction?, String>((ref, id) async {
      final repo = ref.watch(transactionsRepositoryProvider);
      try {
        return await repo.getTransactionById(id);
      } catch (_) {
        return null;
      }
    });

/// Загрузка сплитов транзакции для экрана редактирования.
final editTransactionSplitsProvider = FutureProvider.autoDispose
    .family<List<TransactionSplit>, String>((ref, id) async {
      final repo = ref.watch(transactionsRepositoryProvider);
      try {
        return await repo.getSplitsForTransaction(id);
      } catch (_) {
        return const [];
      }
    });
