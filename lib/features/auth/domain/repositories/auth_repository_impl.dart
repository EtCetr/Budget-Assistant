// lib/features/auth/domain/repositories/auth_repository_impl.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:budget_assistant/core/utils/result.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/logger.dart';
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
      return Result.success(user);
    } catch (e, stackTrace) {
      AppLogger.e('getCurrentUser failed', e, stackTrace);
      return Result.failure(
        Failure.database('Failed to get current user: $e', stackTrace),
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
      AppLogger.i('User signed in: ${response.user?.id}');
      return Result.success(response);
    } catch (e, stackTrace) {
      AppLogger.e('signInWithEmailAndPassword failed', e, stackTrace);
      return Result.failure(Failure.network('Sign in failed: $e', stackTrace));
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
      AppLogger.i('User signed up: ${response.user?.id}');
      return Result.success(response);
    } catch (e, stackTrace) {
      AppLogger.e('signUpWithEmailAndPassword failed', e, stackTrace);
      return Result.failure(Failure.network('Sign up failed: $e', stackTrace));
    }
  }

  @override
  Future<Result<void>> signInWithOtp(String email) async {
    try {
      await _remoteDataSource.signInWithOtp(email);
      AppLogger.i('OTP sent to: $email');
      return Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.e('signInWithOtp failed', e, stackTrace);
      return Result.failure(Failure.network('OTP failed: $e', stackTrace));
    }
  }

  @override
  Future<Result<void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      AppLogger.i('User signed out');
      return Result.success(null);
    } catch (e, stackTrace) {
      AppLogger.e('signOut failed', e, stackTrace);
      return Result.failure(Failure.network('Sign out failed: $e', stackTrace));
    }
  }
}
