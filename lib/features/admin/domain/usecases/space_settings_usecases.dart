import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';
import 'package:budget_assistant/features/admin/domain/repositories/admin_repository.dart';

/// Настройки пространства (6.3.36): identity + семейный лимит.
class SpaceSettingsRow {
  const SpaceSettingsRow({
    required this.id,
    required this.name,
    required this.iconEmoji,
    required this.iconColor,
    required this.monthlyBudgetLimit,
    required this.createdAt,
    required this.syncStatus,
  });
  final String id;
  final String name;
  final String? iconEmoji;
  final String? iconColor;
  final int? monthlyBudgetLimit;
  final DateTime createdAt;
  final String syncStatus;
}

/// Статистика пространства (6.3.36.4, read-only).
class SpaceStatsRow {
  const SpaceStatsRow({
    required this.accountsCount,
    required this.transactionsCount,
    required this.familyBalanceKopecks,
  });
  final int accountsCount;
  final int transactionsCount;
  final int familyBalanceKopecks;
}

class ExportMemberRow {
  const ExportMemberRow({
    required this.name,
    required this.role,
    required this.status,
    required this.joinedAt,
  });
  final String name;
  final String role;
  final String status;
  final DateTime joinedAt;
}

class ExportAccountRow {
  const ExportAccountRow({
    required this.bank,
    required this.type,
    required this.balanceKopecks,
    required this.currency,
  });
  final String bank;
  final String type;
  final int balanceKopecks;
  final String currency;
}

class ExportTxRow {
  const ExportTxRow({
    required this.date,
    required this.type,
    required this.amountKopecks,
    required this.merchant,
    required this.comment,
  });
  final DateTime date;
  final String type;
  final int amountKopecks;
  final String? merchant;
  final String? comment;
}

class ExportGoalRow {
  const ExportGoalRow({
    required this.name,
    required this.targetKopecks,
    required this.currentKopecks,
    required this.status,
  });
  final String name;
  final int targetKopecks;
  final int currentKopecks;
  final String status;
}

class ExportDebtRow {
  const ExportDebtRow({
    required this.creditor,
    required this.debtor,
    required this.amountKopecks,
    required this.status,
  });
  final String creditor;
  final String debtor;
  final int amountKopecks;
  final String status;
}

class SpaceExportBundle {
  const SpaceExportBundle({
    required this.members,
    required this.accounts,
    required this.transactions,
    required this.goals,
    required this.debts,
  });
  final List<ExportMemberRow> members;
  final List<ExportAccountRow> accounts;
  final List<ExportTxRow> transactions;
  final List<ExportGoalRow> goals;
  final List<ExportDebtRow> debts;
}

/// Смена названия/иконки (6.3.36.3): encryption_salt НЕ трогаем.
class UpdateSpaceIdentityUseCase {
  UpdateSpaceIdentityUseCase(this._repo);
  final AdminRepository _repo;
  Future<void> call({
    required String spaceId,
    required String actorId,
    required String newName,
    required String newIconEmoji,
    required String newIconColor,
    required String oldName,
  }) async {
    try {
      final trimmed = newName.trim();
      if (trimmed.isEmpty || trimmed.length > 50) {
        throw const AdminFailure('Название: от 1 до 50 символов');
      }
      await _repo.updateSpaceIdentity(
        spaceId: spaceId,
        actorId: actorId,
        name: trimmed,
        iconEmoji: newIconEmoji,
        iconColor: newIconColor,
        oldName: oldName,
      );
    } catch (e, st) {
      AppLogger.e('UpdateSpaceIdentity failed', e, st);
      rethrow;
    }
  }
}

/// Семейный лимит (6.3.36.5/6): null = выключен; границы 1 тыс — 100 млн ₽.
class UpdateSpaceBudgetLimitUseCase {
  UpdateSpaceBudgetLimitUseCase(this._repo);
  final AdminRepository _repo;
  static const int minKopecks = 100000; // 1 000 ₽
  static const int maxKopecks = 10000000000; // 100 000 000 ₽
  Future<void> call({
    required String spaceId,
    required String actorId,
    required int? limitKopecks,
    required int? oldLimitKopecks,
  }) async {
    try {
      if (limitKopecks != null &&
          (limitKopecks < minKopecks || limitKopecks > maxKopecks)) {
        throw const AdminFailure('Лимит: от 1 000 ₽ до 100 000 000 ₽');
      }
      await _repo.updateSpaceBudgetLimit(
        spaceId: spaceId,
        actorId: actorId,
        limitKopecks: limitKopecks,
        oldLimitKopecks: oldLimitKopecks,
      );
    } catch (e, st) {
      AppLogger.e('UpdateSpaceBudgetLimit failed', e, st);
      rethrow;
    }
  }
}

