import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:flutter/widgets.dart' show GlobalKey, WidgetsBinding;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:budget_assistant/core/services/secure_flag_service.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';
import 'package:budget_assistant/features/admin/domain/repositories/admin_repository.dart';
import 'package:budget_assistant/features/admin/domain/usecases/audit_log_usecases.dart';

/// Шеринг одного слайда: PNG через RepaintBoundary → временный файл →
/// системный Share Sheet → аудит-лог для семейной статистики (6.9.1.1 №6).
/// Временное снятие FLAG_SECURE на 5 секунд (6.3.37.10).
class ShareYearInReviewSlideUseCase {
  ShareYearInReviewSlideUseCase({
    required Logger logger,
    required SecureFlagService secureFlag,
    required AdminRepository adminRepository,
  })  : _logger = logger,
        _secureFlag = secureFlag,
        _audit = LogAuditActionUseCase(adminRepository);

  final Logger _logger;
  final SecureFlagService _secureFlag;
  final LogAuditActionUseCase _audit;

  Future<void> call({
    required int year,
    required int slideIndex,
    required String? spaceId,
    required String actorId,
    required GlobalKey boundaryKey,
    required bool screenCaptureProtection,
  }) async {
    // Контекст снимаем ДО первого await (защита от пересборки дерева).
    final ctx = boundaryKey.currentContext;
    if (ctx == null) throw StateError('Слайд ещё не отрисован');
    final renderObject = ctx.findRenderObject();
    if (renderObject is! RenderRepaintBoundary) {
      throw StateError('RepaintBoundary не найден в дереве');
    }
    var wasSecure = false;
    try {
      // 1. Временно снимаем FLAG_SECURE, иначе RepaintBoundary = чёрный кадр.
      if (screenCaptureProtection) {
        wasSecure =
            await _secureFlag.disableTemporarily(const Duration(seconds: 5));
      }
      // 2. Генерация PNG (pixelRatio 3 — как в экспорте Этапа 12.8).
      // Ждём конец кадра: тап по кнопке внутри слайда помечает слой
// как «нужна перерисовка», без этого toImage падает ассертом в debug.
renderObject.markNeedsPaint();
    await WidgetsBinding.instance.endOfFrame;
final image = await renderObject.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) throw StateError('Не удалось закодировать PNG');
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/year_in_review_${year}_slide_$slideIndex.png';
      await File(path).writeAsBytes(byteData.buffer.asUint8List());
      // 3. Системный Share Sheet.
      // ignore: deprecated_member_use
      await Share.shareXFiles(
        [XFile(path)],
        text: 'Мои финансовые итоги $year с Budget Assistant',
      );
      // 4. Аудит-лог для семейной статистики (6.9.7).
      if (spaceId != null) {
        await _audit(
          spaceId: spaceId,
          actorId: actorId,
          action: AuditAction.spaceDataExported,
          metadata: {
            'export_type': 'year_in_review',
            'year': year,
            'slide_index': slideIndex,
          },
        );
      }
    } catch (e, st) {
      _logger.e('ShareYearInReviewSlide failed', error: e, stackTrace: st);
      rethrow;
    } finally {
      if (wasSecure) {
        await _secureFlag.restore();
      }
    }
  }
}