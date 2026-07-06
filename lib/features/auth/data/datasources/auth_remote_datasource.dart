import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/logger.dart'; // Добавлен импорт

abstract class AuthRemoteDataSource {
  Future<User?> getCurrentUser();
  Future<AuthResponse> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<AuthResponse> signUpWithEmailAndPassword(
    String email,
    String password,
  );
  Future<void> signInWithOtp(String email);
  Future<void> signOut();
  Stream<AuthState> get authStateChanges;
}

class SupabaseAuthRemoteDataSource implements AuthRemoteDataSource {
  final GoTrueClient _client; // Поле должно быть ТОЛЬКО в реализации

  SupabaseAuthRemoteDataSource(this._client);

  @override
  Future<User?> getCurrentUser() async {
    try {
      return _client.currentUser;
    } catch (e, st) {
      AppLogger.e('Failed to get current user', e, st);
      throw Failure.network('Failed to get current user: $e', st);
    }
  }

  @override
  Future<AuthResponse> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _client.signInWithPassword(email: email, password: password);
    } catch (e, st) {
      AppLogger.e('Sign in failed', e, st);
      throw Failure.authentication('Sign in failed: $e', st);
    }
  }

  @override
  Future<AuthResponse> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _client.signUp(email: email, password: password);
    } catch (e, st) {
      AppLogger.e('Sign up failed', e, st);
      throw Failure.authentication('Sign up failed: $e', st);
    }
  }

  @override
  Future<void> signInWithOtp(String email) async {
    try {
      await _client.signInWithOtp(email: email);
    } catch (e, st) {
      AppLogger.e('OTP sign in failed', e, st);
      throw Failure.authentication('OTP sign in failed: $e', st);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.signOut();
    } catch (e) {
      AppLogger.w('Warning: Failed to sign out: $e');
    }
  }

  @override
  Stream<AuthState> get authStateChanges => _client.onAuthStateChange;
}
