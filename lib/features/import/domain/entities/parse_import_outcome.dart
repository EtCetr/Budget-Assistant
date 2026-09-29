import 'parsed_file.dart';

/// Исход загрузки файла: успех либо код ошибки для Snackbar.
class ParseImportOutcome {
  const ParseImportOutcome({this.file, this.errorCode});

  const ParseImportOutcome.success(ParsedFile this.file) : errorCode = null;

  /// 'too_large' | 'not_found' | 'parse_error'
  final String? errorCode;
  final ParsedFile? file;

  bool get isSuccess => file != null;
}