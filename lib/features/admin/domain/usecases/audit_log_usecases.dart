import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/admin/data/daos/admin_dao.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';
import 'package:budget_assistant/features/admin/domain/repositories/admin_repository.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';

/// Сводка количеств действий за выбранный период (ТЗ 6.3.35.4).
class AuditStats {
  const AuditStats({
    required this.invitations,
    required this.removals,
    required this.roleChanges,
    required this.adminTransfers,
    required this.emergencyPromotions,
  });
  final int invitations;
  final int removals;
  final int roleChanges;
  final int adminTransfers;
  final int emergencyPromotions;
  static const AuditStats empty = AuditStats(
    invitations: 0,
    removals: 0,
    roleChanges: 0,
    adminTransfers: 0,
    emergencyPromotions: 0,
  );
}

/// Период уже применён в SQL (watchAuditFiltered), здесь — только подсчёт.
class CalculateAuditStatsUseCase {
  const CalculateAuditStatsUseCase();
  AuditStats call(List<AuditEntry> logs) {
    int count(bool Function(AuditAction a) p) =>
        logs.where((e) => p(e.action)).length;
    return AuditStats(
      invitations: count(
          (a) => a == AuditAction.memberInvited || a == AuditAction.memberJoined),
      removals: count(
          (a) => a == AuditAction.memberRemoved || a == AuditAction.memberLeft),
      roleChanges: count((a) => a == AuditAction.roleChanged),
      adminTransfers: count((a) => a == AuditAction.adminTransferred),
      emergencyPromotions: count((a) =>
          a == AuditAction.emergencyPromotion || a == AuditAction.autoPromotion),
    );
  }
}

/// Имена подтягиваются из users на лету + кэш в памяти (6.3.35.12 п.4).
class GetUserNameUseCase {
  GetUserNameUseCase(this._dao);
  final AdminDao _dao;
  final Map<String, String> _cache = {};
  Future<String> call(String userId) async {
    final cached = _cache[userId];
    if (cached != null) return cached;
    try {
      final name = await _dao.userNameById(userId);
      final result =
          (name == null || name.isEmpty) ? 'Неизвестный пользователь' : name;
      _cache[userId] = result;
      return result;
    } catch (e, st) {
      AppLogger.e('GetUserName failed', e, st);
      return 'Неизвестный пользователь';
    }
  }
}

/// Отформатированная запись журнала для UI.
class FormattedAuditEntry {
  const FormattedAuditEntry({
    required this.entry,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.time,
    this.additionalInfo,
  });
  final AuditEntry entry;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final String time;
  final String? additionalInfo;
}

/// Рендер-логика записи: имена из users (НЕ из metadata_json), privacy через
/// PrivacyFormatter (хардкод «•••» запрещён).
class FormatAuditEntryUseCase {
  FormatAuditEntryUseCase(this._names);
  final GetUserNameUseCase _names;

  Future<FormattedAuditEntry> call(
    AuditEntry log,
    PrivacyFormatter pf,
    BalanceVisibilityMode mode,
  ) async {
    final actor = pf.formatName(await _names(log.actorUserId), mode);
    final target =
        log.targetId == null ? null : pf.formatName(await _names(log.targetId!), mode);
    final details = _decode(log.metadataJson);
    final String description;
    switch (log.action) {
      case AuditAction.memberInvited:
        description = '$actor пригласил ${target ?? 'участника'}';
      case AuditAction.memberJoined:
        description = '${target ?? 'Участник'} присоединился';
      case AuditAction.memberRemoved:
        description = '$actor удалил ${target ?? 'участника'}';
      case AuditAction.memberLeft:
        description = '${target ?? 'Участник'} покинул пространство';
      case AuditAction.roleChanged:
        final newRole = details['to'] as String?;
        final verb = newRole == 'admin' ? 'повысил' : 'понизил';
        description = '$actor $verb ${target ?? 'участника'} до ${_roleLabel(newRole)}';
      case AuditAction.adminTransferred:
        description = '$actor передал управление ${target ?? 'участнику'}';
      case AuditAction.autoPromotion:
        description = '${target ?? 'Участник'} стал админом (единственный участник)';
      case AuditAction.emergencyPromotion:
        description =
            '${target ?? 'Участник'} принял управление (админ неактивен 30 дней)';
      case AuditAction.spaceDissolved:
        description = '$actor расформировал пространство';
      case AuditAction.syncReminderSent:
        description = '$actor отправил напоминание ${target ?? 'участнику'}';
      case AuditAction.memberSuspended:
        description = '$actor приостановил ${target ?? 'участника'}';
      case AuditAction.memberResumed:
        description = '$actor возобновил ${target ?? 'участника'}';
      case AuditAction.inviteGenerated:
        description = '$actor создал приглашение';
      case AuditAction.inviteRevoked:
        description = '$actor отозвал приглашение';
      case AuditAction.reminderSent:
        description = '$actor отправил напоминание ${target ?? 'участнику'}';
      case AuditAction.spaceRenamed:
        description = '$actor переименовал пространство';
      case AuditAction.spaceBudgetChanged:
        description = '$actor изменил семейный бюджет';
      case AuditAction.spaceDataExported:
        description = '$actor экспортировал данные пространства';
    }
    return FormattedAuditEntry(
      entry: log,
      icon: _icon(log.action),
      iconColor: _color(log.action),
      title: log.action.label,
      description: description,
      time: DateFormat('HH:mm').format(log.createdAt.toLocal()),
      additionalInfo: _additional(details),
    );
  }

