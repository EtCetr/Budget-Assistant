import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:budget_assistant/features/year_budget/domain/models/year_budget_models.dart';
import 'package:budget_assistant/features/year_budget/domain/repositories/year_budget_repository.dart';
import 'package:budget_assistant/features/year_budget/domain/usecases/save_month_budget_usecase.dart';

class _MockRepo extends Mock implements YearBudgetRepository {}

/// Этап 24: SaveMonthBudgetUseCase — тонкая обёртка над репозиторием.
/// Аргументы проверяем точными значениями: порядок captureAny в mocktail
/// не совпадает с порядком объявления именованных параметров.
void main() {
  late _MockRepo repo;
  late SaveMonthBudgetUseCase useCase;

  const personalKey = MonthStatsKey(year: 2026, month: 7);
  const familyKey = MonthStatsKey(year: 2026, month: 7, spaceId: 'space-1');

  setUp(() {
    repo = _MockRepo();
    useCase = SaveMonthBudgetUseCase(
      repository: repo,
      logger: Logger(level: Level.off),
    );

    when(
      () => repo.saveAllocated(
        userId: any(named: 'userId'),
        spaceId: any(named: 'spaceId'),
        year: any(named: 'year'),
        month: any(named: 'month'),
        kopecks: any(named: 'kopecks'),
      ),
    ).thenAnswer((_) async {});

    when(
      () => repo.saveLimit(
        userId: any(named: 'userId'),
        spaceId: any(named: 'spaceId'),
        year: any(named: 'year'),
        month: any(named: 'month'),
        categoryId: any(named: 'categoryId'),
        kopecks: any(named: 'kopecks'),
      ),
    ).thenAnswer((_) async {});

    when(
      () => repo.carryOver(
        userId: any(named: 'userId'),
        spaceId: any(named: 'spaceId'),
        fromYear: any(named: 'fromYear'),
        fromMonth: any(named: 'fromMonth'),
        toYear: any(named: 'toYear'),
        toMonth: any(named: 'toMonth'),
      ),
    ).thenAnswer((_) async => 3);
  });

  test('saveAllocated пробрасывает семейный ключ и сумму в копейках', () async {
    await useCase.saveAllocated(
      userId: 'user-1',
      key: familyKey,
      kopecks: 15000000,
    );

    verify(
      () => repo.saveAllocated(
        userId: 'user-1',
        spaceId: 'space-1',
        year: 2026,
        month: 7,
        kopecks: 15000000,
      ),
    ).called(1);
  });

  test('saveAllocated для личного скоупа передаёт spaceId = null', () async {
    await useCase.saveAllocated(
      userId: 'user-1',
      key: personalKey,
      kopecks: 1,
    );

    verify(
      () => repo.saveAllocated(
        userId: 'user-1',
        spaceId: null,
        year: 2026,
        month: 7,
        kopecks: 1,
      ),
    ).called(1);
  });

  test('saveLimit пробрасывает категорию и сумму', () async {
    await useCase.saveLimit(
      userId: 'user-1',
      key: personalKey,
      categoryId: 'c1',
      kopecks: 2000000,
    );

    verify(
      () => repo.saveLimit(
        userId: 'user-1',
        spaceId: null,
        year: 2026,
        month: 7,
        categoryId: 'c1',
        kopecks: 2000000,
      ),
    ).called(1);
  });

  test('carryOver пробрасывает откуда и куда, возвращает счётчик', () async {
    final copied = await useCase.carryOver(
      userId: 'user-1',
      key: familyKey,
      fromYear: 2026,
      fromMonth: 6,
    );

    expect(copied, 3);
    verify(
      () => repo.carryOver(
        userId: 'user-1',
        spaceId: 'space-1',
        fromYear: 2026,
        fromMonth: 6,
        toYear: 2026,
        toMonth: 7,
      ),
    ).called(1);
  });

  test('saveAllocated: ошибка логируется и пробрасывается', () async {
    when(
      () => repo.saveAllocated(
        userId: any(named: 'userId'),
        spaceId: any(named: 'spaceId'),
        year: any(named: 'year'),
        month: any(named: 'month'),
        kopecks: any(named: 'kopecks'),
      ),
    ).thenThrow(Exception('db down'));

    await expectLater(
      useCase.saveAllocated(userId: 'user-1', key: personalKey, kopecks: 1),
      throwsA(isA<Exception>()),
    );
  });

  test('saveLimit: ошибка логируется и пробрасывается', () async {
    when(
      () => repo.saveLimit(
        userId: any(named: 'userId'),
        spaceId: any(named: 'spaceId'),
        year: any(named: 'year'),
        month: any(named: 'month'),
        categoryId: any(named: 'categoryId'),
        kopecks: any(named: 'kopecks'),
      ),
    ).thenThrow(Exception('db down'));

    await expectLater(
      useCase.saveLimit(
        userId: 'user-1',
        key: personalKey,
        categoryId: 'c1',
        kopecks: 1,
      ),
      throwsA(isA<Exception>()),
    );
  });

  test('carryOver: ошибка логируется и пробрасывается', () async {
    when(
      () => repo.carryOver(
        userId: any(named: 'userId'),
        spaceId: any(named: 'spaceId'),
        fromYear: any(named: 'fromYear'),
        fromMonth: any(named: 'fromMonth'),
        toYear: any(named: 'toYear'),
        toMonth: any(named: 'toMonth'),
      ),
    ).thenThrow(Exception('db down'));

    await expectLater(
      useCase.carryOver(
        userId: 'user-1',
        key: personalKey,
        fromYear: 2026,
        fromMonth: 6,
      ),
      throwsA(isA<Exception>()),
    );
  });
}