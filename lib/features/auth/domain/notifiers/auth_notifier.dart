// lib/features/auth/domain/notifiers/auth_notifier.dart
import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:budget_assistant/core/utils/result.dart';
import 'package:budget_assistant/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:budget_assistant/core/providers/auth_providers.dart';

part 'auth_notifier.g.dart';

enum AuthStatus { unknown, unauthenticated, authenticated }

@riverpod
class AuthNotifier extends _$AuthNotifier {
  late final IAuthRepository _repository;
  StreamSubscription<AuthState>? _authStreamSubscription;

  @override
  AuthStatus build() {
    _repository = ref.watch(authRepositoryProvider);
    ref.onDispose(() {
      _authStreamSubscription?.cancel();
    });
    _initAuthState();
    return AuthStatus.unknown;
  }

  void _initAuthState() {
    _authStreamSubscription = _repository.authStateChanges.listen(
      _handleAuthStateChange,
    );
  }

  void _handleAuthStateChange(AuthState authState) {
    if (authState.session != null) {
      state = AuthStatus.authenticated;
    } else {
      state = AuthStatus.unauthenticated;
    }
  }

  // ИСПРАВЛЕНО: Убран .map((_) {}), который ломал парсер riverpod_generator
  Future<Result<void>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return _repository.signInWithEmailAndPassword(email, password);
  }

  Future<Result<void>> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    return _repository.signUpWithEmailAndPassword(email, password);
  }

  Future<Result<void>> signInWithOtp(String email) async {
    return _repository.signInWithOtp(email);
  }

  Future<Result<void>> signOut() async {
    return _repository.signOut();
  }
}
 
