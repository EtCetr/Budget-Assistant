import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
abstract class Failure with _$Failure {
  const factory Failure.network(String message, [StackTrace? stackTrace]) =
      NetworkFailure;
  const factory Failure.server(String message, [StackTrace? stackTrace]) =
      ServerFailure;
  const factory Failure.authentication(
    String message, [
    StackTrace? stackTrace,
  ]) = AuthenticationFailure;
  const factory Failure.authorization(
    String message, [
    StackTrace? stackTrace,
  ]) = AuthorizationFailure;
  const factory Failure.validation(String message, [StackTrace? stackTrace]) =
      ValidationFailure;
  const factory Failure.notFound(String message, [StackTrace? stackTrace]) =
      NotFoundFailure;
  const factory Failure.database(String message, [StackTrace? stackTrace]) =
      DatabaseFailure;
  const factory Failure.encryption(String message, [StackTrace? stackTrace]) =
      EncryptionFailure;
  const factory Failure.biometric(String message, [StackTrace? stackTrace]) =
      BiometricFailure;
  const factory Failure.pin(String message, [StackTrace? stackTrace]) =
      PinFailure;
  const factory Failure.unexpected(String message, [StackTrace? stackTrace]) =
      UnexpectedFailure;
}
