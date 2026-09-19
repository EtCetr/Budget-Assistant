/// Строки экрана «Цели накопления» (Этап 12).
///
/// Хардкод строк в виджетах запрещён (DECISIONS.md):
/// все тексты берутся только отсюда.
abstract final class SavingsGoalsStrings {
  static const screenTitle = 'Цели накопления';
  static const newGoalTitle = 'Новая цель';
  static const editGoalTitle = 'Редактировать цель';

  // Вкладки
  static const tabActive = 'Активные';
  static const tabArchive = '🗂 Архив';

  // Сводка активных целей
  static const summaryGoals = 'Целей';
  static const summaryTarget = 'Целевая';
  static const summarySaved = 'Накоплено';
  static const summaryStaleRate =
      '⚠️ Курс устарел — суммы могут быть неточными';

  // Статистика архива
  static const archiveStatsSaved = 'Всего накоплено';
  static const archiveStatsProgress = 'Средний прогресс';

  // Фильтры
  static const filterAll = 'Все';
  static const filterVirtual = '💭 Виртуальные';
  static const filterLinked = '🏦 Привязанные';
  static const filterWithDeadline = '⏰ С дедлайном';
  static const filterCompleted = 'Завершённые';
  static const filterCancelled = 'Отменённые';
  static const filterReset = 'Сбросить фильтры';

  // Действия
  static const actionContribute = '💰 Пополнить';
  static const actionWithdraw = '💸 Изъять';
  static const actionRestore = '🔄 Восстановить';
  static const actionArchive = '🗂 Архивировать';
  static const actionEdit = '✏️ Редактировать';
  static const actionHistory = '📜 История';

  // Дедлайн
  static const deadlinePrefix = '📅 до';
  static const overduePrefix = '⚠️ Просрочено на';

  // Листы пополнения/изъятия
  static const contributeTitle = 'Пополнить цель';
  static const withdrawTitle = 'Изъять из цели';
  static const amountLabel = 'Сумма';
  static const amountHint = 'Например, 10 000';
  static const commentLabel = 'Комментарий';
  static const commentHint = 'Необязательно';
  static const accountLabel = 'Счёт';
  static const accountHint = 'Выберите счёт';
  static const noAccountsForCurrency = 'Нет счетов в валюте цели';
  static const draftHint = 'Последняя сумма:';
  static const draftUse = 'Подставить';
  static const withdrawAvailable = 'Доступно для изъятия:';
  static const submitContribute = 'Пополнить';
  static const submitWithdraw = 'Изъять';

  // Диалоги
  static const achievedTitle = '🎉 Цель достигнута!';
  static const continueSaving = 'Продолжить копить';
  static const markCompleted = 'Отметить как завершённую';
  static const restoreTitle = '🔄 Восстановить цель?';
  static const restoreText =
      'Цель будет возвращена в список активных. Вы сможете продолжить пополнение.';
  static const archiveTitle = 'Архивировать цель?';
  static const archiveText =
      'Цель будет скрыта из списка активных и перемещена в архив.';
  static const cancel = 'Отмена';
  static const completedPrefix = 'Завершена';
  static const cancelledPrefix = 'Отменена';

  // Снайкбары
  static const contributeSuccess = 'Пополнение создано';
  static const withdrawSuccess = 'Изъятие создано';
  static const restoreSuccess = 'Цель восстановлена';
  static const archiveSuccess = 'Цель перемещена в архив';
  static const completeSuccess = 'Цель завершена';
  static const operationFailed = 'Не удалось выполнить операцию';

  // Ошибки и валидация
  static const loadingError = 'Не удалось загрузить цели';
  static const retry = 'Повторить';
  static const validationAmount = 'Введите сумму больше нуля';
  static const validationAccount = 'Выберите счёт';
  static const validationTooMuch = 'Нельзя изъять больше, чем накоплено';

  // Приватность
  static const privacyVisible = 'Видимый';
  static const privacyPartial = 'Частичный';
  static const privacyHidden = 'Скрытый';

