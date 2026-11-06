// lib/features/spaces/domain/entities/space_membership_info.dart
// Этап 21 (ТЗ 6.3.51): пространство + моё членство в нём для экрана управления.
class SpaceMembershipInfo {
  const SpaceMembershipInfo({
    required this.spaceId,
    required this.spaceName,
    this.iconEmoji,
    this.iconColor,
    required this.spaceStatus,
    this.dissolvedAt,
    required this.role,
    required this.joinedAt,
    required this.memberCount,
  });

  final String spaceId;
  final String spaceName; // [E2E] при sync
  final String? iconEmoji;
  final String? iconColor;
  final String spaceStatus; // active | dissolved
  final DateTime? dissolvedAt;
  final String role; // admin | member
  final DateTime joinedAt;
  final int memberCount;

  bool get isAdmin => role == 'admin';
  bool get isDissolved => spaceStatus == 'dissolved';
}