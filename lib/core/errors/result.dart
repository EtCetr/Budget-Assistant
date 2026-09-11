import 'package:budget_assistant/core/errors/failures.dart';

/// Результат операции: либо успех со значением, либо ошибка с Failure.
/// Нельзя использовать нигде, кроме как через switch / помощники ниже.
sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isError => this is Error<T>;

  /// Значение, если успех. Иначе null.
  T? get valueOrNull => switch (this) {
    Success<T>(:final value) => value,
    Error<T>() => null,
  };

  /// Ошибка, если неудача. Иначе null.
  Failure? get failureOrNull => switch (this) {
    Success<T>() => null,
    Error<T>(:final failure) => failure,
  };

  /// «Развернуть» результат в одно из двух значений (удобно в провайдерах).
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onError,
  }) {
    return switch (this) {
      Success<T>(:final value) => onSuccess(value),
      Error<T>(:final failure) => onError(failure),
    };
  }
}

/// Успех: внутри лежит готовое значение.
final class Success<T> extends Result<T> {
  const Success(this.value);

  final T value;
}

/// Ошибка: внутри лежит описание причины (Failure).
/// ВАЖНО: имя Error перекрывает встроенный Error из dart:core.
/// Сейчас НЕ переименовываем, чтобы не трогать Этапы 1–6.
/// Переименуем в FailureResult отдельным микро-коммитом после Этапа 7
/// (глобальной заменой по проекту, вместе с l10n).
final class Error<T> extends Result<T> {
  const Error(this.failure);

  final Failure failure;
}
