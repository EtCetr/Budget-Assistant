import 'package:freezed_annotation/freezed_annotation.dart';

part 'member_color_model.freezed.dart';
part 'member_color_model.g.dart';

/// Override цвета участника семьи (ТЗ 6.3.46, Этап 21).
@freezed
abstract class MemberColorModel with _$MemberColorModel {
  const factory MemberColorModel({
    required String id,
    required String userId,
    @Default('') String spaceId,
    required String customColorHex, // [E2E] при sync
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('pending') String syncStatus,
  }) = _MemberColorModel;

  factory MemberColorModel.fromJson(Map<String, dynamic> json) =>
      _$MemberColorModelFromJson(json);
}