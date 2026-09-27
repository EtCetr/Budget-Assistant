import 'dart:convert';

import 'package:budget_assistant/core/database/app_database.dart';

/// Локальные сиды конфигураций банков.
/// Заменяют Remote Config до Этапа 25 (как holidays seed).
class DefaultParserConfigsSeed {
  static Future<void> seedIfEmpty(AppDatabase db) async {
    final count = await (db.select(db.parserConfigs)).get();
    if (count.isNotEmpty) return;

    final configs = _buildConfigs();
    await db.batch((b) => b.insertAll(db.parserConfigs, configs));
  }

  static List<ParserConfigDb> _buildConfigs() {
    final now = DateTime.now().toUtc();
    return [
      _tbank(now),
      _sber(now),
      _alfa(now),
    ];
  }

  static ParserConfigDb _tbank(DateTime now) {
    return ParserConfigDb(
      id: 'pc_tbank',
      bankName: 'Т-Банк',
      bankCode: 'tbank',
      isPopular: true,
      usageCount: 0,
      supportedFormats: jsonEncode(['csv', 'xlsx', 'pdf']),
      configJson: jsonEncode({
        'csv': {
          'encoding': 'UTF-8',
          'separator': ';',
          'skip_rows': 3,
          'date_format': 'dd.MM.yyyy HH:mm:ss',
        },
        'xlsx': {'sheet_name': 'Выписка', 'skip_rows': 2},
        'pdf': {
          'regex_patterns': {
            'date': r'\d{2}\.\d{2}\.\d{4}',
            'amount': r'-?\d+[.,]\d{2}',
            'merchant': r'[A-Za-zА-Яа-я0-9\s\.\-]+',
          },
        },
      }),
      instructionText: jsonEncode([
        'Откройте приложение Т-Банк',
        'Перейдите в раздел «Выписки»',
        'Выберите период (рекомендуем >= 6 месяцев)',
        'Нажмите «Экспорт» -> «CSV»',
        'Сохраните файл',
      ]),
      webExportUrl: 'https://www.tbank.ru',
      brandColor: '#FFDD2D',
      iconAsset: 'bank_tbank',
      version: 1,
      createdAt: now,
      updatedAt: now,
      syncStatus: 'pending',
    );
  }

  static ParserConfigDb _sber(DateTime now) {
    return ParserConfigDb(
      id: 'pc_sber',
      bankName: 'Сбер',
      bankCode: 'sber',
      isPopular: true,
      usageCount: 0,
      supportedFormats: jsonEncode(['xlsx', 'pdf']),
      configJson: jsonEncode({
        'xlsx': {'sheet_name': 'Лист1', 'skip_rows': 4},
        'pdf': {
          'regex_patterns': {
            'date': r'\d{2}\.\d{2}\.\d{4}',
            'amount': r'-?\d+[.,]\d{2}',
            'merchant': r'[A-Za-zА-Яа-я0-9\s\.\-]+',
          },
        },
      }),
      instructionText: jsonEncode([
        'Откройте СберБанк Онлайн',
        'Перейдите в «История операций»',
        'Нажмите «Запросить выписку»',
        'Выберите период и формат',
        'Скачайте файл',
      ]),
      webExportUrl: 'https://online.sberbank.ru',
      brandColor: '#21A038',
      iconAsset: 'bank_sber',
      version: 1,
      createdAt: now,
      updatedAt: now,
      syncStatus: 'pending',
    );
  }

  static ParserConfigDb _alfa(DateTime now) {
    return ParserConfigDb(
      id: 'pc_alfa',
      bankName: 'Альфа-Банк',
      bankCode: 'alfa',
      isPopular: true,
      usageCount: 0,
      supportedFormats: jsonEncode(['csv', 'xlsx']),
      configJson: jsonEncode({
        'csv': {
          'encoding': 'windows-1251',
          'separator': ',',
          'skip_rows': 2,
          'date_format': 'dd.MM.yyyy',
        },
        'xlsx': {'sheet_name': 'Sheet1', 'skip_rows': 1},
      }),
      instructionText: jsonEncode([
        'Откройте Альфа-Банк',
        'Перейдите в «Выписки и справки»',
        'Выберите «Выписка по счёту»',
        'Укажите период и формат',
        'Скачайте файл',
      ]),
      webExportUrl: 'https://alfabank.ru',
      brandColor: '#EF3124',
      iconAsset: 'bank_alfa',
      version: 1,
      createdAt: now,
      updatedAt: now,
      syncStatus: 'pending',
    );
  }
}