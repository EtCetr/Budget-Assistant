import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Копирует фото чека в documents/receipts/{receiptId}.jpg (локально, без sync).
class SaveReceiptImageUseCase {
  final Logger _logger;
  SaveReceiptImageUseCase(this._logger);

  Future<String?> call(String sourcePath, String receiptId) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final receiptsDir = Directory(p.join(dir.path, 'receipts'));
      if (!await receiptsDir.exists()) {
        await receiptsDir.create(recursive: true);
      }
      final dest = p.join(receiptsDir.path, '$receiptId.jpg');
      await File(sourcePath).copy(dest);
      return dest;
    } catch (e, st) {
      _logger.e('SaveReceiptImage failed', error: e, stackTrace: st);
      return null;
    }
  }
}