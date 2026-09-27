/// Строки экранов напоминаний (без хардкода в виджетах).
abstract final class RemindersStrings {
  static const String screenTitle = 'Напоминания';
  static const String detailsTitle = 'Детали напоминания';
  static const String createTitle = 'Новое напоминание';
  static const String editTitle = 'Редактировать напоминание';
  static const String fromRecurringTitle = 'Из регулярного платежа';
  static const String tabUpcoming = 'Предстоящие';
  static const String tabHistory = 'История';
  static const String filterAll = 'Все';
  static const String filterMine = 'Только мои';
  static const String filterAssigned = 'Назначенные мне';
  static const String filterOverdue = 'Просрочено';
  static const String badgeOverdue = 'Просрочено';
  static const String badgePersonal = 'Личное';
  static const String badgeFamily = 'Семейное';
  static const String swipeDone = 'Выполнено';
  static const String snackbarDone = 'Задача выполнена';
  static const String snackbarUndo = 'Отменить';
  static const String snackbarCreated = 'Напоминание создано';
  static const String snackbarUpdated = 'Напоминание обновлено';
  static const String snackbarDeleted = 'Напоминание удалено';
  static const String menuOpen = 'Открыть';
  static const String menuEdit = 'Редактировать';
  static const String menuSnooze = 'Отложить';
  static const String menuDelete = 'Удалить';
  static const String menuGoRecurring = 'Перейти к регулярному платежу';
  static const String deleteConfirmTitle = 'Удалить напоминание?';
  static const String deleteConfirmText =
      'Напоминание и запланированные уведомления будут удалены.';
  static const String cancel = 'Отмена';
  static const String delete = 'Удалить';
  static const String fabCustom = 'Кастомное событие';
  static const String fabFromRecurring = 'Из регулярного платежа';
  static const String emptyAllTitle = 'Нет напоминаний';
  static const String emptyAllSubtitle =
      'Создайте первое напоминание или подключите регулярные платежи';
  static const String emptyAllAction = 'Создать напоминание';
  static const String emptyAllSecondary = 'Из регулярного платежа';
  static const String emptyDoneTitle = 'Все задачи выполнены';
  static const String emptyDoneSubtitle =
      'У вас нет активных напоминаний. Отличная работа!';
  static const String emptyDoneAction = 'Создать новое';
  static const String emptyHistoryTitle = 'История пуста';
  static const String emptyHistorySubtitle =
      'Выполненные напоминания будут появляться здесь';
  static const String loadingError = 'Не удалось загрузить напоминания';
  static const String retry = 'Retry';
  static const String notFoundTitle = 'Напоминание не найдено';
  static const String notFoundSubtitle =
      'Возможно, оно было удалено или завершено';
  static const String notFoundAction = 'Вернуться к списку';
  static const String sectionWhen = 'Когда';
  static const String sectionAmount = 'Сумма';
  static const String sectionCategory = 'Категория';
  static const String sectionAccount = 'Связанный счёт';
  static const String sectionCalendar = 'В календаре';
  static const String sectionRecurring = 'Регулярный платёж';
  static const String sectionSnooze = 'История откладываний';
  static const String repeatsPrefix = 'Повторяется: ';
  static const String nextPayments = 'Следующие 3 платежа:';
  static const String openInCalendar = 'Открыть в календаре';
  static const String actionComplete = 'Выполнено';
  static const String actionSnooze = 'Отложить';
  static const String actionCreateTransaction = 'Создать транзакцию';
  static const String snoozeSave = 'Сохранить';
  static const String snoozeWarning =
      'Вы уже 3 раза откладывали это напоминание. Может, удалить или перенести на месяц?';
  static const String formWhat = 'Что';
  static const String formTitleHint = 'Например, "Оплатить интернет"';
  static const String formDescriptionHint =
      'Дополнительные детали, ссылки, комментарии';
  static const String formPriority = 'Приоритет';
  static const String priorityLow = 'Низкий';
  static const String priorityNormal = 'Обычный';
  static const String priorityHigh = 'Высокий';
  static const String formWhen = 'Когда';
  static const String formDateTime = 'Дата и время*';
  static const String formRecurrence = 'Повторение';
  static const String recurrenceOnce = 'Однократно';
  static const String recurrenceDaily = 'Каждый день';
  static const String recurrenceWeekly = 'Каждую неделю';
  static const String recurrenceMonthly = 'Каждый месяц';
  static const String recurrenceYearly = 'Каждый год';
  static const String recurrenceCustom = 'Настраиваемое...';
  static const String formFinance = 'Финансы';
  static const String formAmount = 'Ожидаемая сумма';
  static const String formNoCategory = 'Без категории';
  static const String formNoAccount = 'Без счёта';
  static const String formScope = 'Ответственный и область';
  static const String scopePersonal = 'Только я';
  static const String scopeFamily = 'Вся семья';
  static const String scopeHint =
      'Семейные напоминания видны всем членам семьи. Любой участник может выполнить или удалить задачу.';
  static const String formAssignee = 'Ответственный';
  static const String assigneeAll = 'Все члены семьи';
  static const String formLinks = 'Связи';
  static const String formAutoComplete =
      'Автоматически отмечать выполненным при оплате';
  static const String noLink = 'Нет связи';
  static const String alreadyHasReminder = 'Уже есть напоминание';
  static const String cancelConfirmTitle = 'Отменить создание?';
  static const String cancelConfirmText =
      'Несохранённые данные будут потеряны.';
  static const String cancelContinue = 'Продолжить редактирование';
  static const String cancelDiscard = 'Отменить';
  static const String restoreDraftTitle = 'Восстановить черновик?';
  static const String restoreDraftText =
      'Найден несохранённый черновик младше 24 часов.';
  static const String restoreDraftAction = 'Восстановить';
  static const String rruleSheetTitle = 'Настроить повторение';
  static const String rruleFreq = 'Частота';
  static const String rruleWeekdays = 'Дни недели';
  static const String rruleMonthDay = 'День месяца';
  static const String rruleUntil = 'Повторять до';
  static const String rruleForever = 'Бесконечно';
  static const String rruleUntilDate = 'До даты';
  static const String rruleApply = 'Применить';
  static const String selectRecurringTitle = 'Выберите регулярный платёж';
  static const String noRecurringTitle = 'Нет регулярных платежей';
  static const String noRecurringSubtitle =
      'Сначала добавьте регулярный платёж, чтобы создать напоминание на его основе';
  static const String noRecurringAction = 'Создать вручную';
}