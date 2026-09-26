import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import '../../data/datasources/split_drafts_dao.dart';
import '../../data/repositories/split_drafts_repository_impl.dart';
import '../../domain/repositories/split_drafts_repository.dart';

final Logger _logger = Logger();

final splitDraftsDaoProvider = Provider<SplitDraftsDao>((ref) {
  return SplitDraftsDao(ref.watch(appDatabaseProvider));
});

final splitDraftsRepositoryProvider = Provider<SplitDraftsRepository>((ref) {
  return SplitDraftsRepositoryImpl(
    dao: ref.watch(splitDraftsDaoProvider),
    logger: _logger,
  );
});