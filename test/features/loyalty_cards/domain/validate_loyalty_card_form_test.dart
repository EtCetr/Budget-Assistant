import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/entities/loyalty_card.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/entities/loyalty_card_form_data.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/usecases/validate_loyalty_card_form_usecase.dart';

/// Этап 24: валидация формы карты (ТЗ 6.3.20.13).
/// EAN-13: веса 1/3 по первым 12 цифрам, check = (10 - sum % 10) % 10.
/// Валидный пример: 4006381333931 (sum = 89 -> check = 1).
LoyaltyCardFormData _form({
  String storeName = 'Пятёрочка',
  BarcodeType type = BarcodeType.manual,
  String data = '12345678',
  String? brandColor,
  String visibility = 'personal',
}) =>
    LoyaltyCardFormData(
      storeName: storeName,
      barcodeType: type,
      barcodeData: data,
      brandColor: brandColor,
      visibility: visibility,
    );

void main() {
  late ValidateLoyaltyCardFormUseCase useCase;

  setUp(() {
    useCase = ValidateLoyaltyCardFormUseCase(logger: Logger(level: Level.off));
  });

  group('isValidEan13', () {
    test('валидная контрольная сумма', () {
      expect(
        ValidateLoyaltyCardFormUseCase.isValidEan13('4006381333931'),
        isTrue,
      );
    });

    test('все нули формально валидны (sum = 0, check = 0)', () {
      expect(
        ValidateLoyaltyCardFormUseCase.isValidEan13('0000000000000'),
        isTrue,
      );
    });

    test('неверная контрольная цифра', () {
      expect(
        ValidateLoyaltyCardFormUseCase.isValidEan13('4006381333932'),
        isFalse,
      );
    });

    test('не 13 цифр', () {
      expect(
        ValidateLoyaltyCardFormUseCase.isValidEan13('400638133393'),
        isFalse,
      );
      expect(
        ValidateLoyaltyCardFormUseCase.isValidEan13('40063813339311'),
        isFalse,
      );
    });

    test('буквы и пустая строка', () {
      expect(
        ValidateLoyaltyCardFormUseCase.isValidEan13('400638133393A'),
        isFalse,
      );
      expect(ValidateLoyaltyCardFormUseCase.isValidEan13(''), isFalse);
    });
  });

  group('Валидация формы', () {
    Result<LoyaltyCardFormData> run(
      LoyaltyCardFormData form, {
      String? spaceId,
    }) =>
        useCase(form: form, currentSpaceId: spaceId);

    test('валидная форма с ручным номером проходит', () {
      expect(run(_form()), isA<Success<LoyaltyCardFormData>>());
    });

    test('пустое название магазина отклоняется', () {
      final r = run(_form(storeName: ''));

      expect(r, isA<Error<LoyaltyCardFormData>>());
      expect((r as Error<LoyaltyCardFormData>).failure, isA<ValidationFailure>());
    });

    test('название из пробелов отклоняется', () {
      expect(run(_form(storeName: '   ')), isA<Error<LoyaltyCardFormData>>());
    });

    test('название длиннее 50 символов отклоняется', () {
      expect(
        run(_form(storeName: 'А' * 51)),
        isA<Error<LoyaltyCardFormData>>(),
      );
    });

    test('название ровно 50 символов допустимо', () {
      expect(
        run(_form(storeName: 'А' * 50)),
        isA<Success<LoyaltyCardFormData>>(),
      );
    });

    test('EAN-13 с верной суммой проходит', () {
      expect(
        run(_form(type: BarcodeType.ean13, data: '4006381333931')),
        isA<Success<LoyaltyCardFormData>>(),
      );
    });

    test('EAN-13 с битой контрольной суммой отклоняется', () {
      expect(
        run(_form(type: BarcodeType.ean13, data: '4006381333932')),
        isA<Error<LoyaltyCardFormData>>(),
      );
    });

    test('EAN-13 без данных отклоняется', () {
      expect(
        run(_form(type: BarcodeType.ean13, data: '')),
        isA<Error<LoyaltyCardFormData>>(),
      );
    });

    test('Code 128: буквы и цифры допустимы', () {
      expect(
        run(_form(type: BarcodeType.code128, data: 'ABC123')),
        isA<Success<LoyaltyCardFormData>>(),
      );
    });

    test('Code 128: кириллица отклоняется', () {
      expect(
        run(_form(type: BarcodeType.code128, data: 'АБВ123')),
        isA<Error<LoyaltyCardFormData>>(),
      );
    });

    test('Code 128: длиннее 80 символов отклоняется', () {
      expect(
        run(_form(type: BarcodeType.code128, data: 'A' * 81)),
        isA<Error<LoyaltyCardFormData>>(),
      );
    });

    test('QR: граница 500 символов и пустые данные', () {
      expect(
        run(_form(type: BarcodeType.qr, data: 'x' * 500)),
        isA<Success<LoyaltyCardFormData>>(),
      );
      expect(
        run(_form(type: BarcodeType.qr, data: 'x' * 501)),
        isA<Error<LoyaltyCardFormData>>(),
      );
      expect(
        run(_form(type: BarcodeType.qr, data: '')),
        isA<Error<LoyaltyCardFormData>>(),
      );
    });

    test('PDF417: граница 1000 символов', () {
      expect(
        run(_form(type: BarcodeType.pdf417, data: 'x' * 1000)),
        isA<Success<LoyaltyCardFormData>>(),
      );
      expect(
        run(_form(type: BarcodeType.pdf417, data: 'x' * 1001)),
        isA<Error<LoyaltyCardFormData>>(),
      );
    });

    test('ручной номер короче 4 цифр отклоняется', () {
      expect(
        run(_form(data: '123')),
        isA<Error<LoyaltyCardFormData>>(),
      );
    });

    test('ручной номер длиннее 32 цифр отклоняется', () {
      expect(
        run(_form(data: '1' * 33)),
        isA<Error<LoyaltyCardFormData>>(),
      );
    });

    test('цвет бренда в неверном формате отклоняется', () {
      expect(
        run(_form(brandColor: '#GG0000')),
        isA<Error<LoyaltyCardFormData>>(),
      );
      expect(
        run(_form(brandColor: 'FF0000')),
        isA<Error<LoyaltyCardFormData>>(),
      );
    });

    test('цвет бренда #RRGGBB в любом регистре допустим', () {
      expect(
        run(_form(brandColor: '#ff00AA')),
        isA<Success<LoyaltyCardFormData>>(),
      );
    });

    test('семейная карта без активного пространства отклоняется', () {
      expect(
        run(_form(visibility: 'family')),
        isA<Error<LoyaltyCardFormData>>(),
      );
    });

    test('семейная карта с пространством проходит', () {
      expect(
        run(_form(visibility: 'family'), spaceId: 's1'),
        isA<Success<LoyaltyCardFormData>>(),
      );
    });
  });
}