import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/import/domain/entities/column_mapping.dart';
import 'package:budget_assistant/features/import/domain/entities/import_options.dart';
import 'package:budget_assistant/features/import/domain/entities/import_result.dart';
import 'package:budget_assistant/features/import/domain/entities/parsed_file.dart';
import 'package:budget_assistant/features/import/domain/entities/parser_config.dart';
import 'package:budget_assistant/features/import/domain/entities/preview_table_data.dart';
import 'package:budget_assistant/features/import/domain/usecases/detect_bank_from_file_usecase.dart';
import 'import_repository_providers.dart';
import 'import_wizard_providers.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/import/data/seeds/default_parser_configs_seed.dart';

/// Состояние wizard'а импорта (4 шага).
class ImportOnboardingState {
  const ImportOnboardingState({
    this.step = 1,
    this.filePath,
    this.fileName,
    this.fileSizeBytes,
    this.fileFormat,
    this.detectedBanks = const [],
    this.selectedConfig,
    this.customBankName,
    this.accountsForBank = const [],
    this.selectedAccountId,
    this.parsedFile,
    this.mapping,
    this.scopeFamily = false,
    this.targetAccountId,
    this.options = const ImportOptions(),
    this.isProcessing = false,
    this.snackMessage,
    this.draftBankName,
  });

  final int step;
  
  /// Шаг 1: файл
  final String? filePath;
  final String? fileName;
  final int? fileSizeBytes;
  final String? fileFormat;
  
  /// Шаг 2: детект банка
  final List<DetectedBank> detectedBanks;
  final ParserConfig? selectedConfig;
  final String? customBankName;
  
  /// Счета для выбранного банка (из app_database.g.dart Account)
  final List<dynamic> accountsForBank;
  final String? selectedAccountId;
  
  /// Шаг 3: маппинг
  final ParsedFile? parsedFile;
  final ColumnMapping? mapping;
  
  /// Шаг 4: счёт
  final bool scopeFamily;
  final String? targetAccountId;
  final ImportOptions options;
  
  final bool isProcessing;
  final String? snackMessage;
  final String? draftBankName;

  bool get canNext {
    switch (step) {
      case 1:
        return filePath != null;
      case 2:
        return (selectedConfig != null || customBankName != null) && 
               selectedAccountId != null;
      case 3:
        return mapping != null && (parsedFile?.parseResult.rows.isNotEmpty ?? false);
      default:
        return targetAccountId != null;
    }
  }

  ImportOnboardingState copyWith({
    int? step,
    String? filePath,
    String? fileName,
    int? fileSizeBytes,
    String? fileFormat,
    List<DetectedBank>? detectedBanks,
    ParserConfig? selectedConfig,
    String? customBankName,
    List<dynamic>? accountsForBank,
    String? selectedAccountId,
    ParsedFile? parsedFile,
    ColumnMapping? mapping,
    bool? scopeFamily,
    String? targetAccountId,
    ImportOptions? options,
    bool? isProcessing,
    String? snackMessage,
    String? draftBankName,
    bool clearFile = false,
    bool clearBank = false,
    bool clearParsed = false,
    bool clearDraft = false,
    bool clearSnack = false,
  }) {
    return ImportOnboardingState(
      step: step ?? this.step,
      filePath: clearFile ? null : (filePath ?? this.filePath),
      fileName: clearFile ? null : (fileName ?? this.fileName),
      fileSizeBytes: clearFile ? null : (fileSizeBytes ?? this.fileSizeBytes),
      fileFormat: clearFile ? null : (fileFormat ?? this.fileFormat),
      detectedBanks: clearBank ? const [] : (detectedBanks ?? this.detectedBanks),
      selectedConfig: clearBank ? null : (selectedConfig ?? this.selectedConfig),
      customBankName: clearBank ? null : (customBankName ?? this.customBankName),
      accountsForBank: accountsForBank ?? this.accountsForBank,
      selectedAccountId: clearBank ? null : (selectedAccountId ?? this.selectedAccountId),
      parsedFile: clearParsed ? null : (parsedFile ?? this.parsedFile),
      mapping: clearParsed ? null : (mapping ?? this.mapping),
      scopeFamily: scopeFamily ?? this.scopeFamily,
      targetAccountId: targetAccountId ?? this.targetAccountId,
      options: options ?? this.options,
      isProcessing: isProcessing ?? this.isProcessing,
      snackMessage: clearSnack ? null : (snackMessage ?? this.snackMessage),
      draftBankName: clearDraft ? null : (draftBankName ?? this.draftBankName),
    );
  }
}

