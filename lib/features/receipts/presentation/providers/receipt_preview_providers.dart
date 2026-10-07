import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:budget_assistant/core/providers/security_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../../domain/dtos/receipt_bundle.dart';
import '../../domain/dtos/receipt_category_lookup.dart';
import '../../domain/dtos/receipt_match_result.dart';
import '../../domain/dtos/receipt_offer_settings.dart';
import '../../domain/usecases/confirm_receipt_usecase.dart';
import '../../domain/usecases/link_receipt_to_transaction_usecase.dart';
import '../../domain/usecases/match_receipt_usecase.dart';
import '../../domain/usecases/record_naming_decision_usecase.dart';
import 'receipts_providers.dart';

part 'receipt_preview_providers.g.dart';

@riverpod
MatchReceiptUseCase matchReceiptUseCase(Ref ref) => MatchReceiptUseCase(
      repo: ref.watch(receiptsRepositoryProvider),
      matcher: ref.watch(matchReceiptToTransactionUseCaseProvider),
    );

@riverpod
LinkReceiptToTransactionUseCase linkReceiptToTransactionUseCase(Ref ref) =>
    LinkReceiptToTransactionUseCase(
      repo: ref.watch(receiptsRepositoryProvider),
      logger: Logger(),
    );

@riverpod
ConfirmReceiptUseCase confirmReceiptUseCase(Ref ref) => ConfirmReceiptUseCase(
      repo: ref.watch(receiptsRepositoryProvider),
      validate: ref.watch(validateReceiptFormUseCaseProvider),
      logger: Logger(),
    );

@riverpod
RecordNamingDecisionUseCase recordNamingDecisionUseCase(Ref ref) =>
    RecordNamingDecisionUseCase(
      repo: ref.watch(receiptsRepositoryProvider),
      logger: Logger(),
    );

/// Чек + позиции.
@riverpod
Future<ReceiptBundle?> receiptBundle(Ref ref, String receiptId) async {
  final repo = ref.watch(receiptsRepositoryProvider);
  final receipt = await repo.getReceiptById(receiptId);
  if (receipt == null) return null;
  final items = await repo.getItemsByReceiptId(receiptId);
  return ReceiptBundle(receipt: receipt, items: items);
}

/// Результат матчинга для чека.
@riverpod
Future<ReceiptMatchResult?> receiptMatchResult(
  Ref ref,
  String receiptId,
) async {
  final repo = ref.watch(receiptsRepositoryProvider);
  final receipt = await repo.getReceiptById(receiptId);
  if (receipt == null) return null;
  return ref.watch(matchReceiptUseCaseProvider)(
    totalKop: receipt.totalAmount,
    dateUtc: receipt.receiptDate,
  );
}

/// Категории expense для dropdown позиций.
@riverpod
Future<List<ReceiptCategoryLookup>> receiptCategories(Ref ref) =>
    ref.watch(receiptsRepositoryProvider).getExpenseCategories(
          spaceId: ref.watch(currentSpaceIdProvider),
        );

/// Настройки (счётчики спама).
@riverpod
Future<ReceiptOfferSettings> receiptSettings(Ref ref) =>
    ref.watch(receiptsRepositoryProvider).getReceiptOfferSettings(
          ref.watch(currentUserIdProvider),
        );