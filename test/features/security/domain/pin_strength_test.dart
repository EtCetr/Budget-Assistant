import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/features/security/domain/usecases/validate_pin_strength_usecase.dart';

/// Этап 24: стойкость PIN (ТЗ 6.3.28). 4 цифры, без простых комбинаций.
void main() {
  late ValidatePinStrengthUseCase useCase;

  setUp(() {
    useCase = ValidatePinStrengthUseCase();
  });

  test('короче 4 цифр отклоняется', () {
    final r = useCase('123');
    expect(r.isValid, isFalse);
    expect(r.errorMessage, contains('4 цифры'));
  });

  test('длиннее 4 цифр отклоняется', () {
    expect(useCase('12345').isValid, isFalse);
  });

  test('все одинаковые цифры отклоняются', () {
    final r = useCase('7777');
    expect(r.isValid, isFalse);
    expect(r.errorMessage, contains('одинаковые'));
  });

  test('возрастающая последовательность отклоняется', () {
    final r = useCase('5678');
    expect(r.isValid, isFalse);
    expect(r.errorMessage, contains('Последовательность'));
  });

  test('убывающая последовательность отклоняется', () {
    expect(useCase('4321').isValid, isFalse);
  });

  test('год рождения отклоняется (19xx и 20xx)', () {
    expect(useCase('1985').errorMessage, contains('год рождения'));
    expect(useCase('2024').errorMessage, contains('год рождения'));
  });

  test('популярные комбинации отклоняются', () {
    expect(useCase('1212').errorMessage, contains('распространён'));
    expect(useCase('1004').errorMessage, contains('распространён'));
  });

  test('стойкий PIN проходит', () {
    final r = useCase('5837');
    expect(r.isValid, isTrue);
    expect(r.errorMessage, isNull);
  });

  test('пустая строка отклоняется без исключения', () {
    expect(useCase('').isValid, isFalse);
  });
}