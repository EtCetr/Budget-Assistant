import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/services/secure_storage_service.dart';
import 'package:budget_assistant/features/import/domain/entities/transfer_profile.dart';

/// Профиль детекции переводов (мои телефоны/ФИО + семьи). SecureStorage.
class TransferProfileNotifier extends Notifier<TransferProfile> {
  static const _key = 'transfer_profile_json';

  @override
  TransferProfile build() => const TransferProfile();

  Future<TransferProfile> load() async {
    try {
      final raw = await SecureStorageService().read(_key);
      if (raw != null && raw.isNotEmpty) {
        state = TransferProfile.fromJson(
            (jsonDecode(raw) as Map).cast<String, dynamic>());
      }
    } catch (_) {}
    return state;
  }

  Future<void> save(TransferProfile next) async {
    state = next;
    try {
      await SecureStorageService().write(_key, jsonEncode(next.toJson()));
    } catch (_) {}
  }
}

final transferProfileProvider =
    NotifierProvider<TransferProfileNotifier, TransferProfile>(
        TransferProfileNotifier.new);