import 'package:budget_assistant/core/errors/failures.dart';

typedef Result<T> = ({T? data, Failure? failure});

extension ResultExtension<T> on Result<T> {
  bool get isSuccess => failure == null;
  bool get isError => failure != null;

  T get dataOrThrow {
    if (data != null) return data as T;
    throw failure!;
  }

  Result<R> map<R>(R Function(T data) transformer) {
    if (isSuccess) {
      try {
        return (data: transformer(data as T), failure: null);
      } catch (e, st) {
        return (
          data: null,
          failure: Failure.unexpected('Map transformation failed: $e', st),
        );
      }
    } else {
      return (data: null, failure: failure);
    }
  }
}
