import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import '../../domain/usecases/set_personal_share_usecase.dart';
import 'space_providers.dart';

final setPersonalShareUseCaseProvider = Provider<SetPersonalShareUseCase>(
  (ref) => SetPersonalShareUseCase(
    db: ref.watch(appDatabaseProvider),
    attach: ref.watch(attachPersonalTransactionsUseCaseProvider),
    logger: Logger(),
  ),
);

/// Ключ: 'userId|spaceId'.
final personalShareFlagProvider =
    FutureProvider.autoDispose.family<bool, String>((ref, key) async {
  final parts = key.split('|');
  if (parts.length != 2) return false;
  return ref
      .watch(setPersonalShareUseCaseProvider)
      .isEnabled(userId: parts[0], spaceId: parts[1]);
});