/// Notifier wizard'а: шаги, файл, автодетект банка, маппинг, автосейв.
class ImportOnboardingNotifier extends Notifier<ImportOnboardingState> {
  Timer? _saveTimer;
  Timer? _reparseTimer;
  bool _disposed = false;

  @override
  ImportOnboardingState build() {
    ref.onDispose(() {
      _disposed = true;
      _saveTimer?.cancel();
      _reparseTimer?.cancel();
    });
    Future.microtask(_cleanOldDrafts);
    Future.microtask(_ensureBankConfigs);
    return const ImportOnboardingState();
  }

  /// Идемпотентно доводит сиды банков (Альфа v2, ВТБ, Ozon) даже если
  /// стартовый вызов сида был ограничен пустой таблицей.
  Future<void> _ensureBankConfigs() async {
    try {
      await DefaultParserConfigsSeed.seedIfEmpty(AppDatabase());
    } catch (_) {}
  }

  // === Навигация по шагам ===

  void next() {
    if (!state.canNext) return;
    MotionTokens.selection();
    
    // При переходе на шаг 4 копируем выбранный счёт
    if (state.step == 3) {
      state = state.copyWith(
        step: 4,
        targetAccountId: state.selectedAccountId,
      );
    } else {
      state = state.copyWith(step: state.step + 1);
    }
    
    _scheduleSave();
  }

  void back() {
    if (state.step == 1) return;
    MotionTokens.light();
    state = state.copyWith(step: state.step - 1);
  }

  void clearSnack() => state = state.copyWith(clearSnack: true);

  /// Сброс мастера после успешного импорта (владелец 2026-10):
  /// повторный вход в импорт всегда начинается с шага 1.
  void resetAfterSuccess() {
    _saveTimer?.cancel();
    state = const ImportOnboardingState();
  }

  // === STEP 1: Загрузка файла ===

