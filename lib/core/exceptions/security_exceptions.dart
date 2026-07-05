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
  EncryptionException(String message, [dynamic cause]) : super(message, cause);
}

/// Ошибка дешифрования (неверный ключ, повреждённый Auth Tag, битый payload).
class DecryptionException extends SecurityException {
  DecryptionException(String message, [dynamic cause]) : super(message, cause);
}
