import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';

/// Локальные сиды конфигураций банков (заменяют Remote Config до Этапа 25).
/// Идемпотентно: дописывает отсутствующие и обновляет конфиги с меньшей версией.
class DefaultParserConfigsSeed {
  static Future<void> seedIfEmpty(AppDatabase db) async {
    final existing = await db.select(db.parserConfigs).get();
    final byId = {for (final c in existing) c.id: c};
    final configs = _buildConfigs();
    await db.batch((b) {
      for (final c in configs) {
        final cur = byId[c.id];
        if (cur == null || cur.version < c.version) {
          b.insert(db.parserConfigs, c, mode: InsertMode.insertOrReplace);
        }
      }
    });
  }

  static List<ParserConfigDb> _buildConfigs() {
    final now = DateTime.now().toUtc();
    return [_tbank(now), _sber(now), _alfa(now), _yandex(now), _vtb(now), _ozon(now)];
  }

  static ParserConfigDb _tbank(DateTime now) => ParserConfigDb(
        id: 'pc_tbank', bankName: 'Т-Банк', bankCode: 'tbank',
        isPopular: true, usageCount: 0,
        supportedFormats: jsonEncode(['csv', 'xlsx', 'pdf']),
        configJson: jsonEncode({
          'csv': {'encoding': 'UTF-8', 'separator': ';', 'skip_rows': 3, 'date_format': 'dd.MM.yyyy HH:mm:ss'},
          'xlsx': {'sheet_name': 'Выписка', 'skip_rows': 2},
          'pdf': {'regex_patterns': {'date': r'\d{2}\.\d{2}\.\d{4}', 'amount': r'-?\d+[.,]\d{2}'}},
        }),
        instructionText: jsonEncode(['Откройте приложение Т-Банк', 'Раздел «Выписки»', 'Период >= 6 месяцев', 'Экспорт -> CSV/PDF']),
        webExportUrl: 'https://www.tbank.ru', brandColor: '#FFDD2D',
        iconAsset: 'bank_tbank',
        detectionPatterns: jsonEncode({'keywords': ['т-банк', 'tinkoff', 't-bank'], 'headers': ['дата операции', 'сумма', 'описание']}),
        version: 1, createdAt: now, updatedAt: now, syncStatus: 'pending');

  static ParserConfigDb _sber(DateTime now) => ParserConfigDb(
        id: 'pc_sber', bankName: 'Сбер', bankCode: 'sber',
        isPopular: true, usageCount: 0,
        supportedFormats: jsonEncode(['xlsx', 'pdf']),
        configJson: jsonEncode({
          'xlsx': {'sheet_name': 'Лист1', 'skip_rows': 4},
          'pdf': {'regex_patterns': {'date': r'\d{2}\.\d{2}\.\d{4}', 'amount': r'-?\d+[.,]\d{2}'}},
        }),
        instructionText: jsonEncode(['СберБанк Онлайн', '«История операций»', '«Запросить выписку»', 'Скачайте PDF/XLSX']),
        webExportUrl: 'https://online.sberbank.ru', brandColor: '#21A038',
        iconAsset: 'bank_sber',
        detectionPatterns: jsonEncode({'keywords': ['сбер', 'sberbank', 'сбербанк'], 'headers': ['дата проводки', 'сумма', 'наименование']}),
        version: 1, createdAt: now, updatedAt: now, syncStatus: 'pending');

