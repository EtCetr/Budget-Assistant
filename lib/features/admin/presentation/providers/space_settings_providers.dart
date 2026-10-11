import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/features/admin/domain/usecases/space_settings_usecases.dart';
import 'package:budget_assistant/features/admin/presentation/providers/admin_providers.dart';

/// Строка пространства (identity + лимит) для экрана настроек.
final spaceSettingsRowProvider = StreamProvider<SpaceSettingsRow?>((ref) {
  final scope = ref.watch(adminScopeProvider);
  if (scope == null) {
    return const Stream.empty();
  }
  return ref.watch(adminRepositoryProvider).watchSpaceSettings(scope.spaceId);
});

/// Статистика 2x2 (счета / транзакции / семейный баланс).
final spaceStatsRowProvider = StreamProvider<SpaceStatsRow>((ref) {
  final scope = ref.watch(adminScopeProvider);
  if (scope == null) {
    return const Stream.empty();
  }
  return ref.watch(adminRepositoryProvider).watchSpaceStats(scope.spaceId);
});

final updateSpaceIdentityUseCaseProvider = Provider<UpdateSpaceIdentityUseCase>(
  (ref) => UpdateSpaceIdentityUseCase(ref.watch(adminRepositoryProvider)),
);
final updateSpaceBudgetLimitUseCaseProvider =
    Provider<UpdateSpaceBudgetLimitUseCase>(
  (ref) => UpdateSpaceBudgetLimitUseCase(ref.watch(adminRepositoryProvider)),
);
final exportSpaceDataUseCaseProvider = Provider<ExportSpaceDataUseCase>(
  (ref) => ExportSpaceDataUseCase(ref.watch(adminRepositoryProvider)),
);