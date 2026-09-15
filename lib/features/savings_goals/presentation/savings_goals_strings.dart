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
  static const visibilityFamily = '👨‍👩‍👧 Вся семья';
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

  /// Склонение слова «день».
  static String daysLabel(int n) {
    final abs = n.abs();
    final mod10 = abs % 10;
    final mod100 = abs % 100;
    if (mod10 == 1 && mod100 != 11) return 'день';
    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) return 'дня';
    return 'дней';
  }
}