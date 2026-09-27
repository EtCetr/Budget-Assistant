/// Строки экрана детекции регулярных платежей (ТЗ 6.3.9).
abstract final class RecurringDetectionStrings {
  static const String screenTitle = 'Обнаружены регулярные платежи';
  static const String helpTitle = 'Как работает автодетект';
  static const String helpText =
      'Приложение анализирует импорт за 6+ месяцев и находит платежи, '
      'которые повторяются ежемесячно с похожей суммой. Кандидаты '
      'группируются по системным категориям. Вы выбираете, что '
      'добавить в регулярные платежи — остальное отклоняется.';
  static const String infoBannerText =
      'Мы проанализировали ваш импорт и нашли платежи, которые '
      'повторяются каждый месяц. Отметьте те, что хотите отслеживать.';
  static const String statsFound = 'Обнаружено';
  static const String statsSelected = 'Выбрано';
  static const String statsSkipped = 'Пропущено';
  static const String confidenceHigh = 'высокая';
  static const String confidenceMedium = 'средняя';
  static const String alreadyAdded = 'уже добавлено';
  static const String monthDayPrefix = '~';
  static const String monthDaySuffix = ' числа';
  static const String occurrencesSuffix = 'списаний';
  static const String rejectAll = 'Отклонить все';
  static const String addSelectedPrefix = 'Добавить выбранные';
  static const String confirmTitlePrefix = 'Добавить ';
  static const String confirmTitleSuffix = ' регулярных платежей?';
  static const String createRemindersOption = 'Создать напоминания об оплате';
  static const String advanceDaysLabel = 'За дней до оплаты:';
  static const String cancel = 'Отмена';
  static const String add = 'Добавить';
  static const String snackbarAddedPrefix = 'Добавлено ';
  static const String snackbarAddedSuffix = ' платежей';
  static const String snackbarDismissed = 'Кандидаты отклонены';
  static const String snackbarAutoDetectOff =
      'Кандидаты отклонены. Автодетект выключен (3 отказа подряд).';
  static const String undo = 'Отменить';
  static const String emptyTitle = 'Нет обнаруженных регулярных платежей';
  static const String emptySubtitle =
      'Импортируйте выгрузку банка или запустите анализ вручную';
  static const String emptyRunAnalysis = 'Запустить анализ';
  static const String emptyClose = 'Закрыть';
  static const String allAddedTitle = 'Всё уже добавлено';
  static const String allAddedSubtitle = 'Новых кандидатов не найдено';
  static const String analyzing = 'Анализируем выписку…';
  static const String groupSubscriptions = 'Подписки';
  static const String groupUtilities = 'Коммунальные и связь';
  static const String groupTransport = 'Транспорт';
  static const String groupCloud = 'Облачные сервисы';
  static const String groupGames = 'Игры';
  static const String groupOther = 'Прочее';
  static const String loadingError = 'Не удалось загрузить кандидатов';
  static const String retry = 'Retry';
  static const String refreshTooltip = 'Запустить анализ выписки';
  static const String indicatorPrefix = 'Обнаружены регулярные платежи: ';
  static const String indicatorCheck = 'Проверить';
}