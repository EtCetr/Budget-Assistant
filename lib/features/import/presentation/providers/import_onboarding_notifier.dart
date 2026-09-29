import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/import/domain/entities/column_mapping.dart';
import 'package:budget_assistant/features/import/domain/entities/import_options.dart';
import 'package:budget_assistant/features/import/domain/entities/import_result.dart';
import 'package:budget_assistant/features/import/domain/entities/parsed_file.dart';
import 'package:budget_assistant/features/import/domain/entities/parser_config.dart';
import 'package:budget_assistant/features/import/domain/entities/preview_table_data.dart';
import 'import_repository_providers.dart';
import 'import_wizard_providers.dart';

/// Состояние wizard'а импорта (4 шага).
class ImportOnboardingState {
  const ImportOnboardingState({
    this.step = 1,
    this.searchQuery = '',
    this.selectedConfig,
    this.format = 'csv',
    this.parsedFile,
    this.mapping,
    this.scopeFamily = false,
    this.targetAccountId,
    this.options = const ImportOptions(),
    this.isParsing = false,
    this.isLaunching = false,
    this.parseErrorCode,
    this.snackMessage,
    this.draftBankName,
  });

  final int step;
  final String searchQuery;
  final ParserConfig? selectedConfig;
  final String format;
  final ParsedFile? parsedFile;
  final ColumnMapping? mapping;
  final bool scopeFamily;
  final String? targetAccountId;
  final ImportOptions options;
  final bool isParsing;
  final bool isLaunching;
  final String? parseErrorCode;
  final String? snackMessage;
  final String? draftBankName;

  bool get canNext {
    switch (step) {
      case 1:
        return selectedConfig != null;
      case 2:
        return parsedFile != null;
      case 3:
        return mapping != null && (parsedFile?.parseResult.rows.isNotEmpty ?? false);
      default:
        return targetAccountId != null;
    }
  }

  ImportOnboardingState copyWith({
    int? step,
    String? searchQuery,
    ParserConfig? selectedConfig,
    String? format,
    ParsedFile? parsedFile,
    ColumnMapping? mapping,
    bool? scopeFamily,
    String? targetAccountId,
    ImportOptions? options,
    bool? isParsing,
    bool? isLaunching,
    String? parseErrorCode,
    String? snackMessage,
    String? draftBankName,
    bool clearParsed = false,
    bool clearDraft = false,
    bool clearSnack = false,
    bool clearError = false,
  }) {
    return ImportOnboardingState(
      step: step ?? this.step,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedConfig: selectedConfig ?? this.selectedConfig,
      format: format ?? this.format,
      parsedFile: clearParsed ? null : (parsedFile ?? this.parsedFile),
      mapping: clearParsed ? null : (mapping ?? this.mapping),
      scopeFamily: scopeFamily ?? this.scopeFamily,
      targetAccountId: targetAccountId ?? this.targetAccountId,
      options: options ?? this.options,
      isParsing: isParsing ?? this.isParsing,
      isLaunching: isLaunching ?? this.isLaunching,
      parseErrorCode: clearError ? null : (parseErrorCode ?? this.parseErrorCode),
      snackMessage: clearSnack ? null : (snackMessage ?? this.snackMessage),
      draftBankName: clearDraft ? null : (draftBankName ?? this.draftBankName),
    );
  }
}

/// Notifier wizard'а: шаги, файл, маппинг, автосейв черновика каждые 5 сек.
class ImportOnboardingNotifier extends Notifier<ImportOnboardingState> {
  bool _disposed = false;
  Timer? _saveTimer;
  Timer? _reparseTimer;

  @override
  ImportOnboardingState build() {
    ref.onDispose(() {
      _disposed = true;
      _saveTimer?.cancel();
      _reparseTimer?.cancel();
    });
    Future.microtask(_checkDraft);
    return const ImportOnboardingState();
  }

  // === Навигация по шагам ===

  void next() {
    if (!state.canNext) return;
    MotionTokens.selection();
    state = state.copyWith(step: state.step + 1);
    _scheduleSave();
  }

  void back() {
    if (state.step == 1) return;
    MotionTokens.light();
    state = state.copyWith(step: state.step - 1);
  }

