import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/features/import/domain/usecases/detect_duplicates_usecase.dart';
import 'package:budget_assistant/features/import/domain/usecases/detect_transfers_usecase.dart';
import 'package:budget_assistant/features/import/domain/usecases/auto_categorize_usecase.dart';
import 'package:budget_assistant/features/import/domain/usecases/finalize_import_usecase.dart';
import 'package:budget_assistant/features/import/domain/usecases/check_secrecy_mode_usecase.dart';
import 'package:budget_assistant/features/import/domain/usecases/detect_gift_candidate_usecase.dart';
import 'package:budget_assistant/features/import/domain/usecases/build_secrecy_calendar_usecase.dart';

final _loggerProvider = Provider<Logger>((ref) {
  return Logger(printer: PrettyPrinter(methodCount: 2));
});

final detectDuplicatesUseCaseProvider = Provider<DetectDuplicatesUseCase>((ref) {
  return DetectDuplicatesUseCase(
    db: ref.watch(appDatabaseProvider),
    logger: ref.watch(_loggerProvider),
  );
});

final detectTransfersUseCaseProvider = Provider<DetectTransfersUseCase>((ref) {
  return DetectTransfersUseCase(
    db: ref.watch(appDatabaseProvider),
    logger: ref.watch(_loggerProvider),
  );
});

final autoCategorizeUseCaseProvider = Provider<AutoCategorizeUseCase>((ref) {
  return AutoCategorizeUseCase(
    db: ref.watch(appDatabaseProvider),
    logger: ref.watch(_loggerProvider),
  );
});

final finalizeImportUseCaseProvider = Provider<FinalizeImportUseCase>((ref) {
  return FinalizeImportUseCase(
    db: ref.watch(appDatabaseProvider),
    logger: ref.watch(_loggerProvider),
  );
});

final detectGiftCandidateUseCaseProvider = Provider<DetectGiftCandidateUseCase>((ref) {
  return DetectGiftCandidateUseCase(
    logger: ref.watch(_loggerProvider),
  );
});

final checkSecrecyModeUseCaseProvider = Provider<CheckSecrecyModeUseCase>((ref) {
  return CheckSecrecyModeUseCase(
    db: ref.watch(appDatabaseProvider),
    giftDetector: ref.watch(detectGiftCandidateUseCaseProvider),
    logger: ref.watch(_loggerProvider),
  );
});

final buildSecrecyCalendarUseCaseProvider = Provider<BuildSecrecyCalendarUseCase>((ref) {
  return BuildSecrecyCalendarUseCase(
    logger: ref.watch(_loggerProvider),
  );
});