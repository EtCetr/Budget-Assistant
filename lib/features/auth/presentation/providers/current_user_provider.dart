import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// «Кто я» — id текущего пользователя.
/// Supabase хранит сессию на устройстве, поэтому работает офлайн.
final currentUserIdProvider = Provider<String>((ref) {
  final id = Supabase.instance.client.auth.currentUser?.id;

  if (id == null) {
    // Сюда не должно доходить: до экранов приложения
    // пользователь проходит онбординг/логин (Этап 4).
    throw StateError('Нет авторизованного пользователя');
  }

  return id;
});