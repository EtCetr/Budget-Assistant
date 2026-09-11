import 'package:freezed_annotation/freezed_annotation.dart';

part 'membership_model.freezed.dart';
part 'membership_model.g.dart';

@freezed
abstract class MembershipModel with _$MembershipModel {
  const factory MembershipModel({
    required String id,
    required String userId,
    required String spaceId,
    @Default('member') String role, // admin | member
    @Default('active') String status, // active | pending | left
    DateTime? lastActiveAt, // Heartbeat
    required DateTime joinedAt,
    DateTime? leftAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default('pending') String syncStatus,
  }) = _MembershipModel;

  factory MembershipModel.fromJson(Map<String, dynamic> json) =>
      _$MembershipModelFromJson(json);
}
