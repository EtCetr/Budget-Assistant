import 'dart:convert';
import 'dart:io';
import 'package:logger/logger.dart';
import '../entities/parser_config.dart';

/// Результат детекта банка.
class DetectedBank {
  const DetectedBank({
    required this.bankCode,
    required this.bankName,
    required this.confidence,
  });

  final String bankCode;
  final String bankName;
  final double confidence;
}

/// Автоопределение банка по первым строкам файла (ТЗ 6.3.25.13).
/// Анализирует заголовки и ключевые слова.
class DetectBankFromFileUseCase {
  final Logger _logger;

  DetectBankFromFileUseCase({required Logger logger}) : _logger = logger;

  /// Возвращает список кандидатов отсортированных по confidence.
  Future<List<DetectedBank>> call({
    required String filePath,
    required List<ParserConfig> configs,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return const [];

      final lines = await file.readAsLines();
      if (lines.isEmpty) return const [];

      // Берём первые 10 строк для анализа
      final sample = lines.take(10).join('\n').toLowerCase();
      final candidates = <DetectedBank>[];

      for (final config in configs) {
        final patterns = _parseDetectionPatterns(config.detectionPatterns);
        if (patterns == null) continue;

        var score = 0.0;
        var maxScore = 0.0;

        // Проверяем keywords
        if (patterns.keywords != null && patterns.keywords!.isNotEmpty) {
          maxScore += patterns.keywords!.length;
          for (final keyword in patterns.keywords!) {
            if (sample.contains(keyword.toLowerCase())) {
              score += 1.0;
            }
          }
        }

        // Проверяем headers
        if (patterns.headers != null && patterns.headers!.isNotEmpty) {
          maxScore += patterns.headers!.length;
          for (final header in patterns.headers!) {
            if (sample.contains(header.toLowerCase())) {
              score += 1.0;
            }
          }
        }

        if (maxScore > 0) {
          final confidence = score / maxScore;
          if (confidence > 0.3) {
            candidates.add(DetectedBank(
              bankCode: config.bankCode,
              bankName: config.bankName,
              confidence: confidence,
            ));
          }
        }
      }

      // Сортируем по confidence
      candidates.sort((a, b) => b.confidence.compareTo(a.confidence));

      _logger.i('DetectBank: найдено ${candidates.length} кандидатов');
      return candidates;
    } catch (e, st) {
      _logger.e('DetectBankFromFileUseCase failed', error: e, stackTrace: st);
      return const [];
    }
  }

  _DetectionPatterns? _parseDetectionPatterns(String? json) {
    if (json == null || json.isEmpty) return null;
    try {
      final decoded = jsonDecode(json);
      if (decoded is Map<String, dynamic>) {
        return _DetectionPatterns(
          keywords: (decoded['keywords'] as List<dynamic>?)?.cast<String>(),
          headers: (decoded['headers'] as List<dynamic>?)?.cast<String>(),
        );
      }
    } catch (_) {}
    return null;
  }
}

class _DetectionPatterns {
  const _DetectionPatterns({this.keywords, this.headers});
  final List<String>? keywords;
  final List<String>? headers;
}