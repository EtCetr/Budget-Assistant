import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:logger/logger.dart';

part 'util_providers.g.dart';

@riverpod
class LoggerNotifier extends _$LoggerNotifier {
  @override
  Logger build() {
    return Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        // ✅ Фикс deprecated printTime
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
    );
  }
}

@riverpod
class UuidNotifier extends _$UuidNotifier {
  @override
  Uuid build() => const Uuid();
}
