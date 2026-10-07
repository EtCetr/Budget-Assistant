import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/usecases/split_receipt_usecase.dart';
import 'receipts_providers.dart';

part 'split_receipt_providers.g.dart';

@riverpod
SplitReceiptUseCase splitReceiptUseCase(Ref ref) => SplitReceiptUseCase(
      repo: ref.watch(receiptsRepositoryProvider),
      logger: Logger(),
    );