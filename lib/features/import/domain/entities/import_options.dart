import 'package:freezed_annotation/freezed_annotation.dart';

part 'import_options.freezed.dart';

/// Опции импорта (5 чекбоксов из STEP 4).
@freezed
abstract class ImportOptions with _$ImportOptions {
  const factory ImportOptions({
    @Default(true) bool detectDuplicates,
    @Default(true) bool detectTransfers,
    @Default(true) bool checkSecrecy,
    @Default(true) bool autoCategorize,
    @Default(true) bool detectRecurring,
  }) = _ImportOptions;
}