/// Строки экрана аналитики товаров (хардкод в UI запрещён).
abstract final class ProductAnalyticsStrings {
  static const String screenTitle = 'Аналитика товаров';
  static const String periodMonth = 'Месяц';
  static const String periodQuarter = 'Квартал';
  static const String periodYear = 'Год';
  static const String periodAll = 'Всё время';
  static const String scopePersonal = 'Только мои';
  static const String scopeFamily = 'Вся семья';
  static const String tabTopProducts = 'Топ товаров';
  static const String tabCategories = 'Категории';
  static const String tabDynamics = 'Динамика';
  static const String summaryUnique = 'Уникальных товаров:';
  static const String summaryAvgCheck = 'Средний чек:';
  static const String summaryPositions = 'позиции';
  static const String trendRising = 'цена растёт';
  static const String trendStable = 'цена стабильна';
  static const String trendFalling = 'цена падает';
  static const String percentOfTotal = 'от общих трат';
  static const String exportTitle = 'Экспорт аналитики товаров';
  static const String exportCsv = 'CSV (.csv)';
  static const String exportCsvSub =
      'Список товаров с ценами, количеством и категориями';
  static const String exportPng = 'PNG (график)';
  static const String exportPngSub = 'Снимок текущего отчёта';
  static const String exportCancel = 'Отмена';
  static const String exportSuccess = 'Экспорт готов';
  static const String exportFailed = 'Не удалось экспортировать';
  static const String exportBlockedHidden =
      'Экспорт заблокирован в скрытом режиме приватности';
  static const String staleBanner = 'Данные могут быть устаревшими. Обновить?';
  static const String staleUpdate = 'Обновить';
  static const String aggregating = 'Агрегируем данные...';
  static const String emptyPeriodTitle = 'За этот период нет данных';
  static const String emptyPeriodSub =
      'Аналитика товаров работает с распознанными чеками. Отсканируйте первый чек или выберите другой период';
  static const String emptyPeriodCtaScan = 'Отсканировать чек';
  static const String emptyPeriodCtaPeriod = 'Выбрать другой период';
  static const String emptyAllTitle = 'Аналитика товаров ещё недоступна';
  static const String emptyAllSub =
      'Для работы функции отсканируйте первый чек с позициями товаров';
  static const String emptyAllCta = 'Отсканировать первый чек';
  static const String errorTitle = 'Не удалось загрузить аналитику';
  static const String errorSub = 'Проверьте подключение и попробуйте снова';
  static const String errorRetry = 'Повторить';
  static const String detailsStores = 'По магазинам';
  static const String detailsShowAll = 'Показать все покупки';
  static const String detailsClose = 'Закрыть';
  static const String detailsMin = 'Мин:';
  static const String detailsMax = 'Макс:';
  static const String detailsAvg = 'Средняя цена:';
  static const String detailsTrend = 'Тренд:';

  static String showMore(int shown, int total) =>
      'Показать ещё ($shown из $total)';

  static String purchases(int n) {
    final mod100 = n % 100;
    final mod10 = n % 10;
    if (mod100 >= 11 && mod100 <= 14) return '$n покупок';
    if (mod10 == 1) return '$n покупка';
    if (mod10 >= 2 && mod10 <= 4) return '$n покупки';
    return '$n покупок';
  }

  static String itemsPerCheck(double v) =>
      '~${v.toStringAsFixed(1)} позиции в чеке';
}