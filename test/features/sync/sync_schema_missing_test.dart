import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:budget_assistant/features/sync/data/crypto/sync_payload_encryptor.dart';
import 'package:budget_assistant/features/sync/data/local/drift_sync_local_source.dart';
import 'package:budget_assistant/features/sync/data/remote/supabase_sync_gateway.dart';
import 'package:budget_assistant/features/sync/data/sync_table_spec.dart';
import 'package:budget_assistant/features/sync/domain/errors/sync_exceptions.dart';
import 'package:budget_assistant/features/sync/domain/models/sync_models.dart';
import 'package:budget_assistant/features/sync/domain/usecases/sync_pending_entities_use_case.dart';

class _MockLocal extends Mock implements DriftSyncLocalSource {}

class _MockGateway extends Mock implements SupabaseSyncGateway {}

class _MockEncryptor extends Mock implements SyncPayloadEncryptor {}

/// Этап 24 (D24-12): нет таблицы в Supabase — синк выходит сразу,
/// без повторов и без обхода остальных сущностей.
void main() {
  late _MockLocal local;
  late _MockGateway gateway;
  late _MockEncryptor encryptor;
  late SyncPendingEntitiesUseCase useCase;

  setUpAll(() {
    registerFallbackValue(SyncTableSpec.accounts);
    registerFallbackValue(<String>[]);
  });

  setUp(() {
    local = _MockLocal();
    gateway = _MockGateway();
    encryptor = _MockEncryptor();
    useCase = SyncPendingEntitiesUseCase(
      localSource: local,
      remoteGateway: gateway,
      encryptor: encryptor,
      logger: Logger(level: Level.off),
      specs: SyncTableSpec.defaultSpecs,
    );

    when(() => local.fetchPending(any(), limit: any(named: 'limit')))
        .thenAnswer((_) async => [
              SyncPendingRow(
                id: 'r1',
                raw: const {'id': 'r1'},
                updatedAt: DateTime.utc(2026, 7, 15),
              ),
            ]);
  });

  test('отсутствующая таблица: один запрос и выход без повторов', () async {
    when(() => gateway.fetchRemoteRows(
          table: any(named: 'table'),
          ids: any(named: 'ids'),
        )).thenThrow(const RemoteSchemaMissingException('accounts'));

    final summary = await useCase.call(trigger: SyncTrigger.background);

    expect(summary.pushed, 0);
    verify(() => gateway.fetchRemoteRows(
          table: any(named: 'table'),
          ids: any(named: 'ids'),
        )).called(1);
    verifyNever(() => gateway.upsertRows(
          table: any(named: 'table'),
          rows: any(named: 'rows'),
        ));
  });

  test('обычная сетевая ошибка: повторы остаются', () async {
    when(() => gateway.fetchRemoteRows(
          table: any(named: 'table'),
          ids: any(named: 'ids'),
        )).thenThrow(Exception('timeout'));

    final summary = await useCase.call(trigger: SyncTrigger.background);

    expect(summary.pushed, 0);
    expect(summary.failed, greaterThan(0));
    // 3 попытки на каждую из 4 сущностей — поведение не сломано.
    verify(() => gateway.fetchRemoteRows(
          table: any(named: 'table'),
          ids: any(named: 'ids'),
        )).called(3 * SyncTableSpec.defaultSpecs.length);
  }, timeout: const Timeout(Duration(minutes: 2)));
}