  void clearSnack() => state = state.copyWith(clearSnack: true);

  // === STEP 1 ===

  void setSearch(String q) => state = state.copyWith(searchQuery: q);

  void selectConfig(ParserConfig config) {
    MotionTokens.selection();
    final format = config.supportedFormats.isNotEmpty
        ? config.supportedFormats.first
        : 'csv';
    state = state.copyWith(
      selectedConfig: config,
      format: format,
      clearParsed: true,
    );
    _scheduleSave();
  }

  void setFormat(String format) {
    MotionTokens.light();
    state = state.copyWith(format: format, clearParsed: true);
    _scheduleSave();
  }

  // === STEP 2 ===

  Future<void> pickFile() async {
    final config = state.selectedConfig;
    if (config == null) return;
    MotionTokens.medium();
    state = state.copyWith(isParsing: true, clearError: true);
    try {
      final path = await _pickFilePath();
      if (path == null) {
        state = state.copyWith(isParsing: false);
        return;
      }
      final outcome = await ref
          .read(parseImportFileUseCaseProvider)
          .call(sourcePath: path, config: config);
      if (outcome.isSuccess && outcome.file != null) {
        state = state.copyWith(
          isParsing: false,
          parsedFile: outcome.file,
          mapping: outcome.file!.detectedMapping,
          snackMessage: outcome.file!.detectionConfidence >= 0.8
              ? 'Колонки определены автоматически'
              : 'Проверьте маппинг колонок на шаге 3',
        );
        _scheduleSave();
      } else {
        MotionTokens.error();
        state = state.copyWith(
          isParsing: false,
          parseErrorCode: outcome.errorCode ?? 'parse_error',
        );
      }
    } catch (_) {
      MotionTokens.error();
      state = state.copyWith(isParsing: false, parseErrorCode: 'parse_error');
    }
  }

  /// file_picker менял API между мажорными версиями
  /// (platform -> instance -> static). Динамический диспетчер
  /// гарантирует компиляцию и работу с любой установленной версией.
  Future<String?> _pickFilePath() async {
    const exts = ['csv', 'xlsx', 'pdf'];
    dynamic result;
    try {
      // Современный static API (file_picker 11+).
      result = await (FilePicker as dynamic).pickFiles(
        type: FileType.custom,
        allowedExtensions: exts,
      );
    } catch (_) {
      // Старые версии: instance / platform.
      dynamic picker;
      try {
        picker = (FilePicker as dynamic).instance;
      } catch (_) {
        picker = (FilePicker as dynamic).platform;
      }
      result = await picker.pickFiles(
        type: FileType.custom,
        allowedExtensions: exts,
      );
    }
    if (result == null) return null;
    final dynamic files = result.files;
    if (files == null || (files as List).isEmpty) return null;
    return (files as List).single.path as String?;
  }
  // === STEP 3 ===

  void updateMapping(ColumnMapping mapping) {
    state = state.copyWith(mapping: mapping);
    _reparseTimer?.cancel();
    _reparseTimer = Timer(const Duration(milliseconds: 500), _reparse);
    _scheduleSave();
  }

  Future<void> _reparse() async {
    final file = state.parsedFile;
    final mapping = state.mapping;
    final config = state.selectedConfig;
    if (file == null || mapping == null || config == null) return;
    final result = await ref.read(parseImportFileUseCaseProvider).reparse(
          storedPath: file.storedPath,
          format: file.format,
          configJson: config.configJson,
          mapping: mapping,
        );
    if (_disposed) return;
    state = state.copyWith(
      parsedFile: ParsedFile(
        storedPath: file.storedPath,
        fileName: file.fileName,
        fileSizeBytes: file.fileSizeBytes,
        format: file.format,
        rawRows: result.rawRows.isEmpty ? file.rawRows : result.rawRows,
        detectedMapping: state.mapping ?? file.detectedMapping,
        detectionConfidence: file.detectionConfidence,
        parseResult: result,
      ),
    );
    _scheduleSave();
  }

  PreviewTableData previewTable() {
    final file = state.parsedFile;
    if (file == null) return const PreviewTableData(columnLabels: [], rows: []);
    return ref.read(previewImportDataUseCaseProvider).call(file.rawRows);
  }

