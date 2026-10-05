import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/logger.dart';

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
  Future<bool> signInWithGoogle();
  Future<void> signOut();
  Stream<AuthState> get authStateChanges;
}

class SupabaseAuthRemoteDataSource implements AuthRemoteDataSource {
  final GoTrueClient _client;
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
  Future<bool> signInWithGoogle() async {
    try {
      final opened = await _client.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutterauth://callback',
      );
      if (!opened) {
        throw const Failure.authentication('Не удалось открыть браузер для Google');
      }
      return true;
    } catch (e, st) {
      AppLogger.e('Google sign in failed', e, st);
      throw Failure.authentication('Google sign in failed: $e', st);
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