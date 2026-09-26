/// Строки экрана долгов (Этап 13, ТЗ 6.3.13).
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
  static const daysLeftSuffix = 'осталось';
  static const overduePrefix = 'Просрочено на';
  static const exMemberWarning = 'Участник вышел из группы';
  static const nameLoading = '…';

  // Long-press меню
  static const menuMarkResolved = 'Отметить выполненным';
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

  // FAB
  static const fabAddDebt = 'Добавить долг';
  static const fabPendingNote =
      'Форма создания долга появится в следующем микро-коммите (13.5)';

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