  // Пустые состояния
  static const emptyAllTitle = 'У вас пока нет финансовых целей';
  static const emptyAllSubtitle =
      'Создайте первую цель и начните копить на мечту. Цели исключаются из расходов и показываются отдельным прогресс-баром';
  static const emptyAllAction = 'Создать первую цель';
  static const emptyActiveTitle = 'Все цели в архиве';
  static const emptyActiveSubtitle =
      'У вас нет активных целей. Переключитесь на вкладку «Архив» или создайте новую цель';
  static const emptyActivePrimary = 'Создать новую цель';
  static const emptyActiveSecondary = 'Перейти в архив';
  static const emptyArchiveTitle = 'Архив пуст';
  static const emptyArchiveSubtitle =
      'Завершённые или отменённые цели будут появляться здесь';
  static const emptyArchiveAction = 'Вернуться к активным';
  static const emptyFilterTitle = 'Нет целей по этому фильтру';
  static const emptyFilterSubtitle =
      'Попробуйте изменить фильтр или создать новую цель';

  // ═══ Форма создания/редактирования (шаг 12.5, ТЗ 6.3.17) ═══
  static const formSectionBasic = 'Основная информация';
  static const formSectionType = 'Тип цели';
  static const formSectionAutomation = 'Автоматизация';
  static const formSectionVisibility = 'Область видимости';
  static const nameLabel = 'Название цели*';
  static const nameHint = 'Например, «Отпуск в Праге»';
  static const emojiTooltip = 'Выберите эмодзи для визуальной идентификации';
  static const emojiNone = 'Без эмодзи';
  static const amountFormLabel = 'Целевая сумма*';
  static const currencyInherited = 'Валюта наследуется от привязанного счёта';
  static const seedBalanceTitle = 'Зачислить текущий баланс счёта в цель';
  static const seedBalanceHint =
      'Накопленное стартует с текущего баланса счёта (разово, при создании)';

  // 12.5.1 (Вариант Б): выбор суммы зачисления
  static const seedAmountLabel = 'Сумма зачисления';
  static const seedAmountHint = 'Пусто = весь баланс';
  static const seedAmountFull = 'Весь баланс';
  static const seedAvailablePrefix = 'Доступно на счёте:';
  static const seedSelectAccountHint =
      'Выберите счёт, чтобы задать сумму зачисления';

  static const deadlineLabel = 'Дедлайн (опционально)';
  static const deadlineChoose = 'Выбрать дату';
  static const deadlineHint = 'Оставьте пустым, если цель без срока';
  static const deadlinePastWarning =
      'Дедлайн уже истёк. Цель появится в списке «Просрочено»';
  static const typeVirtual = '💭 Виртуальная';
  static const typeLinked = '🏦 Привязать к счёту';
  static const typeVirtualHint =
      'Виртуальные цели не привязаны к реальному счёту и существуют только как прогресс-бар';
  static const accountSelectLabel = 'Выберите счёт*';
  static const noAccountsTitle = 'У вас нет подходящих счетов';
  static const noAccountsSubtitle =
      'Для привязки подходят дебетовые, накопительные счета и наличные';
  static const familyNoSharedAccounts =
      'Для семейной привязанной цели нужен счёт с общим балансом';
  static const addAccountAction = 'Добавить счёт';
  static const makeVirtualAction = 'Создать виртуальную цель';
  static const autoReminderTitle = 'Включить автонапоминания';
  static const autoReminderHint =
      'Если в течение месяца не было пополнений, приложение напомнит о цели';
  static const recurringTitle = 'Создать регулярное пополнение';
  static const recurringDisabled = 'Появится на Этапе 14 (регулярные платежи)';
  static const visibilityPersonal = '🔒 Только я';
  static const visibilityFamily = '👨👩‍👧 Вся семья';
  static const visibilityHint =
      'Семейные цели видны всем членам семьи и синхронизируются между устройствами';
  static const familyUnavailable =
      'Сначала присоединитесь к семейному пространству';
  static const saveAction = 'Сохранить';
  static const updateAction = 'Обновить';
  static const goalCreatedSnack = 'Цель создана';
  static const goalUpdatedSnack = 'Цель обновлена';
  static const syncLaterNote = 'Синхронизируется при появлении интернета';
  static const cancelCreateTitle = 'Отменить создание?';
  static const cancelEditTitle = 'Отменить редактирование?';
  static const cancelSubtitle = 'Несохранённые данные будут потеряны.';
  static const continueEditing = 'Продолжить редактирование';
  static const discardAction = 'Отменить';
  static const draftRestoreTitle = 'Найден черновик';
  static const draftRestoreText = 'Восстановить несохранённую форму цели?';
  static const draftRestoreAction = 'Восстановить';
  static const draftStartFresh = 'Начать заново';
  static const planMonthlyPrefix = '💡 Это примерно';
  static const planMonthlySuffix = 'в месяц';
  static const planTenYears = 'если копить 10 лет';
  static const planByDeadline = 'чтобы успеть к дедлайну';
  static const currentAmountLabel = 'Накоплено';
  static const currentAmountTooltip =
      'Прогресс обновляется автоматически при пополнениях';

