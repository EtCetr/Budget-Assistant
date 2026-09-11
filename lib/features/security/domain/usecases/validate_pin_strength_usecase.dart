import 'package:budget_assistant/core/errors/failures.dart';

class PinValidationResult {
  final bool isValid;
  final String? errorMessage;

  const PinValidationResult({required this.isValid, this.errorMessage});
}

class ValidatePinStrengthUseCase {
  PinValidationResult call(String pin) {
    try {
      if (pin.length != 4) {
        return const PinValidationResult(
          isValid: false,
          errorMessage: 'PIN должен содержать 4 цифры',
        );
      }

      // 1. Все одинаковые цифры (1111, 2222, ...)
      if (pin.split('').toSet().length == 1) {
        return const PinValidationResult(
          isValid: false,
          errorMessage: 'Слишком простой PIN. Все цифры одинаковые',
        );
      }

      // 2. Последовательность (1234, 2345, 4321, ...)
      final digits = pin.split('').map(int.parse).toList();
      var isAscending = true;
      var isDescending = true;

      for (var i = 1; i < digits.length; i++) {
        if (digits[i] != digits[i - 1] + 1) isAscending = false;
        if (digits[i] != digits[i - 1] - 1) isDescending = false;
      }

      if (isAscending || isDescending) {
        return const PinValidationResult(
          isValid: false,
          errorMessage: 'Слишком простой PIN. Последовательность цифр',
        );
      }

      // 3. Год рождения (19xx, 20xx)
      if (pin.startsWith('19') || pin.startsWith('20')) {
        return const PinValidationResult(
          isValid: false,
          errorMessage: 'Не используйте год рождения как PIN',
        );
      }

      // 4. Популярные комбинации
      const weakPins = {
        '0000',
        '1234',
        '4321',
        '1111',
        '2222',
        '3333',
        '4444',
        '5555',
        '6666',
        '7777',
        '8888',
        '9999',
        '1212',
        '1004',
      };

      if (weakPins.contains(pin)) {
        return const PinValidationResult(
          isValid: false,
          errorMessage: 'Этот PIN слишком распространён',
        );
      }

      return const PinValidationResult(isValid: true);
    } catch (e, st) {
      throw Failure.unexpected('PIN validation failed: $e', st);
    }
  }
}
