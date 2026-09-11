// lib/core/utils/result.dart
import 'package:budget_assistant/core/errors/failures.dart';

abstract class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is FailureResult<T>;

  T get value {
    if (this is Success<T>) {
      return (this as Success<T>).value;
    }
    throw StateError('Cannot get value from Failure');
  }

  Failure get error {
    if (this is FailureResult<T>) {
      return (this as FailureResult<T>).failure;
    }
    throw StateError('Cannot get error from Success');
  }

  R when<R>({
    required R Function(T value) success,
    required R Function(Failure failure) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).value);
    }
    return failure((this as FailureResult<T>).failure);
  }

  R? whenOrNull<R>({
    R Function(T value)? success,
    R Function(Failure failure)? failure,
  }) {
    if (this is Success<T>) {
      return success != null ? success((this as Success<T>).value) : null;
    }
    return failure != null ? failure((this as FailureResult<T>).failure) : null;
  }

  Result<R> map<R>(R Function(T value) transform) {
    if (this is Success<T>) {
      try {
        return Result.success(transform((this as Success<T>).value));
      } catch (e, stackTrace) {
        return Result.failure(Failure.unexpected(e.toString(), stackTrace));
      }
    }
    return Result.failure((this as FailureResult<T>).failure);
  }

  Future<Result<R>> asyncMap<R>(Future<R> Function(T value) transform) async {
    if (this is Success<T>) {
      try {
        return Result.success(await transform((this as Success<T>).value));
      } catch (e, stackTrace) {
        return Result.failure(Failure.unexpected(e.toString(), stackTrace));
      }
    }
    return Result.failure((this as FailureResult<T>).failure);
  }

  static Result<T> success<T>(T value) => Success(value);
  static Result<T> failure<T>(Failure failure) => FailureResult(failure);
}

class Success<T> extends Result<T> {
  @override
  final T value;
  const Success(this.value);
}

class FailureResult<T> extends Result<T> {
  final Failure failure;
  const FailureResult(this.failure);
}
