import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/features/budget/domain/entities/budget_limit.dart';
import 'package:budget_assistant/features/budget/domain/usecases/delete_budget_limit_usecase.dart';
import 'package:budget_assistant/features/budget/domain/usecases/upsert_budget_limit_usecase.dart';
import '../../../helpers/fake_budget_limits_repository.dart';

/// Этап 24: сохранение лимита (Offline-First) и удаление.
void main() {
  late FakeBudgetLimitsRepository repo;
  late UpsertBudgetLimitUseCase upsert;
  late DeleteBudgetLimitUseCase delete;

  setUp(() {
    repo = FakeBudgetLimitsRepository();
    final logger = Logger(level: Level.off);
    upsert = UpsertBudgetLimitUseCase(repository: repo, logger: logger);
    delete = DeleteBudgetLimitUseCase(repository: repo, logger: logger);
  });

  test('новый лимит создаётся с pending и UTC-датами', () async {
    final result = await upsert(
      userId: 'u1',
      categoryId: 'c1',
      year: 2026,
      month: 7,
      limitAmount: 2000000,
    );
    final limit = (result as Success<BudgetLimit>).value;

    expect(limit.id, isNotEmpty);
    expect(limit.syncStatus, 'pending');
    expect(limit.createdAt.isUtc, isTrue);
    expect(limit.updatedAt.isUtc, isTrue);
    expect(limit.alertPercent, 80);
    expect(limit.alertAmount, 0);
    expect(repo.limits.length, 1);
  });

  test('повторное сохранение с тем же id обновляет запись', () async {
    final first = (await upsert(
      userId: 'u1',
      categoryId: 'c1',
      year: 2026,
      month: 7,
      limitAmount: 2000000,
    ) as Success<BudgetLimit>)
        .value;

    await upsert(
      id: first.id,
      userId: 'u1',
      categoryId: 'c1',
      year: 2026,
      month: 7,
      limitAmount: 3000000,
      alertPercent: 90,
      alertAmount: 50000,
    );

    expect(repo.limits.length, 1);
    expect(repo.limits.single.limitAmount, 3000000);
    expect(repo.limits.single.alertPercent, 90);
    expect(repo.limits.single.alertAmount, 50000);
  });

  test('семейный лимит сохраняет spaceId', () async {
    final result = await upsert(
      userId: 'u1',
      spaceId: 's1',
      categoryId: 'c1',
      year: 2026,
      month: 7,
      limitAmount: 1000000,
    );

    expect((result as Success<BudgetLimit>).value.spaceId, 's1');
  });

  test('удаление убирает лимит', () async {
    final limit = (await upsert(
      userId: 'u1',
      categoryId: 'c1',
      year: 2026,
      month: 7,
      limitAmount: 1000000,
    ) as Success<BudgetLimit>)
        .value;

    final result = await delete(limit.id);

    expect(result, isA<Success<void>>());
    expect(repo.limits, isEmpty);
  });

  test('ошибка репозитория при сохранении возвращается как Error', () async {
    repo.error = Exception('db down');

    final result = await upsert(
      userId: 'u1',
      categoryId: 'c1',
      year: 2026,
      month: 7,
      limitAmount: 1000000,
    );

    expect(result, isA<Error<BudgetLimit>>());
  });
}