// lib/core/providers/auth_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:budget_assistant/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:budget_assistant/features/auth/domain/repositories/auth_repository_impl.dart';
import 'package:budget_assistant/features/auth/domain/repositories/i_auth_repository.dart';

final supabaseClientProvider = Provider<GoTrueClient>((ref) {
  return Supabase.instance.client.auth;
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseAuthRemoteDataSource(client);
});

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final dataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});