  Map<String, dynamic> _decode(String json) {
    try {
      final v = jsonDecode(json);
      return v is Map<String, dynamic> ? v : const {};
    } catch (_) {
      return const {};
    }
  }

  String _roleLabel(String? role) => role == 'admin' ? 'админа' : 'участника';

  String? _additional(Map<String, dynamic> d) {
    if (d.containsKey('reason')) return 'Причина: ${d['reason']}';
    if (d.containsKey('from') && d.containsKey('to')) {
      return '${d['from']} → ${d['to']}';
    }
    if (d.containsKey('members_count')) return 'Участников: ${d['members_count']}';
    return null;
  }

  IconData _icon(AuditAction a) => switch (a) {
        AuditAction.memberInvited => Icons.mark_email_read_outlined,
        AuditAction.memberJoined => Icons.waving_hand_outlined,
        AuditAction.memberRemoved => Icons.close,
        AuditAction.memberLeft => Icons.logout,
        AuditAction.roleChanged => Icons.swap_horiz,
        AuditAction.adminTransferred => Icons.workspace_premium,
        AuditAction.autoPromotion => Icons.warning_amber,
        AuditAction.emergencyPromotion => Icons.error_outline,
        AuditAction.spaceDissolved => Icons.delete_forever,
        AuditAction.syncReminderSent => Icons.notifications_active,
        AuditAction.memberSuspended => Icons.pause_circle_outline,
        AuditAction.memberResumed => Icons.play_circle_outline,
        AuditAction.inviteGenerated => Icons.person_add_alt,
        AuditAction.inviteRevoked => Icons.person_off,
        AuditAction.reminderSent => Icons.campaign_outlined,
        AuditAction.spaceRenamed => Icons.drive_file_rename_outline,
        AuditAction.spaceBudgetChanged => Icons.payments_outlined,
        AuditAction.spaceDataExported => Icons.upload_file,
      };

  Color _color(AuditAction a) => switch (a) {
        AuditAction.memberInvited ||
        AuditAction.memberJoined ||
        AuditAction.inviteGenerated =>
          AppColors.colorIncome,
        AuditAction.memberRemoved ||
        AuditAction.spaceDissolved ||
        AuditAction.autoPromotion ||
        AuditAction.emergencyPromotion ||
        AuditAction.inviteRevoked =>
          AppColors.colorExpense,
        AuditAction.roleChanged ||
        AuditAction.syncReminderSent ||
        AuditAction.reminderSent ||
        AuditAction.spaceDataExported =>
          AppColors.colorTransfer,
        AuditAction.adminTransferred || AuditAction.spaceBudgetChanged =>
          AppColors.colorWarning,
        _ => AppColors.textSecondary,
      };
}

/// CSV-экспорт журнала (6.3.35.7): UTF-8 с BOM, имена открытые (осознанное
/// действие админа), сохранение через MediaStore (MethodChannel 12.8).
class ExportAuditLogUseCase {
  ExportAuditLogUseCase({required AdminDao dao, required GetUserNameUseCase names})
      : _dao = dao,
        _names = names;
  final AdminDao _dao;
  final GetUserNameUseCase _names;

  String get _stamp => DateTime.now().toUtc().toIso8601String().substring(0, 10);

  Future<String> call({required String spaceId, DateTime? since}) async {
    try {
      final entries = await _dao.watchAuditFiltered(spaceId, since: since).first;
      final sb = StringBuffer();
      sb.writeln('Timestamp,Action,Actor,Target,Details');
      for (final e in entries) {
        final actor = await _names(e.actorUserId);
        final target = e.targetId == null ? '' : await _names(e.targetId!);
        sb.writeln([
          _csv(e.createdAt.toIso8601String()),
          _csv(e.action.dbValue),
          _csv(actor),
          _csv(target),
          _csv(_flat(e.metadataJson)),
        ].join(','));
      }
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/admin_audit_log_$_stamp.csv';
      final bytes = <int>[0xEF, 0xBB, 0xBF];
      bytes.addAll(utf8.encode(sb.toString()));
      await File(path).writeAsBytes(bytes);
      return path;
    } catch (e, st) {
      AppLogger.e('ExportAuditLog failed', e, st);
      rethrow;
    }
  }

  String _csv(String v) => '"${v.replaceAll('"', '""')}"';

  String _flat(String json) {
    try {
      final m = jsonDecode(json);
      if (m is Map<String, dynamic>) {
        return m.entries.map((e) => '${e.key}: ${e.value}').join(', ');
      }
      return '';
    } catch (_) {
      return '';
    }
  }

  Future<String> saveToDownloads(String path) async {
    final file = File(path);
    final name = file.uri.pathSegments.last;
    final bytes = await file.readAsBytes();
    const channel = MethodChannel('budget_assistant/clock');
    final uri = await channel.invokeMethod<String>(
      'saveToDownloads',
      {'fileName': name, 'bytes': bytes, 'mime': 'text/csv'},
    );
    return uri ?? 'Downloads/BudgetAssistant/$name';
  }

  Future<void> share(String path) async {
    await SharePlus.instance.share(
      ShareParams(files: [XFile(path)], text: 'Журнал аудита пространства'),
    );
  }
}

/// Создание записи аудита (для SpaceSettings и будущих экранов).
class LogAuditActionUseCase {
  LogAuditActionUseCase(this._repo);
  final AdminRepository _repo;
  Future<void> call({
    required String spaceId,
    required String actorId,
    required AuditAction action,
    String? targetId,
    Map<String, dynamic>? metadata,
  }) =>
      _repo.logAudit(
        spaceId: spaceId,
        actorId: actorId,
        action: action,
        targetId: targetId,
        metadata: metadata,
      );
}