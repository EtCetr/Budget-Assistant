import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/entities/loyalty_card.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/usecases/auto_detect_barcode_type_usecase.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/usecases/format_card_number_for_display_usecase.dart';

/// Этап 24: автоопределение типа кода (фолбэк ручного ввода, ТЗ 6.3.20.13)
/// и группировка номера по 4 цифры для экрана кассира (ТЗ 6.3.21.6).
void main() {
  late Logger logger;

  setUp(() {
    logger = Logger(level: Level.off);
  });

  group('AutoDetectBarcodeTypeUseCase', () {
    late AutoDetectBarcodeTypeUseCase useCase;

    setUp(() {
      useCase = AutoDetectBarcodeTypeUseCase(logger: logger);
    });

    test('валидный EAN-13 определяется первым', () {
      expect(useCase('4006381333931'), BarcodeType.ean13);
    });

    test('буквы с цифрами — Code 128', () {
      expect(useCase('ABC123'), BarcodeType.code128);
    });

    test('чистые цифры 4-32 без валидного EAN-13 — ручной номер', () {
      expect(useCase('12345678'), BarcodeType.manual);
    });

    test('короткие цифры (3) не подходят под ручной номер — QR', () {
      // Документируем фактический порядок правил: 4-32 не совпало,
      // длина <= 500 -> qr.
      expect(useCase('123'), BarcodeType.qr);
    });

    test('строка длиннее 500 символов — ручной ввод', () {
      expect(useCase('a' * 501), BarcodeType.manual);
    });

    test('пустая строка — QR (длина 0 <= 500)', () {
      expect(useCase(''), BarcodeType.qr);
    });

    test('пробелы по краям обрезаются перед детектом', () {
      expect(useCase('  4006381333931  '), BarcodeType.ean13);
    });
  });

  group('FormatCardNumberForDisplayUseCase', () {
    late FormatCardNumberForDisplayUseCase useCase;

    setUp(() {
      useCase = FormatCardNumberForDisplayUseCase(logger: logger);
    });

    test('номер группируется по 4 цифры', () {
      expect(useCase('1234567890123'), '1234 5678 9012 3');
    });

    test('не-цифры удаляются перед группировкой', () {
      expect(useCase('1234-5678 9012'), '1234 5678 9012');
    });

    test('ровно 8 цифр — две группы без хвоста', () {
      expect(useCase('12345678'), '1234 5678');
    });

    test('пустая строка и строка без цифр дают пустой результат', () {
      expect(useCase(''), '');
      expect(useCase('abcd'), '');
    });
  });
}