import 'package:drift/drift.dart' show GeneratedDatabase;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:budget_assistant/core/services/secure_storage_service.dart';
import 'package:budget_assistant/features/sync/application/sync_providers.dart';
import 'package:budget_assistant/features/sync/domain/models/sync_models.dart';

/// Сервис синхронизации для UI.
class SyncService {
  SyncService({
    required this.db,
    required this.client,
    required this.storage,
    required this.logger,
  });

  final GeneratedDatabase db;
  final SupabaseClient client;
  final SecureStorageService storage;
  final Logger logger;

  /// Принудительная синхронизация (pull-to-refresh).
  Future<int> forceSyncNow() async {
    try {
      final container = ProviderContainer(
        overrides: [
          syncDatabaseProvider.overrideWithValue(db),
          supabaseSyncClientProvider.overrideWithValue(client),
          syncStorageProvider.overrideWithValue(storage),
          syncLoggerProvider.overrideWithValue(logger),
        ],
      );

      try {
        final useCase = container.read(syncPendingEntitiesUseCaseProvider);
        final summary = await useCase.call(trigger: SyncTrigger.pullToRefresh);

        return summary.pushed;
      } finally {
        container.dispose();
      }
    } catch (e, st) {
      logger.e('forceSyncNow failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}

final syncServiceProvider = Provider<SyncService>(
  (ref) => throw StateError(
    'syncServiceProvider must be overridden with SyncService instance',
  ),
);
