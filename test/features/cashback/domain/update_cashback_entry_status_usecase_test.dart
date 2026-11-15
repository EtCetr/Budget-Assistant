import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/features/cashback/domain/usecases/update_cashback_entry_status_usecase.dart';
import '../../../helpers/fake_cashback_repository.dart';

/// Этап 24: ручная смена статуса кэшбэка potential <-> approved.
void main() {
  late FakeCashbackRepository repo;
  late UpdateCashbackEntryStatusUseCase useCase;

  setUp(() {
    repo = FakeCashbackRepository();
    useCase = UpdateCashbackEntryStatusUseCase(
      repository: repo,
      logger: Logger(level: Level.off),
    );
  });

  test('approved принимается и доходит до репозитория', () async {
    final result = await useCase(entryId: 'e1', status: 'approved');

    expect(result, isA<Success<void>>());
    expect(repo.statusUpdates, [(id: 'e1', status: 'approved')]);
  });

  test('potential принимается', () async {
    final result = await useCase(entryId: 'e1', status: 'potential');

    expect(result, isA<Success<void>>());
    expect(repo.statusUpdates.single.status, 'potential');
  });

  test('неизвестный статус отклоняется без записи', () async {
    final result = await useCase(entryId: 'e1', status: 'confirmed');

    expect(result, isA<Error<void>>());
    expect((result as Error<void>).failure, isA<ValidationFailure>());
    expect(repo.statusUpdates, isEmpty);
  });

  test('ошибка репозитория возвращается как DatabaseFailure', () async {
    repo.error = Exception('db down');

    final result = await useCase(entryId: 'e1', status: 'approved');

    expect(result, isA<Error<void>>());
    expect((result as Error<void>).failure, isA<DatabaseFailure>());
  });
}