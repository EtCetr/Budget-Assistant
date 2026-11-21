import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/utils/result.dart';
import 'package:budget_assistant/features/security/data/repositories/pin_code_repository.dart';
import 'package:budget_assistant/features/security/domain/usecases/set_pin_code_usecase.dart';
import 'package:budget_assistant/features/security/domain/usecases/verify_pin_code_usecase.dart';

class _MockPinRepo extends Mock implements PinCodeRepository {}

/// Этап 24: установка и проверка PIN (ТЗ 6.3.28).
/// Валидация до обращения к хранилищу; ошибки не летят наружу.
bool _isOk<T>(Result<T> r) =>
    r.when(success: (_) => true, failure: (_) => false);

void main() {
  late _MockPinRepo repo;
  late SetPinCodeUseCase setPin;
  late VerifyPinCodeUseCase verifyPin;

  setUp(() {
    repo = _MockPinRepo();
    setPin = SetPinCodeUseCase(repo);
    verifyPin = VerifyPinCodeUseCase(repo);
    when(() => repo.savePin(any()))
        .thenAnswer((_) async => Result.success(null));
    when(() => repo.verifyPin(any()))
        .thenAnswer((_) async => Result.success(true));
  });

  group('SetPinCodeUseCase', () {
    test('PIN короче 4 цифр отклоняется без записи', () async {
      final r = await setPin('123', '123');

      expect(_isOk(r), isFalse);
      verifyNever(() => repo.savePin(any()));
    });

    test('PIN длиннее 4 цифр отклоняется без записи', () async {
      final r = await setPin('12345', '12345');

      expect(_isOk(r), isFalse);
      verifyNever(() => repo.savePin(any()));
    });

    test('несовпадающее подтверждение отклоняется без записи', () async {
      final r = await setPin('5837', '5838');

      expect(_isOk(r), isFalse);
      verifyNever(() => repo.savePin(any()));
    });

    test('валидный PIN сохраняется', () async {
      final r = await setPin('5837', '5837');

      expect(_isOk(r), isTrue);
      verify(() => repo.savePin('5837')).called(1);
    });

    test('ошибка хранилища пробрасывается как Failure', () async {
      when(() => repo.savePin(any())).thenAnswer(
        (_) async => Result.failure(const Failure.validation('keystore')),
      );

      expect(_isOk(await setPin('5837', '5837')), isFalse);
    });

    test('исключение хранилища превращается в Failure', () async {
      when(() => repo.savePin(any())).thenThrow(Exception('keystore down'));

      expect(_isOk(await setPin('5837', '5837')), isFalse);
    });
  });

  group('VerifyPinCodeUseCase', () {
    test('верный PIN — успех с true', () async {
      final r = await verifyPin('5837');

      expect(_isOk(r), isTrue);
      expect(r.when(success: (v) => v, failure: (_) => false), isTrue);
      verify(() => repo.verifyPin('5837')).called(1);
    });

    test('неверный PIN — успех с false (не Failure)', () async {
      when(() => repo.verifyPin(any()))
          .thenAnswer((_) async => Result.success(false));

      final r = await verifyPin('0000');

      expect(_isOk(r), isTrue);
      expect(r.when(success: (v) => v, failure: (_) => true), isFalse);
    });

    test('ошибка хранилища пробрасывается как Failure', () async {
      when(() => repo.verifyPin(any())).thenAnswer(
        (_) async => Result.failure(const Failure.validation('keystore')),
      );

      expect(_isOk(await verifyPin('5837')), isFalse);
    });

    test('исключение хранилища превращается в Failure', () async {
      when(() => repo.verifyPin(any())).thenThrow(Exception('keystore down'));

      expect(_isOk(await verifyPin('5837')), isFalse);
    });
  });
}