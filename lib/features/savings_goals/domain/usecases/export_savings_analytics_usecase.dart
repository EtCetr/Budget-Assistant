import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:archive/archive.dart';
import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:flutter/widgets.dart' show GlobalKey;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';

import '../entities/savings_goal.dart';

/// Экспорт аналитики копилок (ТЗ 6.3.18.13): XLSX (ручной OOXML через
/// package:archive — пакет excel конфликтует с lottie по archive),
/// CSV (UTF-8 BOM), PNG (снимок RepaintBoundary) + нативный Share Sheet.
/// PDF отложен: package:pdf конфликтует с lottie, кириллице нужен TTF-ассет.
/// Privacy: вызов блокируется на уровне UI в hidden-режиме.
class ExportSavingsAnalyticsUseCase {
  ExportSavingsAnalyticsUseCase({required Logger logger}) : _logger = logger;

  final Logger _logger;

  String get _stamp => DateTime.now().toUtc().toIso8601String().substring(0, 10);

  Future<String> exportXlsx({
    required List<SavingsGoal> goals,
    required List<Transaction> transactions,
  }) async {
    try {
      final archive = Archive();
      void add(String name, String content) {
        final bytes = utf8.encode(content);
        archive.addFile(ArchiveFile(name, bytes.length, bytes));
      }
      add('[Content_Types].xml', _contentTypes);
      add('_rels/.rels', _rootRels);
      add('xl/workbook.xml', _workbook);
      add('xl/_rels/workbook.xml.rels', _workbookRels);
      add('xl/worksheets/sheet1.xml', _goalsSheet(goals));
      add('xl/worksheets/sheet2.xml', _txSheet(transactions));
      final zip = ZipEncoder().encode(archive);
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/savings_analytics_$_stamp.xlsx';
      await File(path).writeAsBytes(zip);
      return path;
    } catch (e, st) {
      _logger.e('exportXlsx failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<String> exportCsv({required List<SavingsGoal> goals}) async {
    try {
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
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/savings_goals_$_stamp.csv';
      final bytes = <int>[0xEF, 0xBB, 0xBF, ...utf8.encode(sb.toString())];
      await File(path).writeAsBytes(bytes);
      return path;
    } catch (e, st) {
      _logger.e('exportCsv failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// PNG графика: снимок RepaintBoundary, ключ передаёт UI-слой.
  Future<String> exportPng(GlobalKey chartKey) async {
    try {
      final ctx = chartKey.currentContext;
      if (ctx == null) throw StateError('Chart not rendered yet');
      final renderObject = ctx.findRenderObject();
      if (renderObject is! RenderRepaintBoundary) {
        throw StateError('RepaintBoundary not found in tree');
      }
      final image = await renderObject.toImage(pixelRatio: 3.0);
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) throw StateError('PNG encode returned null');
      final dir = await getTemporaryDirectory();
      final path = '${dir.path}/savings_chart_$_stamp.png';
      await File(path).writeAsBytes(data.buffer.asUint8List());
      return path;
    } catch (e, st) {
      _logger.e('exportPng failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<void> share(String path, String text) async {
    try {
      await SharePlus.instance.share(
        ShareParams(files: [XFile(path)], text: text),
      );
    } catch (e, st) {
      _logger.e('share failed', error: e, stackTrace: st);
      rethrow;
    }
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
    sb.write('<worksheet xmlns="http://schemas.openxmlformats.org/'
        'spreadsheetml/2006/main"><sheetData>');
    sb.write('<row>${_cell('Название')}${_cell('Целевая')}${_cell('Накоплено')}'
        '${_cell('%')}${_cell('Дедлайн')}${_cell('Статус')}</row>');
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

  String _txSheet(List<Transaction> transactions) {
    final sb = StringBuffer();
    sb.write('<?xml version="1.0" encoding="UTF-8"?>');
    sb.write('<worksheet xmlns="http://schemas.openxmlformats.org/'
        'spreadsheetml/2006/main"><sheetData>');
    sb.write('<row>${_cell('Дата')}${_cell('Сумма')}${_cell('Изъятие')}</row>');
    for (final t in transactions) {
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
      '</Types>';

  static const _rootRels = '<?xml version="1.0" encoding="UTF-8"?>'
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/'
      'relationships">'
      '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/'
      'officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>'
      '</Relationships>';

  static const _workbook = '<?xml version="1.0" encoding="UTF-8"?>'
      '<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" '
      'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/'
      'relationships">'
      '<sheets><sheet name="Цели" sheetId="1" r:id="rId1"/>'
      '<sheet name="Пополнения" sheetId="2" r:id="rId2"/></sheets>'
      '</workbook>';

  static const _workbookRels = '<?xml version="1.0" encoding="UTF-8"?>'
      '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/'
      'relationships">'
      '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/'
      'officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>'
      '<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/'
      'officeDocument/2006/relationships/worksheet" Target="worksheets/sheet2.xml"/>'
      '</Relationships>';
}