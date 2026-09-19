import 'dart:io';
import 'package:archive/archive.dart';
import 'package:flutter/widgets.dart' show GlobalKey, RenderRepaintBoundary;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:budget_assistant/features/savings_goals/domain/entities/savings_goal.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';

/// Глобальный ключ RepaintBoundary вокруг графика накопления (для PNG-экспорта).
final GlobalKey chartRepaintBoundaryKey = GlobalKey();

/// Экспорт аналитики копилок: XLSX (2 листа), CSV, PNG (график), шеринг (ТЗ 6.3.18.13).
/// XLSX собирается вручную как OOXML-zip через package:archive (excel-пакет
/// конфликтует с lottie по версии archive).
class ExportSavingsAnalyticsUseCase {
  ExportSavingsAnalyticsUseCase();

  Future<String> exportXlsx({
    required List<SavingsGoal> goals,
    required List<Transaction> transactions,
  }) async {
    final dir = await getTemporaryDirectory();
    final stamp = DateTime.now().toUtc().toIso8601String().substring(0, 10);
    final path = '${dir.path}/savings_analytics_$stamp.xlsx';
    final archive = Archive();
    void add(String name, String content) {
      final bytes = List<int>.from(content.codeUnits);
      archive.addFile(ArchiveFile(name, bytes.length, bytes));
    }
    add('[Content_Types].xml', _contentTypes);
    add('_rels/.rels', _rootRels);
    add('xl/workbook.xml', _workbook);
    add('xl/_rels/workbook.xml.rels', _workbookRels);
    add('xl/worksheets/sheet1.xml', _goalsSheet(goals));
    add('xl/worksheets/sheet2.xml', _txSheet(transactions));
    final zip = ZipEncoder().encode(archive);
    await File(path).writeAsBytes(zip!);
    return path;
  }

  Future<String> exportCsv({required List<SavingsGoal> goals}) async {
    final dir = await getTemporaryDirectory();
    final stamp = DateTime.now().toUtc().toIso8601String().substring(0, 10);
    final path = '${dir.path}/savings_goals_$stamp.csv';
    final sb = StringBuffer();
    sb.writeln('Название,Целевая,Накоплено,Процент,Дедлайн,Статус');
    for (final g in goals) {
      sb.writeln([
        '"${g.name.replaceAll('"', '""')}"',
        g.targetAmount,
        g.currentAmount,
        g.progressPercent,
        g.deadline?.toIso8601String() ?? '',
        g.status,
      ].join(','));
    }
    // UTF-8 с BOM для корректного открытия в Excel
    await File(path).writeAsBytes([0xEF, 0xBB, 0xBF] + sb.toString().codeUnits);
    return path;
  }

  Future<String> exportPng() async {
    final ctx = chartRepaintBoundaryKey.currentContext;
    if (ctx == null) throw StateError('Chart not rendered');
    final boundary = ctx.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final bytes = await image.toByteData();
    if (bytes == null) throw StateError('PNG encode failed');
    final dir = await getTemporaryDirectory();
    final stamp = DateTime.now().toUtc().toIso8601String().substring(0, 10);
    final path = '${dir.path}/savings_chart_$stamp.png';
    await File(path).writeAsBytes(bytes.buffer.asUint8List());
    return path;
  }

  Future<void> share(String path) async {
    await Share.shareXFiles(
      [XFile(path)],
      text: 'Моя аналитика копилок с Budget Assistant 🚀',
    );
  }

  String _esc(String s) => s
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');

  String _cell(String v) => '<c t="inlineStr"><is><t>${_esc(v)}</t></is></c>';

  String _goalsSheet(List<SavingsGoal> goals) {
    final sb = StringBuffer();
    sb.write('<?xml version="1.0" encoding="UTF-8"?>');
    sb.write('<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><sheetData>');
    sb.write('<row>${_cell('Название')}${_cell('Целевая')}${_cell('Накоплено')}${_cell('%')}${_cell('Дедлайн')}${_cell('Статус')}</row>');
    for (final g in goals) {
      sb.write('<row>'
          '${_cell(g.name)}'
          '${_cell(g.targetAmount.toString())}'
          '${_cell(g.currentAmount.toString())}'
          '${_cell(g.progressPercent.toString())}'
          '${_cell(g.deadline?.toIso8601String() ?? '')}'
          '${_cell(g.status)}'
          '</row>');
    }
    sb.write('</sheetData></worksheet>');
    return sb.toString();
  }

  String _txSheet(List<Transaction> tx) {
    final sb = StringBuffer();
    sb.write('<?xml version="1.0" encoding="UTF-8"?>');
    sb.write('<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><sheetData>');
    sb.write('<row>${_cell('Дата')}${_cell('Сумма')}${_cell('Изъятие')}</row>');
    for (final t in tx) {
      sb.write('<row>'
          '${_cell(t.date.toIso8601String())}'
          '${_cell(t.amount.toString())}'
          '${_cell(t.isWithdrawal ? 'да' : 'нет')}'
          '</row>');
    }
    sb.write('</sheetData></worksheet>');
    return sb.toString();
  }

  static const _contentTypes = '<?xml version="1.0" encoding="UTF-8"?>'
      '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
      '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
      '<Default Extension="xml" ContentType="application/xml"/>'
      '<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>'
      '<Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
      '<Override PartName="/xl/worksheets/sheet2.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>'
      '</Types>';

  static const _rootRels = '<?xml version="1.0" encoding="UTF-8"?>'
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
      '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>'
      '</Relationships>';

  static const _workbook = '<?xml version="1.0" encoding="UTF-8"?>'
      '<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">'
      '<sheets><sheet name="Цели" sheetId="1" r:id="rId1"/><sheet name="Пополнения" sheetId="2" r:id="rId2"/></sheets>'
      '</workbook>';

  static const _workbookRels = '<?xml version="1.0" encoding="UTF-8"?>'
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
      '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>'
      '<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet2.xml"/>'
      '</Relationships>';
}