  // ═══ История цели (микро-коммит 12.6, ТЗ 6.3.47.6) ═══
  static const historySheetTitle = 'История цели';
  static const historyTransactionsHeader = 'Транзакции';
  static const historyContribute = 'Пополнение';
  static const historyWithdraw = 'Изъятие';
  static const historyEmpty = 'По этой цели ещё нет операций';
  static const historyError = 'Не удалось загрузить историю';
  static const historyChartHidden = 'График скрыт в режиме приватности';
  static const historyClose = 'Закрыть';

  // ═══ Аналитика копилок (микро-коммит 12.7.1, ТЗ 6.3.18) ═══
  static const analyticsTitle = 'Аналитика копилок';
  static const periodMonth = 'Месяц';
  static const periodQuarter = 'Квартал';
  static const periodYear = 'Год';
  static const periodAllTime = 'Всё время';
  static const statGoals = 'Целей';
  static const statTarget = 'Целевая';
  static const statSaved = 'Накоплено';
  static const statProgress = 'Прогресс';
  static const statNewInPeriod = 'за период';
  static const statNoChanges = '0 изменений';
  static const statInPeriod = 'за период';
  static const chartTitle = 'Динамика накопления';
  static const chartHiddenNote = 'График скрыт в режиме приватности';
  static const chartEmptyTitle = 'В этом периоде не было пополнений';
  static const chartEmptySubtitle =
      'Попробуйте выбрать другой период или пополните одну из целей';
  static const legendAccumulated = 'Накоплено';
  static const legendTarget = 'Целевая линия';
  static const legendForecast = 'Прогноз';

  static const analyticsEmptySubtitle = 'Создайте первую цель и начните копить. Аналитика появится здесь после первых пополнений';
  static const statActiveSuffix = 'активных';
  static const statIncreasePrefix = '↑';
  static const statDecreasePrefix = '↓';
  static const statVsPrevPeriod = 'vs прошлый период';

  static const exportXlsx = 'Excel (.xlsx)';
  static const exportXlsxSub = 'Полная таблица с целями и пополнениями';
  static const exportShareText = 'Моя аналитика копилок с Budget Assistant 🚀';
  static const exportSuccess = 'Экспорт завершён';
  static const exportFailed = 'Не удалось экспортировать';
  /// Склонение слова «день».
  static String daysLabel(int n) {
    final abs = n.abs();
    final mod10 = abs % 10;
    final mod100 = abs % 100;
    if (mod10 == 1 && mod100 != 11) return 'день';
    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) return 'дня';
    return 'дней';
  }
  static const exportBlocked = 'Экспорт в скрытом режиме невозможен';
  static const exportTitle = 'Экспортировать аналитику';
  static const exportCsv = 'CSV (таблица целей)';
  static const exportCsvSub = 'Для Excel или Google Таблиц';
  static const exportPng = 'PNG (график)';
  static const exportPngSub = 'Скриншот для соцсетей';
  static const exportCancel = 'Отмена';
}