  List<String> currentInstructions() {
    final raw = state.selectedConfig?.instructionText;
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) return decoded.map((e) => e.toString()).toList();
    } catch (_) {}
    return const [];
  }

  // === STEP 4 ===

  void setScopeFamily(bool family) {
    MotionTokens.selection();
    state = state.copyWith(scopeFamily: family, targetAccountId: null);
    _scheduleSave();
  }

  void setTargetAccount(String id) {
    MotionTokens.selection();
    state = state.copyWith(targetAccountId: id);
    _scheduleSave();
  }

  void setOptions(ImportOptions options) {
    state = state.copyWith(options: options);
    _scheduleSave();
  }

  /// Запуск детекций -> ImportResult (запись в БД — на review, 15.4).
  Future<ImportResult?> launchImport() async {
    final config = state.selectedConfig;
    final mapping = state.mapping;
    final file = state.parsedFile;
    final accountId = state.targetAccountId;
    if (config == null || mapping == null || file == null || accountId == null) {
      return null;
    }
    MotionTokens.medium();
    state = state.copyWith(isLaunching: true);
    try {
      final userId = ref.read(currentUserIdProvider);
      final spaceId = state.scopeFamily ? ref.read(currentSpaceIdProvider) : null;
      final result = await ref.read(importTransactionsUseCaseProvider).call(
            storedPath: file.storedPath,
            format: file.format,
            config: config,
            mapping: mapping,
            targetAccountId: accountId,
            targetSpaceId: spaceId,
            userId: userId,
            options: state.options,
          );
      if (result != null) {
        await ref.read(importRepositoryProvider).incrementParserUsage(config.id);
        await ref.read(importRepositoryProvider).deleteImportDraft(userId);
        MotionTokens.heavy();
      } else {
        MotionTokens.error();
      }
      return result;
    } catch (_) {
      MotionTokens.error();
      return null;
    } finally {
      if (!_disposed) state = state.copyWith(isLaunching: false);
    }
  }

  // === Черновик (автосейв 5 сек) ===

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 5), _saveDraft);
  }

  Future<void> _saveDraft() async {
    final config = state.selectedConfig;
    final file = state.parsedFile;
    if (config == null || file == null) return;
    try {
      final userId = ref.read(currentUserIdProvider);
      final mapping = state.mapping;
      await ref.read(importRepositoryProvider).saveImportDraft(
            userId: userId,
            bankName: config.bankName,
            filePath: file.storedPath,
            wizardStateJson: jsonEncode({
              'step': state.step,
              'scopeFamily': state.scopeFamily,
              'targetAccountId': state.targetAccountId,
              'format': state.format,
              'bankCode': config.bankCode,
              'options': [
                state.options.detectDuplicates,
                state.options.detectTransfers,
                state.options.checkSecrecy,
                state.options.autoCategorize,
                state.options.detectRecurring,
              ],
            }),
            mappingJson: mapping == null ? null : jsonEncode({
              'date': mapping.dateColumnIndex,
              'amount': mapping.amountColumnIndex,
              'merchant': mapping.merchantColumnIndex,
              'category': mapping.categoryColumnIndex,
              'comment': mapping.commentColumnIndex,
              'currency': mapping.currencyColumnIndex,
              'dateFormat': mapping.dateFormat,
              'sep': mapping.csvSeparator,
              'enc': mapping.encoding,
              'skip': mapping.skipRows,
              'neg': mapping.expenseIsNegative,
            }),
          );
    } catch (_) {}
  }

  Future<void> _checkDraft() async {
    try {
      final userId = ref.read(currentUserIdProvider);
      final draft = await ref.read(importRepositoryProvider).getImportDraft(userId);
      final bankName = draft?['bankName'] as String?;
      if (bankName != null && !_disposed) {
        state = state.copyWith(draftBankName: bankName);
      }
    } catch (_) {}
  }

  void dismissDraft() {
    final userId = ref.read(currentUserIdProvider);
    ref.read(importRepositoryProvider).deleteImportDraft(userId);
    state = state.copyWith(clearDraft: true);
  }

  Future<void> restoreDraft() async {
    state = state.copyWith(clearDraft: true, isParsing: true);
    try {
      final userId = ref.read(currentUserIdProvider);
      final draft = await ref.read(importRepositoryProvider).getImportDraft(userId);
      if (draft == null) {
        state = state.copyWith(isParsing: false);
        return;
      }
      final wizard = (jsonDecode(draft['wizardStateJson'] as String? ?? '{}')
          as Map<String, dynamic>);
      final bankCode = wizard['bankCode'] as String?;
      final configs = await ref.read(fetchParserConfigsUseCaseProvider).call();
      final config = configs.where((c) => c.bankCode == bankCode).firstOrNull;
      final storedPath = draft['filePath'] as String?;
      if (config == null || storedPath == null || !File(storedPath).existsSync()) {
        state = state.copyWith(
          isParsing: false,
          snackMessage: 'Черновик устарел, начните заново',
        );
        return;
      }
      ColumnMapping mapping = const ColumnMapping(
        dateColumnIndex: 0,
        amountColumnIndex: 1,
        merchantColumnIndex: 2,
      );
      final rawMapping =
          jsonDecode(draft['mappingJson'] as String? ?? '{}') as Map<String, dynamic>;
      if (rawMapping.isNotEmpty) {
        mapping = ColumnMapping(
          dateColumnIndex: (rawMapping['date'] as int?) ?? 0,
          amountColumnIndex: (rawMapping['amount'] as int?) ?? 1,
          merchantColumnIndex: (rawMapping['merchant'] as int?) ?? 2,
          categoryColumnIndex: rawMapping['category'] as int?,
          commentColumnIndex: rawMapping['comment'] as int?,
          currencyColumnIndex: rawMapping['currency'] as int?,
          dateFormat: (rawMapping['dateFormat'] as String?) ?? 'dd.MM.yyyy',
          csvSeparator: (rawMapping['sep'] as String?) ?? ';',
          encoding: (rawMapping['enc'] as String?) ?? 'UTF-8',
          skipRows: (rawMapping['skip'] as int?) ?? 0,
          expenseIsNegative: (rawMapping['neg'] as bool?) ?? true,
        );
      }
      final format = (wizard['format'] as String?) ?? 'csv';
      final result = await ref.read(parseImportFileUseCaseProvider).reparse(
            storedPath: storedPath,
            format: format,
            configJson: config.configJson,
            mapping: mapping,
          );
      final opts = wizard['options'] as List<dynamic>?;
      state = state.copyWith(
        isParsing: false,
        selectedConfig: config,
        format: format,
        step: (wizard['step'] as int?) ?? 2,
        scopeFamily: (wizard['scopeFamily'] as bool?) ?? false,
        targetAccountId: wizard['targetAccountId'] as String?,
        options: opts == null
            ? const ImportOptions()
            : ImportOptions(
                detectDuplicates: (opts.elementAtOrNull(0) as bool?) ?? true,
                detectTransfers: (opts.elementAtOrNull(1) as bool?) ?? true,
                checkSecrecy: (opts.elementAtOrNull(2) as bool?) ?? true,
                autoCategorize: (opts.elementAtOrNull(3) as bool?) ?? true,
                detectRecurring: (opts.elementAtOrNull(4) as bool?) ?? true,
              ),
        mapping: mapping,
        parsedFile: ParsedFile(
          storedPath: storedPath,
          fileName: storedPath.split(Platform.pathSeparator).last,
          fileSizeBytes: File(storedPath).lengthSync(),
          format: format,
          rawRows: result.rawRows,
          detectedMapping: mapping,
          detectionConfidence: 0,
          parseResult: result,
        ),
        snackMessage: 'Черновик восстановлен',
      );
    } catch (_) {
      state = state.copyWith(isParsing: false);
    }
  }
}

final importOnboardingProvider =
    NotifierProvider<ImportOnboardingNotifier, ImportOnboardingState>(
        ImportOnboardingNotifier.new);

/// Поиск банков: пусто -> весь список, иначе LIKE по bank_name.
final bankSearchProvider =
    FutureProvider.family<List<ParserConfig>, String>((ref, query) async {
  final useCase = ref.watch(fetchParserConfigsUseCaseProvider);
  return query.trim().isEmpty ? useCase.call() : useCase.search(query);
});