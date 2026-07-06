import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/utils/result.dart';
import 'package:budget_assistant/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:budget_assistant/features/auth/domain/repositories/i_auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Stream<AuthState> get authStateChanges => _remoteDataSource.authStateChanges;

  @override
  Future<Result<User?>> getCurrentUser() async {
    try {
      final user = await _remoteDataSource.getCurrentUser();
      return (data: user, failure: null);
    } on Failure catch (f) {
      return (data: null, failure: f);
    } catch (e, st) {
      return (
        data: null,
        failure: Failure.unexpected('Unknown error getting user: $e', st),
      );
    }
  }

  @override
  Future<Result<AuthResponse>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _remoteDataSource.signInWithEmailAndPassword(
        email,
        password,
      );
      return (data: response, failure: null);
    } on Failure catch (f) {
      return (data: null, failure: f);
    } catch (e, st) {
      return (
        data: null,
        failure: Failure.unexpected('Unknown error during sign in: $e', st),
      );
    }
  }

  @override
  Future<Result<AuthResponse>> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final response = await _remoteDataSource.signUpWithEmailAndPassword(
        email,
        password,
      );
      return (data: response, failure: null);
    } on Failure catch (f) {
      return (data: null, failure: f);
    } catch (e, st) {
      return (
        data: null,
        failure: Failure.unexpected('Unknown error during sign up: $e', st),
      );
    }
  }

  @override
  Future<Result<void>> signInWithOtp(String email) async {
    try {
      await _remoteDataSource.signInWithOtp(email);
      return (data: null, failure: null);
    } on Failure catch (f) {
      return (data: null, failure: f);
    } catch (e, st) {
      return (
        data: null,
        failure: Failure.unexpected('Unknown error during OTP sign in: $e', st),
      );
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return (data: null, failure: null);
    } on Failure catch (f) {
      return (data: null, failure: f);
    } catch (e, st) {
      return (
        data: null,
        failure: Failure.unexpected('Unknown error during sign out: $e', st),
      );
    }
  }
}
