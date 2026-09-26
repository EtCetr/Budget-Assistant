import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import '../../data/datasources/app_settings_split_offer_source.dart';
import '../../domain/services/split_offer_settings_port.dart';
import '../../domain/usecases/create_transaction_split_usecase.dart';
import '../../domain/usecases/update_split_offer_count_usecase.dart';
import '../../domain/usecases/validate_split_form_usecase.dart';
import 'create_transaction_providers.dart';
import 'split_drafts_providers.dart';

final Logger _logger = Logger();

final splitOfferSettingsPortProvider =
    Provider<SplitOfferSettingsPort>((ref) {
  return AppSettingsSplitOfferSource(
    dao: ref.watch(appSettingsDaoProvider),
    logger: _logger,
  );
});

final validateSplitFormUseCaseProvider =
    Provider<ValidateSplitFormUseCase>((ref) {
  return ValidateSplitFormUseCase();
});

final createTransactionSplitUseCaseProvider =
    Provider<CreateTransactionSplitUseCase>((ref) {
  return CreateTransactionSplitUseCase(
    repository: ref.watch(transactionsRepositoryProvider),
    drafts: ref.watch(splitDraftsRepositoryProvider),
    logger: _logger,
  );
});

final updateSplitOfferCountUseCaseProvider =
    Provider<UpdateSplitOfferCountUseCase>((ref) {
  return UpdateSplitOfferCountUseCase(
    settings: ref.watch(splitOfferSettingsPortProvider),
    logger: _logger,
  );
});