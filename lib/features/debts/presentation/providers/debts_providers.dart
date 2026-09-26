import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/transactions/presentation/providers/create_transaction_providers.dart';
import '../../data/datasources/system_category_source.dart';
import '../../domain/entities/debt.dart';
import '../../domain/entities/debts_groups.dart';
import '../../domain/entities/debts_stats.dart';
import '../../domain/services/system_category_port.dart';
import '../../domain/usecases/calculate_debts_stats_usecase.dart';
import '../../domain/usecases/check_overdue_debts_usecase.dart';
import '../../domain/usecases/close_debt_usecase.dart';
import '../../domain/usecases/create_debts_batch_usecase.dart';
import '../../domain/usecases/decline_name_usecase.dart';
import '../../domain/usecases/delete_debt_usecase.dart';
import '../../domain/usecases/extend_debt_due_date_usecase.dart';
import '../../domain/usecases/format_debt_title_usecase.dart';
import '../../domain/usecases/group_debts_by_status_usecase.dart';
import '../../domain/usecases/mark_debts_as_ex_member_usecase.dart';
import '../../domain/usecases/resolve_debt_usecase.dart';
import '../../domain/usecases/update_debt_usecase.dart';
import 'debts_repository_providers.dart';

final Logger _logger = Logger();

// ═══ UseCases долгов (Этап 13.2–13.3) ═══
final declineNameUseCaseProvider = Provider<DeclineNameUseCase>((ref) {
  return DeclineNameUseCase();
});

final formatDebtTitleUseCaseProvider = Provider<FormatDebtTitleUseCase>((ref) {
  return FormatDebtTitleUseCase(
    declineName: ref.watch(declineNameUseCaseProvider),
  );
});

final calculateDebtsStatsUseCaseProvider =
    Provider<CalculateDebtsStatsUseCase>((ref) {
  return CalculateDebtsStatsUseCase();
});

final groupDebtsByStatusUseCaseProvider =
    Provider<GroupDebtsByStatusUseCase>((ref) {
  return GroupDebtsByStatusUseCase();
});

final checkOverdueDebtsUseCaseProvider =
    Provider<CheckOverdueDebtsUseCase>((ref) {
  return CheckOverdueDebtsUseCase();
});

final markDebtsAsExMemberUseCaseProvider =
    Provider<MarkDebtsAsExMemberUseCase>((ref) {
  return MarkDebtsAsExMemberUseCase(
    repository: ref.watch(debtsRepositoryProvider),
  );
});

final resolveDebtUseCaseProvider = Provider<ResolveDebtUseCase>((ref) {
  return ResolveDebtUseCase(repository: ref.watch(debtsRepositoryProvider));
});

final extendDebtDueDateUseCaseProvider =
    Provider<ExtendDebtDueDateUseCase>((ref) {
  return ExtendDebtDueDateUseCase(
    repository: ref.watch(debtsRepositoryProvider),
  );
});

final updateDebtUseCaseProvider = Provider<UpdateDebtUseCase>((ref) {
  return UpdateDebtUseCase(repository: ref.watch(debtsRepositoryProvider));
});

final deleteDebtUseCaseProvider = Provider<DeleteDebtUseCase>((ref) {
  return DeleteDebtUseCase(repository: ref.watch(debtsRepositoryProvider));
});

final createDebtsBatchUseCaseProvider =
    Provider<CreateDebtsBatchUseCase>((ref) {
  return CreateDebtsBatchUseCase(repository: ref.watch(debtsRepositoryProvider));
});

final systemCategoryPortProvider = Provider<SystemCategoryPort>((ref) {
  return SystemCategorySource(
    db: ref.watch(appDatabaseProvider),
    logger: _logger,
  );
});

final closeDebtUseCaseProvider = Provider<CloseDebtUseCase>((ref) {
  return CloseDebtUseCase(
    debtsRepository: ref.watch(debtsRepositoryProvider),
    transactionsRepository: ref.watch(transactionsRepositoryProvider),
    systemCategory: ref.watch(systemCategoryPortProvider),
    logger: _logger,
  );
});

// ═══ Реактивные данные экрана долгов (6.3.13) ═══
final debtsStreamProvider = StreamProvider<List<Debt>>((ref) {
  return ref
      .watch(debtsRepositoryProvider)
      .watchForUser(userId: ref.watch(currentUserIdProvider));
});

final debtsStatsProvider = Provider<DebtsStats>((ref) {
  final debts = ref.watch(debtsStreamProvider).value ?? const <Debt>[];
  return ref.watch(calculateDebtsStatsUseCaseProvider)(
    debts,
    userId: ref.watch(currentUserIdProvider),
  );
});

final debtsGroupsProvider = Provider<DebtsGroups>((ref) {
  final debts = ref.watch(debtsStreamProvider).value ?? const <Debt>[];
  return ref.watch(groupDebtsByStatusUseCaseProvider)(
    debts,
    userId: ref.watch(currentUserIdProvider),
  );
});