import 'package:freezed_annotation/freezed_annotation.dart';

part 'effective_limit.freezed.dart';

@freezed
abstract class EffectiveLimit with _$EffectiveLimit {
  const factory EffectiveLimit({
    required String categoryId,
    required int baseLimit,
    required bool inheritedFromPrevious,
    required int carriedOver,
    required int effectiveTotal,
    required int spent,
    required int remaining,
    required int percentUsed,
  }) = _EffectiveLimit;
}