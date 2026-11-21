import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:budget_assistant/core/utils/result.dart';
import 'package:budget_assistant/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:budget_assistant/features/auth/domain/repositories/auth_repository_impl.dart';

class _MockRemote extends Mock implements AuthRemoteDataSource {}

class _MockAuthResponse extends Mock implements AuthResponse {}

/// Этап 24: AuthRepositoryImpl — обёртка над Supabase.
/// Любая ошибка источника превращается в Failure, наружу не летит.
bool _isOk<T>(Result<T> r) =>
    r.when(success: (_) => true, failure: (_) => false);

void main() {
  late _MockRemote remote;
  late AuthRepositoryImpl repo;
  late _MockAuthResponse response;

  setUp(() {
    remote = _MockRemote();
    response = _MockAuthResponse();
    repo = AuthRepositoryImpl(remote);
    when(() => remote.getCurrentUser()).thenAnswer((_) async => null);
    when(() => remote.signInWithEmailAndPassword(any(), any()))
        .thenAnswer((_) async => response);
    when(() => remote.signUpWithEmailAndPassword(any(), any()))
        .thenAnswer((_) async => response);
    when(() => remote.signInWithOtp(any())).thenAnswer((_) async {});
    when(() => remote.signInWithGoogle()).thenAnswer((_) async => true);
    when(() => remote.signOut()).thenAnswer((_) async {});
    when(() => remote.authStateChanges)
        .thenAnswer((_) => const Stream<AuthState>.empty());
  });

  test('getCurrentUser: без пользователя — успех с null', () async {
    final r = await repo.getCurrentUser();

    expect(_isOk(r), isTrue);
    expect(r.when(success: (u) => u, failure: (_) => 'err'), isNull);
  });

  test('getCurrentUser: ошибка источника — Failure', () async {
    when(() => remote.getCurrentUser()).thenThrow(Exception('offline'));

    expect(_isOk(await repo.getCurrentUser()), isFalse);
  });

  test('signIn: успех и проброс email/пароля позиционно', () async {
    final r = await repo.signInWithEmailAndPassword('a@b.c', 'pass');

    expect(_isOk(r), isTrue);
    verify(() => remote.signInWithEmailAndPassword('a@b.c', 'pass')).called(1);
  });

  test('signIn: ошибка источника — Failure', () async {
    when(() => remote.signInWithEmailAndPassword(any(), any()))
        .thenThrow(Exception('bad credentials'));

    expect(
      _isOk(await repo.signInWithEmailAndPassword('a@b.c', 'pass')),
      isFalse,
    );
  });

  test('signUp: успех и проброс email/пароля', () async {
    final r = await repo.signUpWithEmailAndPassword('a@b.c', 'pass');

    expect(_isOk(r), isTrue);
    verify(() => remote.signUpWithEmailAndPassword('a@b.c', 'pass')).called(1);
  });

  test('signUp: ошибка источника — Failure', () async {
    when(() => remote.signUpWithEmailAndPassword(any(), any()))
        .thenThrow(Exception('email taken'));

    expect(
      _isOk(await repo.signUpWithEmailAndPassword('a@b.c', 'pass')),
      isFalse,
    );
  });

  test('OTP: успех и проброс email', () async {
    final r = await repo.signInWithOtp('a@b.c');

    expect(_isOk(r), isTrue);
    verify(() => remote.signInWithOtp('a@b.c')).called(1);
  });

  test('OTP: ошибка источника — Failure', () async {
    when(() => remote.signInWithOtp(any())).thenThrow(Exception('smtp down'));

    expect(_isOk(await repo.signInWithOtp('a@b.c')), isFalse);
  });

  test('Google: успех возвращает true', () async {
    final r = await repo.signInWithGoogle();

    expect(_isOk(r), isTrue);
    expect(r.when(success: (v) => v, failure: (_) => false), isTrue);
  });

  test('Google: браузер не открылся — Failure', () async {
    when(() => remote.signInWithGoogle()).thenThrow(Exception('no browser'));

    expect(_isOk(await repo.signInWithGoogle()), isFalse);
  });

  test('signOut: успех', () async {
    expect(_isOk(await repo.signOut()), isTrue);
    verify(() => remote.signOut()).called(1);
  });

  test('signOut: ошибка источника — Failure', () async {
    when(() => remote.signOut()).thenThrow(Exception('network'));

    expect(_isOk(await repo.signOut()), isFalse);
  });

  test('authStateChanges проксируется от источника', () async {
    // controller.stream возвращает НОВЫЙ объект на каждое обращение,
    // поэтому идентичность сравнивать нельзя — проверяем поведение:
    // закрытие источника завершает поток репозитория.
    final controller = StreamController<AuthState>.broadcast();
    when(() => remote.authStateChanges).thenAnswer((_) => controller.stream);

    final collected = repo.authStateChanges.toList();
    await controller.close();

    expect(await collected, isEmpty);
    verify(() => remote.authStateChanges).called(1);
  });
}