import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
sealed class Failure with _$Failure {
  const factory Failure.database(String message, [StackTrace? stackTrace]) =
      DatabaseFailure;
  const factory Failure.network(String message, [StackTrace? stackTrace]) =
      NetworkFailure;
  const factory Failure.auth(String message, [StackTrace? stackTrace]) =
      AuthFailure;
  const factory Failure.unknown(String message, [StackTrace? stackTrace]) =
      UnknownFailure;
}
