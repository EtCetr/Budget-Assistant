/// Базовый класс для всех исключений, связанных с безопасностью и шифрованием.
class SecurityException implements Exception {
  final String message;
  final dynamic cause;

  SecurityException(this.message, [this.cause]);

  @override
  String toString() => 'SecurityException: $message';
}

/// Выбрасывается, если в SecureStorage отсутствует ключ для текущего пространства.
class MissingEncryptionKeyException extends SecurityException {
  MissingEncryptionKeyException(String spaceId)
    : super('Missing encryption key for space: $spaceId');
}

/// Ошибка процесса шифрования (например, сбой генерации IV).
class EncryptionException extends SecurityException {
  EncryptionException(
    super.message, [
    super.cause,
  ]); // <-- ИСПРАВЛЕНО: super parameters
}

/// Ошибка дешифрования (неверный ключ, повреждённый Auth Tag, битый payload).
class DecryptionException extends SecurityException {
  DecryptionException(
    super.message, [
    super.cause,
  ]); // <-- ИСПРАВЛЕНО: super parameters
}

/// Исключение: ключ шифрования был инвалидирован Android Keystore.
/// Например, пользователь добавил новый отпечаток или сменил PIN устройства.
/// Приложение должно удалить старый ключ и попросить пользователя создать новый.
class KeyInvalidatedException implements Exception {
  final String keyName;
  final String message;

  KeyInvalidatedException(this.keyName)
    : message =
          'Key "$keyName" was permanently invalidated by Android Keystore';

  @override
  String toString() => 'KeyInvalidatedException: $message';
}
