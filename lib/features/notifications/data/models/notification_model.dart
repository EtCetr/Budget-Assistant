import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
abstract class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String id,
    required String userId,
    String? spaceId,
    required String type, // 27 типов из ТОМ 5
    required String title, // [E2E]
    required String body, // [E2E]
    @Default(false) bool isRead,
    String? relatedEntityId,
    String? actionTaken, // confirmed | dismissed
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('pending') String syncStatus,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);
}
