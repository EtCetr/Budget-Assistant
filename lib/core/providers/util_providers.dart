// lib/core/providers/util_providers.dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:logger/logger.dart';

part 'util_providers.g.dart';

@riverpod
Logger logger(Ref ref) {
  return Logger(); // Базовый логгер без конфликтующих параметров
}

@riverpod
Uuid uuid(Ref ref) {
  return const Uuid();
}
