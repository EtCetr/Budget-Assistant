import 'package:cross_file/cross_file.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/usecases/create_draft_receipt_usecase.dart';
import '../../domain/usecases/save_receipt_image_usecase.dart';
import '../../domain/usecases/scan_receipt_ocr_usecase.dart';
import '../../domain/usecases/scan_receipt_qr_usecase.dart';
import 'receipts_providers.dart';

part 'scan_receipt_providers.g.dart';

/// 'qr' | 'ocr' | 'gallery'
@riverpod
class ScanMode extends _$ScanMode {
  @override
  String build() => 'qr';
  void set(String mode) => state = mode;
}

@riverpod
class GalleryImage extends _$GalleryImage {
  @override
  XFile? build() => null;
  void set(XFile? file) => state = file;
}

/// 'qr' | 'text'
@riverpod
class GalleryContentType extends _$GalleryContentType {
  @override
  String build() => 'qr';
  void set(String type) => state = type;
}

@riverpod
SaveReceiptImageUseCase saveReceiptImageUseCase(Ref ref) =>
    SaveReceiptImageUseCase(Logger());

@riverpod
CreateDraftReceiptUseCase createDraftReceiptUseCase(Ref ref) =>
    CreateDraftReceiptUseCase(
      repository: ref.watch(receiptsRepositoryProvider),
      logger: Logger(),
    );

@riverpod
ScanReceiptQrUseCase scanReceiptQrUseCase(Ref ref) => ScanReceiptQrUseCase(
      parseQr: ref.watch(parseFiscalQrUseCaseProvider),
      createDraft: ref.watch(createDraftReceiptUseCaseProvider),
      logger: Logger(),
    );

@riverpod
ScanReceiptOcrUseCase scanReceiptOcrUseCase(Ref ref) => ScanReceiptOcrUseCase(
      saveImage: ref.watch(saveReceiptImageUseCaseProvider),
      parseText: ref.watch(parseReceiptTextUseCaseProvider),
      createDraft: ref.watch(createDraftReceiptUseCaseProvider),
      logger: Logger(),
    );