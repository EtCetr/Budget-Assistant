// lib/features/settings/domain/usecases/export_all_data_usecase.dart
// Этап 21 (ТЗ 6.9 / 6.3.38.9): XLSX-экспорт ВСЕХ данных (3 листа):
// Транзакции / Счета / Цели. Ручной OOXML через package:archive
// (прецедент 12.8 / 18.4). Суммы в копейках + колонка рублей для читаемости.
// D21-37: E2E-расшифровки нет — локально поля открыты (E2E только при sync).
import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/logger.dart';

class ExportAllDataUseCase {
  const ExportAllDataUseCase({required AppDatabase db}) : _db = db;

  final AppDatabase _db;

  String get _stamp => DateTime.now().toUtc().toIso8601String().substring(0, 10);

  Future<String> call() async {
    try {
      final transactions = await _db.select(_db.transactions).get();
      final accounts = await _db.select(_db.accounts).get();
      final goals = await _db.select(_db.savingsGoals).get();
      final categories = await _db.select(_db.categories).get();
      final accountNames = {for (final a in accounts) a.id: a.customName};
      final categoryNames = {for (final c in categories) c.id: c.name};
      transactions.sort((a, b) => a.date.compareTo(b.date));

      final archive = Archive();
      void add(String name, String content) {
        final bytes = utf8.encode(content);
        archive.addFile(ArchiveFile(name, bytes.length, bytes));
      }

      add('[Content_Types].xml', _contentTypes);
      add('_rels/.rels', _rootRels);
      add('xl/workbook.xml', _workbook);
      add('xl/_rels/workbook.xml.rels', _workbookRels);
      add(
        'xl/worksheets/sheet1.xml',
        _txSheet(transactions, accountNames, categoryNames),
      );
      add('xl/worksheets/sheet2.xml', _accountsSheet(accounts));
      add('xl/worksheets/sheet3.xml', _goalsSheet(goals));

      final zip = ZipEncoder().encode(archive);
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/budget_assistant_export_$_stamp.xlsx';
      await File(path).writeAsBytes(zip);
      AppLogger.i('Export all data: $path (${transactions.length} tx)');
      return path;
    } catch (e, st) {
      AppLogger.e('ExportAllDataUseCase failed', e, st);
      rethrow;
    }
  }

  String _rub(int kopecks) {
    final sign = kopecks < 0 ? '-' : '';
    final abs = kopecks.abs();
    return '$sign${abs ~/ 100},${(abs % 100).toString().padLeft(2, '0')}';
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

  String _txSheet(
    List<TransactionDb> rows,
    Map<String, String> accountNames,
    Map<String, String> categoryNames,
  ) {
    final df = DateFormat('yyyy-MM-dd HH:mm');
    final sb = StringBuffer();
    _wrap(sb);
    sb.write('<row>${_cell('Дата')}${_cell('Счёт')}${_cell('Мерчант')}'
        '${_cell('Категория')}${_cell('Сумма (копейки)')}'
        '${_cell('Сумма (рубли)')}${_cell('Валюта')}${_cell('Комментарий')}</row>');
    for (final t in rows) {
      sb.write('<row>'
          '${_cell(df.format(t.date.toLocal()))}'
          '${_cell(accountNames[t.accountId] ?? '')}'
          '${_cell(t.merchantName ?? '')}'
          '${_cell(categoryNames[t.customCategoryId] ?? t.bankCategory ?? '')}'
          '${_cell(t.amount.toString())}'
          '${_cell(_rub(t.amount))}'
          '${_cell(t.originalCurrency ?? 'RUB')}'
          '${_cell(t.comment ?? '')}'
          '</row>');
    }
    sb.write('</sheetData></worksheet>');
    return sb.toString();
  }

  String _accountsSheet(List<Account> rows) {
    final sb = StringBuffer();
    _wrap(sb);
    sb.write('<row>${_cell('Название')}${_cell('Банк')}${_cell('Тип')}'
        '${_cell('Баланс (копейки)')}${_cell('Баланс (рубли)')}'
        '${_cell('Валюта')}</row>');
    for (final a in rows) {
      sb.write('<row>'
          '${_cell(a.customName)}'
          '${_cell(a.bankName)}'
          '${_cell(a.accountType)}'
          '${_cell(a.currentBalance.toString())}'
          '${_cell(_rub(a.currentBalance))}'
          '${_cell(a.currency)}'
          '</row>');
    }
    sb.write('</sheetData></worksheet>');
    return sb.toString();
  }

  String _goalsSheet(List<SavingsGoalDb> rows) {
    final sb = StringBuffer();
    _wrap(sb);
    sb.write('<row>${_cell('Название')}${_cell('Цель (коп)')}'
        '${_cell('Накоплено (коп)')}${_cell('Прогресс %')}'
        '${_cell('Дедлайн')}${_cell('Статус')}</row>');
    for (final g in rows) {
      final percent =
          g.targetAmount > 0 ? (g.currentAmount * 100 ~/ g.targetAmount) : 0;
      sb.write('<row>'
          '${_cell(g.name)}'
          '${_cell(g.targetAmount.toString())}'
          '${_cell(g.currentAmount.toString())}'
          '${_cell(percent.toString())}'
          '${_cell(g.deadline?.toIso8601String() ?? '')}'
          '${_cell(g.status)}'
          '</row>');
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
      '<sheets><sheet name="Транзакции" sheetId="1" r:id="rId1"/>'
      '<sheet name="Счета" sheetId="2" r:id="rId2"/>'
      '<sheet name="Цели" sheetId="3" r:id="rId3"/></sheets>'
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
      '</Relationships>';
}