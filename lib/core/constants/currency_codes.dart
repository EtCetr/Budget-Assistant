/// Справочник ISO-кодов валют для селектов (Этап 10).
///
/// Хардкод в UI запрещён (DECISIONS.md): виджеты берут список только отсюда.
/// Авто-курсы приходят из ЦБ РФ (source='CBR'); валюты, которые ЦБ не
/// публикует, закрываются ручными исключениями (меню «Исключения курсов»).
const List<String> kCurrencyCodes = <String>[
  'RUB',
  'USD',
  'EUR',
  'GBP',
  'CHF',
  'CNY',
  'JPY',
  'KZT',
  'BYN',
  'KGS',
  'AMD',
  'AZN',
  'UZS',
  'TRY',
  'AED',
  'THB',
  'INR',
  'IDR',
  'KRW',
  'GEL',
  'ZAR',
  // Латинская Америка
  'BRL',
  'MXN',
  'ARS',
  'CLP',
  'COP',
  'PEN',
  'UYU',
  'BOB',
  'PYG',
  'DOP',
];