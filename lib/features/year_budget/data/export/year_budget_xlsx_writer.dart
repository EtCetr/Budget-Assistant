import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import 'package:logger/logger.dart';

/// Ячейка листа: текст ИЛИ число (копейки конвертируются в рубли заранее).
class XlsxCell {
  const XlsxCell.text(this.text) : number = null;
  const XlsxCell.num(this.number) : text = null;
  final String? text;
  final double? number;
}

class XlsxSheetSpec {
  const XlsxSheetSpec({required this.name, required this.rows});
  final String name;
  final List<List<XlsxCell>> rows;
}

/// Ручной OOXML-writer (прецедент Этапа 12.8): zip через package:archive,
/// строки — inlineStr, без sharedStrings.
class YearBudgetXlsxWriter {
  YearBudgetXlsxWriter({required Logger logger}) : _logger = logger;
  final Logger _logger;

  Future<String> write({
    required String fileName,
    required List<XlsxSheetSpec> sheets,
  }) async {
    try {
      final archive = Archive();
      void add(String name, String content) {
        final bytes = utf8.encode(content);
        archive.addFile(ArchiveFile(name, bytes.length, bytes));
      }

      add('[Content_Types].xml', '<?xml version="1.0" encoding="UTF-8"?>'
          '<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">'
          '<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>'
          '<Default Extension="xml" ContentType="application/xml"/>'
          '<Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>'
          '${List.generate(sheets.length, (i) => '<Override PartName="/xl/worksheets/sheet${i + 1}.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>').join()}'
          '</Types>');
      add('_rels/.rels', '<?xml version="1.0" encoding="UTF-8"?>'
          '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
          '<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>'
          '</Relationships>');
      add('xl/workbook.xml', '<?xml version="1.0" encoding="UTF-8"?>'
          '<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" '
          'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">'
          '<sheets>${List.generate(sheets.length, (i) => '<sheet name="${_esc(sheets[i].name)}" sheetId="${i + 1}" r:id="rId${i + 1}"/>').join()}</sheets>'
          '</workbook>');
      add('xl/_rels/workbook.xml.rels', '<?xml version="1.0" encoding="UTF-8"?>'
          '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
          '${List.generate(sheets.length, (i) => '<Relationship Id="rId${i + 1}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet${i + 1}.xml"/>').join()}'
          '</Relationships>');
      for (var i = 0; i < sheets.length; i++) {
        add('xl/worksheets/sheet${i + 1}.xml', _sheetXml(sheets[i]));
      }
      final bytes = ZipEncoder().encode(archive);
      final file = File(
          '${Directory.systemTemp.path}${Platform.pathSeparator}$fileName');
      await file.writeAsBytes(bytes, flush: true);
      return file.path;
    } catch (e, st) {
      _logger.e('XlsxWriter failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  String _sheetXml(XlsxSheetSpec sheet) {
    final sb = StringBuffer('<?xml version="1.0" encoding="UTF-8"?>'
        '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">'
        '<sheetData>');
    for (var r = 0; r < sheet.rows.length; r++) {
      sb.write('<row r="${r + 1}">');
      for (var c = 0; c < sheet.rows[r].length; c++) {
        final ref = '${_col(c)}${r + 1}';
        final cell = sheet.rows[r][c];
        if (cell.number != null) {
          sb.write('<c r="$ref"><v>${cell.number}</v></c>');
        } else {
          sb.write('<c r="$ref" t="inlineStr"><is><t>${_esc(cell.text ?? '')}</t></is></c>');
        }
      }
      sb.write('</row>');
    }
    sb.write('</sheetData></worksheet>');
    return sb.toString();
  }

  String _col(int index) {
    var n = index + 1;
    var s = '';
    while (n > 0) {
      final rem = (n - 1) % 26;
      s = String.fromCharCode(65 + rem) + s;
      n = (n - 1) ~/ 26;
    }
    return s;
  }

  String _esc(String v) => v
      .replaceAll('&', '&amp;')
      .replaceAll('<', '&lt;')
      .replaceAll('>', '&gt;')
      .replaceAll('"', '&quot;');
}