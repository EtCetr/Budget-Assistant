import 'package:drift/drift.dart' show GeneratedDatabase;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:budget_assistant/core/services/encryption_service.dart';
import 'package:budget_assistant/core/services/secure_storage_service.dart';
import 'package:budget_assistant/features/sync/data/crypto/sync_payload_encryptor.dart';
import 'package:budget_assistant/features/sync/data/local/drift_sync_local_source.dart';
import 'package:budget_assistant/features/sync/data/remote/supabase_sync_gateway.dart';
import 'package:budget_assistant/features/sync/data/sync_table_spec.dart';
import 'package:budget_assistant/features/sync/domain/usecases/sync_pending_entities_use_case.dart';

final syncDatabaseProvider = Provider<GeneratedDatabase>(
  (ref) => throw StateError(
    'syncDatabaseProvider must be overridden with AppDatabase instance',
  ),
);

final supabaseSyncClientProvider = Provider<SupabaseClient>(
  (ref) => throw StateError(
    'supabaseSyncClientProvider must be overridden with SupabaseClient',
  ),
);

final syncStorageProvider = Provider<SecureStorageService>(
  (ref) => SecureStorageService(),
);

final syncLoggerProvider = Provider<Logger>((ref) => Logger());

final syncTableSpecsProvider = Provider<List<SyncTableSpec>>(
  (ref) => SyncTableSpec.defaultSpecs,
);

final encryptionServiceProvider = Provider<EncryptionService>(
  (ref) => EncryptionService(secureStorage: ref.watch(syncStorageProvider)),
);

final syncPayloadEncryptorProvider = Provider<SyncPayloadEncryptor>(
  (ref) => SyncPayloadEncryptor(
    encryptionService: ref.watch(encryptionServiceProvider),
  ),
);

final syncLocalSourceProvider = Provider<DriftSyncLocalSource>(
  (ref) => DriftSyncLocalSource(
    db: ref.watch(syncDatabaseProvider),
    logger: ref.watch(syncLoggerProvider),
  ),
);

final supabaseSyncGatewayProvider = Provider<SupabaseSyncGateway>(
  (ref) => SupabaseSyncGateway(client: ref.watch(supabaseSyncClientProvider)),
);

final syncPendingEntitiesUseCaseProvider = Provider<SyncPendingEntitiesUseCase>(
  (ref) => SyncPendingEntitiesUseCase(
    localSource: ref.watch(syncLocalSourceProvider),
    remoteGateway: ref.watch(supabaseSyncGatewayProvider),
    encryptor: ref.watch(syncPayloadEncryptorProvider),
    logger: ref.watch(syncLoggerProvider),
    specs: ref.watch(syncTableSpecsProvider),
  ),
);
