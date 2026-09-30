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
/// Для CSV/XLSX читает первые 10 строк. Для PDF — возвращает пустой список
/// (детект по бинарному PDF ненадёжен, пользователь выберет вручную).
class DetectBankFromFileUseCase {
  final Logger _logger;

  DetectBankFromFileUseCase({required Logger logger}) : _logger = logger;

  Future<List<DetectedBank>> call({
    required String filePath,
    required List<ParserConfig> configs,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return const [];

      final ext = filePath.split('.').last.toLowerCase();

      // PDF — бинарный формат, readAsLines упадёт. Пропускаем детект.
      if (ext == 'pdf') {
        _logger.i('DetectBank: PDF — детект пропущен (пользователь выберет вручную)');
        return const [];
      }

      // XLSX — тоже бинарный (OOXML-zip). Пропускаем.
      if (ext == 'xlsx') {
        _logger.i('DetectBank: XLSX — детект пропущен');
        return const [];
      }

      // CSV — читаем первые 10 строк
      String sample;
      try {
        final lines = await file.readAsLines(encoding: utf8);
        if (lines.isEmpty) return const [];
        sample = lines.take(10).join('\n').toLowerCase();
      } catch (e) {
        // Fallback: windows-1251
        try {
          final bytes = await file.readAsBytes();
          final decoded = _decodeWindows1251(bytes);
          final lines = decoded.split('\n');
          sample = lines.take(10).join('\n').toLowerCase();
        } catch (e2) {
          _logger.w('DetectBank: не удалось прочитать файл: $e2');
          return const [];
        }
      }

      final candidates = <DetectedBank>[];

      for (final config in configs) {
        final patterns = _parseDetectionPatterns(config.detectionPatterns);
        if (patterns == null) continue;

        var score = 0.0;
        var maxScore = 0.0;

        if (patterns.keywords != null && patterns.keywords!.isNotEmpty) {
          maxScore += patterns.keywords!.length;
          for (final keyword in patterns.keywords!) {
            if (sample.contains(keyword.toLowerCase())) {
              score += 1.0;
            }
          }
        }

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

  /// Минимальный декодер windows-1251 для банковских CSV.
  String _decodeWindows1251(List<int> bytes) {
    final buffer = StringBuffer();
    for (final byte in bytes) {
      if (byte < 128) {
        buffer.writeCharCode(byte);
      } else if (byte >= 192 && byte <= 255) {
        buffer.writeCharCode(byte + 848);
      } else if (byte == 168) {
        buffer.writeCharCode(1025);
      } else if (byte == 184) {
        buffer.writeCharCode(1105);
      } else {
        buffer.writeCharCode(byte);
      }
    }
    return buffer.toString();
  }
}

class _DetectionPatterns {
  const _DetectionPatterns({this.keywords, this.headers});
  final List<String>? keywords;
  final List<String>? headers;
}