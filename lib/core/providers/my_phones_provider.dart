import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/services/secure_storage_service.dart';

/// Телефоны владельца для детекции переводов между своими счетами.
/// Хранятся в SecureStorage (JSON), без миграции БД.
class MyPhonesNotifier extends Notifier<List<String>> {
  static const _key = 'my_phones_json';

  @override
  List<String> build() => const [];

  Future<List<String>> load() async {
    try {
      final raw = await SecureStorageService().read(_key);
      if (raw != null && raw.isNotEmpty) {
        final list = (jsonDecode(raw) as List).cast<String>();
        state = list;
        return list;
      }
    } catch (_) {}
    return state;
  }

  Future<void> add(String phone) => _save([...state, phone]);

  Future<void> remove(String phone) =>
      _save([for (final p in state) if (p != phone) p]);

  Future<void> _save(List<String> list) async {
    state = list;
    try {
      await SecureStorageService().write(_key, jsonEncode(list));
    } catch (_) {}
  }
}

final myPhonesProvider =
    NotifierProvider<MyPhonesNotifier, List<String>>(MyPhonesNotifier.new);