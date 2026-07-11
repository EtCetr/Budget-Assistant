import 'package:freezed_annotation/freezed_annotation.dart';

part 'space_model.freezed.dart';  // ← ТОЛЬКО имя файла!
part 'space_model.g.dart';         // ← ТОЛЬКО имя файла!

@freezed
abstract class SpaceModel with _$SpaceModel {
  const factory SpaceModel({
    required String id,
    required String name,
    required String encryptionSalt,
    @Default('active') String status,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('pending') String syncStatus,
  }) = _SpaceModel;

  factory SpaceModel.fromJson(Map<String, dynamic> json) =>
      _$SpaceModelFromJson(json);
}