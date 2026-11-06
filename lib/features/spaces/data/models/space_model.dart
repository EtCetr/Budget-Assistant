import 'package:freezed_annotation/freezed_annotation.dart';

part 'space_model.freezed.dart';
part 'space_model.g.dart';

/// Пространство (семейная группа). Модель догоняет поля Этапа 18
/// (identity + dissolve) в Этапе 21.
@freezed
abstract class SpaceModel with _$SpaceModel {
  const factory SpaceModel({
    required String id,
    required String name, // [E2E]
    required String encryptionSalt, // неизменяемая
    @Default('active') String status, // active | dissolved
    @Default('RUB') String currencyCode,
    // Этап 18 (6.3.36): identity + dissolve. icon_* — открытые метаданные,
    // monthly_budget_limit — [E2E] при sync.
    String? iconEmoji,
    String? iconColor,
    int? monthlyBudgetLimit,
    DateTime? dissolvedAt,
    String? dissolvedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('pending') String syncStatus,
  }) = _SpaceModel;

  factory SpaceModel.fromJson(Map<String, dynamic> json) =>
      _$SpaceModelFromJson(json);
}