import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import '../../data/repositories/product_aliases_repository_impl.dart';
import '../../data/repositories/receipts_repository_impl.dart';
import '../../domain/repositories/product_aliases_repository.dart';
import '../../domain/repositories/receipts_repository.dart';
import '../../domain/usecases/find_or_create_product_alias_usecase.dart';
import '../../domain/usecases/hash_product_name_usecase.dart';
import '../../domain/usecases/match_receipt_to_transaction_usecase.dart';
import '../../domain/usecases/parse_fiscal_qr_usecase.dart';
import '../../domain/usecases/parse_receipt_text_usecase.dart';
import '../../domain/usecases/validate_receipt_form_usecase.dart';

part 'receipts_providers.g.dart';

@Riverpod(keepAlive: true)
ReceiptsRepository receiptsRepository(Ref ref) =>
    ReceiptsRepositoryImpl(db: ref.watch(appDatabaseProvider), logger: Logger());

@Riverpod(keepAlive: true)
ProductAliasesRepository productAliasesRepository(Ref ref) =>
    ProductAliasesRepositoryImpl(db: ref.watch(appDatabaseProvider), logger: Logger());

@riverpod
ParseFiscalQrUseCase parseFiscalQrUseCase(Ref ref) =>
    ParseFiscalQrUseCase(Logger());

@riverpod
ParseReceiptTextUseCase parseReceiptTextUseCase(Ref ref) =>
    ParseReceiptTextUseCase(Logger());

@riverpod
ValidateReceiptFormUseCase validateReceiptFormUseCase(Ref ref) =>
    ValidateReceiptFormUseCase();

@riverpod
MatchReceiptToTransactionUseCase matchReceiptToTransactionUseCase(Ref ref) =>
    MatchReceiptToTransactionUseCase();

@riverpod
HashProductNameUseCase hashProductNameUseCase(Ref ref) => HashProductNameUseCase();

@riverpod
FindOrCreateProductAliasUseCase findOrCreateProductAliasUseCase(Ref ref) =>
    FindOrCreateProductAliasUseCase(
      ref.watch(productAliasesRepositoryProvider),
      ref.watch(hashProductNameUseCaseProvider),
      Logger(),
    );