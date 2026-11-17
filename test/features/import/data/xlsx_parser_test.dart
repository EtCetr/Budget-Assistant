import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/import/data/parsers/xlsx_parser.dart';
import 'package:budget_assistant/features/import/domain/entities/column_mapping.dart';

/// Этап 24: XLSX-парсер (ручной OOXML через archive).
/// Проверяются inlineStr, sharedStrings, автоопределение колонок по
/// заголовкам, HOLD-колонка и числовые даты Excel.
void main() {
  late Directory tmp;
  late XlsxParser parser;

  const base = ColumnMapping(
    dateColumnIndex: 0,
    amountColumnIndex: 1,
    merchantColumnIndex: 2,
  );

  setUp(() async {
    tmp = await Directory.systemTemp.createTemp('xlsx_parser_test');
    parser = XlsxParser(logger: Logger(level: Level.off));
  });

  tearDown(() async {
    if (await tmp.exists()) await tmp.delete(recursive: true);
  });

  Future<String> writeXlsx({
    required String sheetXml,
    String? sharedStrings,
  }) async {
    final archive = Archive();
    void add(String name, String content) {
      final bytes = utf8.encode(content);
      archive.addFile(ArchiveFile(name, bytes.length, bytes));
    }

    add('xl/worksheets/sheet1.xml', sheetXml);
    if (sharedStrings != null) {
      add('xl/sharedStrings.xml', sharedStrings);
    }
    final zip = ZipEncoder().encode(archive);
    final file = File('${tmp.path}/sample.xlsx');
    await file.writeAsBytes(zip, flush: true);
    return file.path;
  }

  String cell(String ref, String value, {bool inline = true}) => inline
      ? '<c r="$ref" t="inlineStr"><is><t>$value</t></is></c>'
      : '<c r="$ref"><v>$value</v></c>';

  String sheet(List<List<String>> rows) {
    final sb = StringBuffer('<worksheet><sheetData>');
    for (var r = 0; r < rows.length; r++) {
      sb.write('<row r="${r + 1}">');
      for (var c = 0; c < rows[r].length; c++) {
        sb.write(cell('${String.fromCharCode(65 + c)}${r + 1}', rows[r][c]));
      }
      sb.write('</row>');
    }
    sb.write('</sheetData></worksheet>');
    return sb.toString();
  }

  test('отсутствующий файл — ошибка', () async {
    final r = await parser.parse(
      filePath: '${tmp.path}/missing.xlsx',
      mapping: base,
    );

    expect(r.isSuccess, isFalse);
    expect(r.error, isNotNull);
  });

  test('в архиве нет листа — ошибка', () async {
    final archive = Archive();
    final bytes = utf8.encode('<workbook/>');
    archive.addFile(ArchiveFile('xl/workbook.xml', bytes.length, bytes));
    final file = File('${tmp.path}/no_sheet.xlsx');
    await file.writeAsBytes(ZipEncoder().encode(archive), flush: true);

    final r = await parser.parse(filePath: file.path, mapping: base);

    expect(r.isSuccess, isFalse);
    expect(r.error, contains('лист'));
  });

  test('inlineStr: суммы, даты и мерчант по явному маппингу', () async {
    final path = await writeXlsx(
      sheetXml: sheet([
        ['Col1', 'Col2', 'Col3'],
        ['01.07.2026', '-1500.00', 'Пятёрочка'],
        ['02.07.2026', '20000.00', 'Зарплата'],
      ]),
    );

    final r = await parser.parse(
      filePath: path,
      mapping: base.copyWith(skipRows: 1),
    );

    expect(r.isSuccess, isTrue);
    expect(r.rows.length, 2);
    expect(r.rows[0].amountKopecks, -150000);
    expect(r.rows[0].merchantName, 'Пятёрочка');
    expect(r.rows[1].amountKopecks, 2000000);
  });

  test('sharedStrings резолвятся по индексу', () async {
    final path = await writeXlsx(
      sheetXml: '<worksheet><sheetData>'
          '<row r="1">${cell('A1', 'Col1')}${cell('B1', 'Col2')}'
          '${cell('C1', 'Col3')}</row>'
          '<row r="2"><c r="A2" t="s"><v>0</v></c>'
          '<c r="B2"><v>-1500.00</v></c>'
          '<c r="C2" t="s"><v>1</v></c></row>'
          '</sheetData></worksheet>',
      sharedStrings: '<sst><si><t>01.07.2026</t></si>'
          '<si><t>Пятёрочка</t></si></sst>',
    );

    final r = await parser.parse(
      filePath: path,
      mapping: base.copyWith(skipRows: 1),
    );

    expect(r.rows.single.merchantName, 'Пятёрочка');
    expect(r.rows.single.date.toLocal().day, 1);
  });

  test('заголовки задают колонки, статус даёт HOLD', () async {
    final path = await writeXlsx(
      sheetXml: sheet([
        ['Дата операции', 'Сумма операции', 'Описание', 'Статус'],
        ['01.07.2026', '-1500.00', 'Пятёрочка', 'HOLD'],
        ['02.07.2026', '-200.00', 'Магазин', ''],
      ]),
    );

    final r = await parser.parse(filePath: path, mapping: base);

    expect(r.rows.length, 2);
    expect(r.rows[0].isHold, isTrue);
    expect(r.rows[1].isHold, isFalse);
    expect(r.rows[0].merchantName, 'Пятёрочка');
  });

  test('числовая дата Excel конвертируется в календарную', () async {
    final path = await writeXlsx(
      sheetXml: sheet([
        ['Col1', 'Col2', 'Col3'],
        ['45292', '-100.00', 'Магазин'],
      ]),
    );

    final r = await parser.parse(
      filePath: path,
      mapping: base.copyWith(skipRows: 1),
    );

    final date = r.rows.single.date.toLocal();
    expect(date.year, 2024);
    expect(date.month, 1);
    expect(date.day, 1);
  });

  test('префикс «Категория: …» снимается с описания', () async {
    final path = await writeXlsx(
      sheetXml: sheet([
        ['Col1', 'Col2', 'Col3'],
        ['01.07.2026', '-100.00', 'Категория: Продукты.Пятёрочка'],
      ]),
    );

    final r = await parser.parse(
      filePath: path,
      mapping: base.copyWith(skipRows: 1),
    );

    expect(r.rows.single.merchantName, 'Пятёрочка');
  });
}