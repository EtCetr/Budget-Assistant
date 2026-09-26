/// Строки экранов долгов (Этап 13, ТЗ 6.3.13/6.3.14).
/// Хардкод строк в виджетах запрещён (DECISIONS.md).
abstract final class DebtsStrings {
  static const screenTitle = 'Долги';

  // Табы
  static const tabPayable = 'Я должен';
  static const tabReceivable = 'Мне должны';

  // Сводка
  static const statsTotalDebt = 'Общий долг';
  static const statsExpectedReturn = 'Ожидают возврата';
  static const statsOverdueSuffix = 'просрочено';

  // Фильтры
  static const filterAll = 'Все';
  static const filterActive = 'Активные';
  static const filterOverdue = 'Просрочено';
  static const filterResolved = 'Закрытые';

  // Бейджи типов
  static const badgePayable = 'Payable';
  static const badgeReceivable = 'Receivable';
  static const badgeResolved = 'Resolved';

  // Секции списка
  static const sectionActive = 'Активные';
  static const sectionOverdue = 'Просрочено';
  static const sectionExMember = 'От ex-члена семьи';
  static const sectionResolved = 'Закрытые';

  // Карточка долга
  static const duePrefix = 'Срок: до';
  static const overduePrefix = 'Просрочено на';
  static const daysLeftSuffix = 'осталось';
  static const exMemberWarning = 'Участник вышел из группы';
  static const nameLoading = '…';

  // Long-press меню
  static const menuMarkResolved = 'Отметить выполненным';
  static const menuEdit = 'Редактировать';
  static const menuExtendDueDate = 'Продлить срок';
  static const menuDelete = 'Удалить';
  static const menuRemindViaSms = 'Напомнить через SMS';

  // Ex-member действия
  static const exMemberMarkResolved = 'Отметить как погашенный';
  static const exMemberWriteOff = 'Списать долг';
  static const exMemberRemind = 'Напомнить должнику';

  // Пустые состояния
  static const emptyNoDebtsTitle = 'У вас нет долгов 🎉';
  static const emptyNoDebtsSubtitle = 'Отличная финансовая дисциплина!';
  static const emptyNoDebtsAction = 'Добавить долг';
  static const emptyFilterTitle = 'Нет долгов по этому фильтру';
  static const emptyFilterSubtitle = 'Попробуйте изменить фильтр';
  static const emptyFilterAction = 'Сбросить фильтры';
  static const emptyAllResolvedTitle = 'Все долги погашены 🎉';
  static const emptyAllResolvedSubtitle =
      'История закрытых долгов доступна ниже';
  static const emptyAllResolvedAction = 'Посмотреть историю';

  // Privacy
  static const privacyVisible = 'Видимый';
  static const privacyPartial = 'Частичный';
  static const privacyHidden = 'Скрытый';

  // Диалоги
  static const confirmResolveTitle = 'Отметить долг выполненным?';
  static const confirmResolveText =
      'Долг будет закрыт, создадутся компенсирующие транзакции '
      '(без пересчёта прошлых месяцев).';
  static const confirmDeleteTitle = 'Удалить долг?';
  static const confirmDeleteText =
      'Долг будет удалён без возможности восстановления.';
  static const confirmCancel = 'Отмена';
  static const confirmYes = 'Да';
  static const pickAccountTitle = 'Счёт для компенсирующих операций';
  static const pickAccountHint =
      'На каком счёте отразить погашение долга?';

  // Snackbar
  static const debtResolved = 'Долг отмечен как выполненный';
  static const debtDeleted = 'Долг удалён';
  static const dueDateExtended = 'Срок продлён';
  static const operationFailed = 'Не удалось выполнить операцию';
  static const remindTemplate = 'Напоминание о долге';

  // Errors
  static const loadingError = 'Не удалось загрузить долги';
  static const retry = 'Повторить';

  // ═══ Форма создания/редактирования (6.3.14) ═══
  static const formTitleNew = 'Новый долг';
  static const formTitleEdit = 'Редактировать долг';
  static const formTitleFromTransaction = 'Из транзакции';
  static const formSectionType = 'Тип долга';
  static const typePayable = '💳 Я должен';
  static const typeReceivable = '💰 Мне должны';
  static const formSectionCounterparty = 'Контрагент';
  static const counterpartyFamily = '👥 Член семьи';
  static const counterpartyExternal = '👤 Внешний человек';
  static const familyUnavailable =
      'Сначала присоединитесь к семейному пространству';
  static const familyEmptyList = 'В семье пока нет других участников';
  static const familyMultiHint =
      '💡 При выборе нескольких участников сумма будет разделена поровну. '
      'Для неравных долей создайте отдельные долги.';
  static const editMultiMembersNote =
      'В режиме редактирования смена контрагента ограничена';
  static const memberWillOwe = 'будет должен';
  static const memberWillOweMe = 'вам будет должен';
  static const externalLabel = 'Имя в дательном падеже*';
  static const externalHint = 'Например, "Ивану" или "Анне Петровне"';
  static const externalSavedAs = 'Сохранится как';
  static const externalDeclineFail =
      'Не удалось автоматически склонить имя. Проверьте форму «кому?»';
  static const formSectionDetails = 'Детали';
  static const amountLabel = 'Сумма*';
  static const currencyLabel = 'Валюта';
  static const categoryLabel = 'Категория';
  static const descriptionLabel = 'Описание';
  static const descriptionHint = 'За что долг? Например, "За поездку в Прагу"';
  static const dueDateLabel = 'Срок погашения (опционально)';
  static const dueDateChoose = 'Выбрать дату';
  static const dueDatePastWarning =
      'Срок уже истёк. Долг появится в списке "Просрочено"';
  static const formSectionLinks = 'Связи';
  static const linkTransactionLabel = '🔗 Связать с транзакцией';
  static const linkNone = 'Нет связи';
  static const autoResolveLabel =
      'Автоматически отметить выполненным при закрытии';
  static const previewPayable = 'Вы должны';
  static const previewReceivable = 'Долг вам:';
  static const saveAction = 'Сохранить';
  static const updateAction = 'Обновить';
  static const debtCreatedSnack = 'Долг создан';
  static const debtsCreatedSnack = 'Создано долгов';
  static const debtUpdatedSnack = 'Долг обновлён';
  static const syncLaterNote = 'Синхронизируется при появлении интернета';
  static const cancelCreateTitle = 'Отменить создание?';
  static const cancelEditTitle = 'Отменить редактирование?';
  static const cancelSubtitle = 'Несохранённые данные будут потеряны.';
  static const continueEditing = 'Продолжить редактирование';
  static const discardAction = 'Отменить';
  static const draftRestoreTitle = 'Найден черновик';
  static const draftRestoreText = 'Восстановить несохранённую форму долга?';
  static const draftRestoreAction = 'Восстановить';
  static const draftStartFresh = 'Начать заново';

  /// Склонение слова «день».
  static String daysWord(int n) {
    final abs = n.abs();
    final mod10 = abs % 10;
    final mod100 = abs % 100;
    if (mod10 == 1 && mod100 != 11) return 'день';
    if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) return 'дня';
    return 'дней';
  }
}