  static ParserConfigDb _alfa(DateTime now) => ParserConfigDb(
        id: 'pc_alfa', bankName: 'Альфа-Банк', bankCode: 'alfa',
        isPopular: true, usageCount: 0,
        supportedFormats: jsonEncode(['csv', 'xlsx']),
        configJson: jsonEncode({
          'csv': {'encoding': 'windows-1251', 'separator': ',', 'skip_rows': 2, 'date_format': 'dd.MM.yyyy'},
          'xlsx': {
            'no_autodetect': true, 'skip_rows': 0, 'date_format': 'dd.MM.yyyy',
            'date_column': 0, 'amount_column': 12, 'merchant_column': 11,
            'category_column': 4, 'hold_column': 1, 'hold_marker': 'HOLD',
          },
        }),
        instructionText: jsonEncode(['Альфа-Банк', '«Выписки и справки»', '«Выписка по счёту»', 'Скачайте XLSX']),
        webExportUrl: 'https://alfabank.ru', brandColor: '#EF3124',
        iconAsset: 'bank_alfa',
        detectionPatterns: jsonEncode({'keywords': ['альфа', 'alfabank', 'альфа-банк'], 'headers': ['дата', 'сумма', 'контрагент']}),
        version: 2, createdAt: now, updatedAt: now, syncStatus: 'pending');

  static ParserConfigDb _yandex(DateTime now) => ParserConfigDb(
        id: 'pc_yandex', bankName: 'Яндекс Банк', bankCode: 'yandex',
        isPopular: true, usageCount: 0,
        supportedFormats: jsonEncode(['pdf']),
        configJson: jsonEncode({
          'pdf': {'regex_patterns': {'date': r'\d{2}\.\d{2}\.\d{4}', 'amount': r'[+\-–]?\s*\d{1,3}(?:[\s ]\d{3})*[.,]\d{2}'}},
        }),
        instructionText: jsonEncode(['Приложение Яндекс Банка', '«Счета»', 'Нужный счёт', '«Выписка»', 'Скачать PDF']),
        webExportUrl: 'https://yabank.yandex.ru', brandColor: '#FC3F1D',
        iconAsset: 'bank_yandex',
        detectionPatterns: jsonEncode({'keywords': ['яндекс банк', 'yandex bank', 'яндекс'], 'headers': ['описание операции', 'дата операции мск', 'сумма в валюте договора']}),
        version: 1, createdAt: now, updatedAt: now, syncStatus: 'pending');

  static ParserConfigDb _vtb(DateTime now) => ParserConfigDb(
        id: 'pc_vtb', bankName: 'ВТБ', bankCode: 'vtb',
        isPopular: true, usageCount: 0,
        supportedFormats: jsonEncode(['pdf']),
        configJson: jsonEncode({
          'pdf': {'regex_patterns': {'date': r'\d{2}\.\d{2}\.\d{4}', 'amount': r'-?\d+[.,]\d{2}'}},
        }),
        instructionText: jsonEncode(['ВТБ Онлайн', '«Выписки»', 'Выберите период', 'Скачайте PDF']),
        webExportUrl: 'https://vtb.ru', brandColor: '#009FDF',
        iconAsset: 'bank_vtb',
        detectionPatterns: jsonEncode({'keywords': ['втб', 'vtb'], 'headers': ['операции по карте', 'дата и время операции']}),
        version: 1, createdAt: now, updatedAt: now, syncStatus: 'pending');

  static ParserConfigDb _ozon(DateTime now) => ParserConfigDb(
        id: 'pc_ozon', bankName: 'Ozon Банк', bankCode: 'ozon',
        isPopular: false, usageCount: 0,
        supportedFormats: jsonEncode(['pdf']),
        configJson: jsonEncode({
          'pdf': {'regex_patterns': {'date': r'\d{2}\.\d{2}\.\d{4}', 'amount': r'-?\d+[.,]\d{2}'}},
        }),
        instructionText: jsonEncode(['Ozon Банк', '«Справки»', '«Справка о движении средств»', 'Скачайте PDF']),
        webExportUrl: 'https://www.ozonbank.ru', brandColor: '#005BFF',
        iconAsset: 'bank_ozon',
        detectionPatterns: jsonEncode({'keywords': ['ozon банк', 'озон банк'], 'headers': ['назначение платежа', 'сумма операции']}),
        version: 1, createdAt: now, updatedAt: now, syncStatus: 'pending');
}