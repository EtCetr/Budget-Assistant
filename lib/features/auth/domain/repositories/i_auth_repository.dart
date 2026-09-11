import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:budget_assistant/core/utils/result.dart';

abstract class IAuthRepository {
  Stream<AuthState> get authStateChanges;
  Future<Result<User?>> getCurrentUser();
  Future<Result<AuthResponse>> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<Result<AuthResponse>> signUpWithEmailAndPassword(
    String email,
    String password,
  );
  Future<Result<void>> signInWithOtp(
    String email,
  ); // Изменено на void для совместимости
  Future<Result<void>> signOut();
}