  Future<void> pickFile() async {
    MotionTokens.medium();
    state = state.copyWith(isProcessing: true, clearSnack: true);
    try {
      final res = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['csv', 'xlsx', 'pdf'],
      );
      final path = res?.files.single.path;
      if (path == null) {
        state = state.copyWith(isProcessing: false);
        return;
      }
      final file = File(path);
      final size = await file.length();
      final ext = path.split('.').last.toLowerCase();
      state = state.copyWith(
        isProcessing: false,
        filePath: path,
        fileName: path.split(Platform.pathSeparator).last,
        fileSizeBytes: size,
        fileFormat: ext,
        clearBank: true,
        clearParsed: true,
      );
      await _detectBank(path);
    } catch (e) {
      state = state.copyWith(
        isProcessing: false,
        snackMessage: 'Ошибка загрузки файла',
      );
    }
  }

  Future<void> _detectBank(String filePath) async {
    try {
      final configs = await ref.read(parserConfigsListProvider.future);
      final useCase = DetectBankFromFileUseCase(logger: ref.read(_loggerProvider));
      final detected = await useCase.call(filePath: filePath, configs: configs);
      if (!_disposed) {
        state = state.copyWith(detectedBanks: detected);
        if (detected.isNotEmpty && detected.first.confidence >= 0.7) {
          final config = configs.firstWhere(
            (c) => c.bankCode == detected.first.bankCode,
            orElse: () => configs.first,
          );
          state = state.copyWith(selectedConfig: config);
          await _loadAccountsForBank(config.bankName);
        }
      }
    } catch (e) {
      if (!_disposed) {
        state = state.copyWith(snackMessage: 'Не удалось определить банк');
      }
    }
  }

  // === STEP 2: Выбор банка и счёта ===

  void selectDetectedBank(String bankCode) {
    MotionTokens.selection();
    final configs = ref.read(parserConfigsListProvider).value ?? [];
    final config = configs.firstWhere(
      (c) => c.bankCode == bankCode,
      orElse: () => configs.first,
    );
    state = state.copyWith(
      selectedConfig: config,
      customBankName: null,
    );
    _loadAccountsForBank(config.bankName);
    _scheduleSave();
  }

  Future<void> _loadAccountsForBank(String bankName) async {
    try {
      final userId = ref.read(currentUserIdProvider);
      final spaceId = state.scopeFamily ? ref.read(currentSpaceIdProvider) : null;
      final allAccounts = await ref.read(
        importTargetAccountsProvider((userId, spaceId, state.scopeFamily)).future,
      );
      final filtered = allAccounts
          .where((a) => a.bankName == bankName)
          .toList();
      if (!_disposed) {
        state = state.copyWith(accountsForBank: filtered);
      }
    } catch (e) {
      if (!_disposed) {
        state = state.copyWith(accountsForBank: const []);
      }
    }
  }

  void selectAccount(String accountId) {
    MotionTokens.selection();
    state = state.copyWith(selectedAccountId: accountId);
    _scheduleSave();
  }

  Future<void> createNewAccount({
    required String accountName,
    required String accountType,
    required String currency,
    int initialBalance = 0,
  }) async {
    MotionTokens.medium();
    state = state.copyWith(isProcessing: true);
    try {
      final userId = ref.read(currentUserIdProvider);
      final spaceId = state.scopeFamily ? ref.read(currentSpaceIdProvider) : null;
      final bankName = state.selectedConfig?.bankName ?? state.customBankName ?? 'Другой банк';
      
      final result = await ref.read(importRepositoryProvider).createAccount(
        name: accountName,
        type: accountType,
        currency: currency,
        initialBalance: initialBalance,
        userId: userId,
        spaceId: spaceId,
        bankName: bankName,
      );
      
      if (!_disposed) {
        ref.invalidate(importTargetAccountsProvider((userId, spaceId, state.scopeFamily)));
        await _loadAccountsForBank(bankName);
        state = state.copyWith(
          isProcessing: false,
          selectedAccountId: result['id'] as String,
          snackMessage: 'Счёт "$accountName" создан',
        );
      }
    } catch (e) {
      if (!_disposed) {
        state = state.copyWith(
          isProcessing: false,
          snackMessage: 'Ошибка создания счёта',
        );
      }
    }
  }

  void setCustomBankName(String name) {
    MotionTokens.selection();
    state = state.copyWith(
      customBankName: name,
      selectedConfig: null,
      accountsForBank: const [],
      selectedAccountId: null,
    );
    _scheduleSave();
  }

  Future<void> createNewBank({
    required String bankName,
    required String bankCode,
    required List<String> formats,
    String? instructionText,
    String? brandColor,
  }) async {
    MotionTokens.medium();
    state = state.copyWith(isProcessing: true);
    try {
      final config = ParserConfig(
        id: 'pc_${DateTime.now().millisecondsSinceEpoch}',
        bankName: bankName,
        bankCode: bankCode,
        isPopular: false,
        usageCount: 0,
        supportedFormats: formats,
        configJson: jsonEncode({
          'csv': {
            'encoding': 'UTF-8',
            'separator': ';',
            'skip_rows': 0,
            'date_format': 'dd.MM.yyyy',
          },
        }),
        instructionText: instructionText,
        brandColor: brandColor,
        detectionPatterns: jsonEncode({
          'keywords': [bankName.toLowerCase()],
          'headers': [],
        }),
        version: 1,
        createdAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      );

      await ref.read(importRepositoryProvider).createParserConfig(config);
      
      if (!_disposed) {
        ref.invalidate(parserConfigsListProvider);
        state = state.copyWith(
          isProcessing: false,
          selectedConfig: config,
          customBankName: null,
          accountsForBank: const [],
          selectedAccountId: null,
          snackMessage: 'Банк "$bankName" добавлен',
        );
      }
    } catch (e) {
      if (!_disposed) {
        state = state.copyWith(
          isProcessing: false,
          snackMessage: 'Ошибка создания банка',
        );
      }
    }
  }

  // === STEP 3: Маппинг ===

  Future<void> parseFileWithConfig() async {
    final config = state.selectedConfig;
    if (config == null || state.filePath == null) return;
    
    MotionTokens.medium();
    state = state.copyWith(isProcessing: true);
    
    try {
      final useCase = ref.read(parseImportFileUseCaseProvider);
      final outcome = await useCase.call(
        sourcePath: state.filePath!,
        config: config,
      );

      if (outcome.isSuccess && outcome.file != null) {
        if (!_disposed) {
          state = state.copyWith(
            isProcessing: false,
            parsedFile: outcome.file,
            mapping: outcome.file!.detectedMapping,
            snackMessage: outcome.file!.detectionConfidence >= 0.8
                ? 'Колонки определены автоматически'
                : 'Проверьте маппинг колонок',
          );
          _scheduleSave();
        }
      } else {
        if (!_disposed) {
          MotionTokens.error();
          state = state.copyWith(
            isProcessing: false,
            snackMessage: 'Не удалось распарсить файл',
          );
        }
      }
    } catch (e) {
      if (!_disposed) {
        state = state.copyWith(
          isProcessing: false,
          snackMessage: 'Ошибка парсинга',
        );
      }
    }
  }

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
    
    if (!_disposed) {
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
  }

  PreviewTableData previewTable() {
    final file = state.parsedFile;
    if (file == null) return const PreviewTableData(columnLabels: [], rows: []);
    return ref.read(previewImportDataUseCaseProvider).call(file.rawRows);
  }

  // === STEP 4: Счёт + опции ===

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

  Future<ImportResult?> launchImport() async {
    final config = state.selectedConfig;
    final mapping = state.mapping;
    final file = state.parsedFile;
    final accountId = state.targetAccountId;
    
    if (config == null || mapping == null || file == null || accountId == null) {
      return null;
    }
    
    MotionTokens.medium();
    state = state.copyWith(isProcessing: true);
    
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
      if (!_disposed) state = state.copyWith(isProcessing: false);
    }
  }

  // === Черновик ===

  void _scheduleSave() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 5), _saveDraft);
  }

  Future<void> _saveDraft() async {
    final config = state.selectedConfig;
    final file = state.filePath;
    if (config == null || file == null) return;
    
    try {
      final userId = ref.read(currentUserIdProvider);
      final mapping = state.mapping;
      
      await ref.read(importRepositoryProvider).saveImportDraft(
        userId: userId,
        bankName: config.bankName,
        filePath: file,
        wizardStateJson: jsonEncode({
          'step': state.step,
          'scopeFamily': state.scopeFamily,
          'targetAccountId': state.targetAccountId,
          'fileFormat': state.fileFormat,
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

  Future<void> _cleanOldDrafts() async {
    try {
      final cutoff = DateTime.now().toUtc().subtract(const Duration(days: 7));
      await ref.read(importDraftsDaoProvider).deleteOlderThan(cutoff);
    } catch (_) {}
  }
}

final importOnboardingProvider =
    NotifierProvider<ImportOnboardingNotifier, ImportOnboardingState>(
        ImportOnboardingNotifier.new);

final _loggerProvider = Provider<Logger>((ref) {
  return Logger(printer: PrettyPrinter(methodCount: 2));
});