/// XLSX-экспорт пространства (6.3.36.7): 5 листов, ручной OOXML через archive.
/// После генерации пишет аудит space_data_exported с хэшем пути файла.
class ExportSpaceDataUseCase {
  ExportSpaceDataUseCase(this._repo);
  final AdminRepository _repo;

  String get _stamp => DateTime.now().toUtc().toIso8601String().substring(0, 10);

  Future<String> call({
    required String spaceId,
    required String actorId,
    required String spaceName,
  }) async {
    try {
      final bundle = await _repo.fetchSpaceExportBundle(spaceId);
      final archive = Archive();
      void add(String name, String content) {
        final bytes = utf8.encode(content);
        archive.addFile(ArchiveFile(name, bytes.length, bytes));
      }
      add('[Content_Types].xml', _contentTypes);
      add('_rels/.rels', _rootRels);
      add('xl/workbook.xml', _workbook);
      add('xl/_rels/workbook.xml.rels', _workbookRels);
      add('xl/worksheets/sheet1.xml', _membersSheet(bundle.members));
      add('xl/worksheets/sheet2.xml', _accountsSheet(bundle.accounts));
      add('xl/worksheets/sheet3.xml', _txSheet(bundle.transactions));
      add('xl/worksheets/sheet4.xml', _goalsSheet(bundle.goals));
      add('xl/worksheets/sheet5.xml', _debtsSheet(bundle.debts));
      final zip = ZipEncoder().encode(archive);
      final dir = await getTemporaryDirectory();
      final safeName = spaceName.replaceAll(RegExp(r'[^\wа-яА-ЯёЁ-]+'), '_');
      final path = '${dir.path}/space_export_${safeName}_$_stamp.xlsx';
      await File(path).writeAsBytes(zip);
      await _repo.logAudit(
        spaceId: spaceId,
        actorId: actorId,
        action: AuditAction.spaceDataExported,
        targetId: spaceId,
        metadata: {'file_path_hash': sha256.convert(utf8.encode(path)).toString()},
      );
      return path;
    } catch (e, st) {
      AppLogger.e('ExportSpaceData failed', e, st);
      rethrow;
    }
  }

  String _esc(String s) => s
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');
  String _cell(String v) => '<c t="inlineStr"><is><t>${_esc(v)}</t></is></c>';
  String _wrap(StringBuffer sb) {
    sb.write('<?xml version="1.0" encoding="UTF-8"?>');
    sb.write('<worksheet xmlns="http://schemas.openxmlformats.org/'
        'spreadsheetml/2006/main"><sheetData>');
    return '';
  }

  String _membersSheet(List<ExportMemberRow> rows) {
    final sb = StringBuffer();
    _wrap(sb);
    sb.write('<row>${_cell('Имя')}${_cell('Роль')}${_cell('Статус')}${_cell('Вход')}</row>');
    for (final r in rows) {
      sb.write('<row>${_cell(r.name)}${_cell(r.role)}${_cell(r.status)}'
          '${_cell(DateFormat('dd.MM.yyyy').format(r.joinedAt.toLocal()))}</row>');
    }
    sb.write('</sheetData></worksheet>');
    return sb.toString();
  }

  String _accountsSheet(List<ExportAccountRow> rows) {
    final sb = StringBuffer();
    _wrap(sb);
    sb.write('<row>${_cell('Банк')}${_cell('Тип')}${_cell('Баланс (коп)')}${_cell('Валюта')}</row>');
    for (final r in rows) {
      sb.write('<row>${_cell(r.bank)}${_cell(r.type)}'
          '${_cell(r.balanceKopecks.toString())}${_cell(r.currency)}</row>');
    }
    sb.write('</sheetData></worksheet>');
    return sb.toString();
  }

  String _txSheet(List<ExportTxRow> rows) {
    final sb = StringBuffer();
    _wrap(sb);
    sb.write('<row>${_cell('Дата')}${_cell('Тип')}${_cell('Сумма (коп)')}'
        '${_cell('Мерчант')}${_cell('Комментарий')}</row>');
    for (final r in rows) {
      sb.write('<row>${_cell(r.date.toIso8601String())}${_cell(r.type)}'
          '${_cell(r.amountKopecks.toString())}${_cell(r.merchant ?? '')}'
          '${_cell(r.comment ?? '')}</row>');
    }
    sb.write('</sheetData></worksheet>');
    return sb.toString();
  }

  String _goalsSheet(List<ExportGoalRow> rows) {
    final sb = StringBuffer();
    _wrap(sb);
    sb.write('<row>${_cell('Название')}${_cell('Цель (коп)')}'
        '${_cell('Накоплено (коп)')}${_cell('Статус')}</row>');
    for (final r in rows) {
      sb.write('<row>${_cell(r.name)}${_cell(r.targetKopecks.toString())}'
          '${_cell(r.currentKopecks.toString())}${_cell(r.status)}</row>');
    }
    sb.write('</sheetData></worksheet>');
    return sb.toString();
  }

  String _debtsSheet(List<ExportDebtRow> rows) {
    final sb = StringBuffer();
    _wrap(sb);
    sb.write('<row>${_cell('Кредитор')}${_cell('Должник')}'
        '${_cell('Сумма (коп)')}${_cell('Статус')}</row>');
    for (final r in rows) {
      sb.write('<row>${_cell(r.creditor)}${_cell(r.debtor)}'
          '${_cell(r.amountKopecks.toString())}${_cell(r.status)}</row>');
    }
    sb.write('</sheetData></worksheet>');
    return sb.toString();
  }

  static const _contentTypes = '<?xml version="1.0" encoding="UTF-8"?>'
      '<Types xmlns="http://schemas.openxmlformats.org/package/2006/'
      'content-types">'
      '<Default Extension="rels" ContentType="application/'
      'vnd.openxmlformats-package.relationships+xml"/>'
      '<Default Extension="xml" ContentType="application/xml"/>'
      '<Override PartName="/xl/workbook.xml" ContentType="application/'
      'vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>'
      '<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/'
      'vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
      '<Override PartName="/xl/worksheets/sheet2.xml" ContentType="application/'
      'vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
      '<Override PartName="/xl/worksheets/sheet3.xml" ContentType="application/'
      'vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
      '<Override PartName="/xl/worksheets/sheet4.xml" ContentType="application/'
      'vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
      '<Override PartName="/xl/worksheets/sheet5.xml" ContentType="application/'
      'vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
      '</Types>';
  static const _rootRels = '<?xml version="1.0" encoding="UTF-8"?>'
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/'
      'relationships">'
      '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/'
      'officeDocument/2006/relationships/officeDocument" '
      'Target="xl/workbook.xml"/>'
      '</Relationships>';
  static const _workbook = '<?xml version="1.0" encoding="UTF-8"?>'
      '<workbook xmlns="http://schemas.openxmlformats.org/'
      'spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/'
      'officeDocument/2006/relationships">'
      '<sheets><sheet name="Участники" sheetId="1" r:id="rId1"/>'
      '<sheet name="Счета" sheetId="2" r:id="rId2"/>'
      '<sheet name="Транзакции" sheetId="3" r:id="rId3"/>'
      '<sheet name="Цели" sheetId="4" r:id="rId4"/>'
      '<sheet name="Долги" sheetId="5" r:id="rId5"/></sheets>'
      '</workbook>';
  static const _workbookRels = '<?xml version="1.0" encoding="UTF-8"?>'
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/'
      'relationships">'
      '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/'
      'officeDocument/2006/relationships/worksheet" '
      'Target="worksheets/sheet1.xml"/>'
      '<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/'
      'officeDocument/2006/relationships/worksheet" '
      'Target="worksheets/sheet2.xml"/>'
      '<Relationship Id="rId3" Type="http://schemas.openxmlformats.org/'
      'officeDocument/2006/relationships/worksheet" '
      'Target="worksheets/sheet3.xml"/>'
      '<Relationship Id="rId4" Type="http://schemas.openxmlformats.org/'
      'officeDocument/2006/relationships/worksheet" '
      'Target="worksheets/sheet4.xml"/>'
      '<Relationship Id="rId5" Type="http://schemas.openxmlformats.org/'
      'officeDocument/2006/relationships/worksheet" '
      'Target="worksheets/sheet5.xml"/>'
      '</Relationships>';
}