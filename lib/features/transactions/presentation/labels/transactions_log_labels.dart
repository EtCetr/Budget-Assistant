abstract final class TransactionsLogLabels {
  static const title = 'Транзакции';

  static const scopeAll = 'Все';
  static const scopeMine = 'Только мои';
  static const scopeFamily = 'Семейные';

  static const typeAll = 'Все типы';
  static const typeExpense = 'Расходы';
  static const typeIncome = 'Доходы';
  static const typeTransfer = 'Переводы';

  static const categories = 'Категории';
  static const accounts = 'Счета';
  static const period = 'Период';
  static const amount = 'Сумма';
  static const withReceipts = 'С чеками';
  static const onlySplit = 'Только split';
  static const onlyDebts = 'Только долги';
  static const excludeLargeExpenses = 'Без крупных';

  static const periodAll = 'Все время';
  static const periodToday = 'Сегодня';
  static const periodWeek = 'Неделя';
  static const periodMonth = 'Месяц';
  static const periodYear = 'Год';
  static const periodCustom = 'Выбрать диапазон';

  static const today = 'Сегодня';
  static const yesterday = 'Вчера';

  static const spent = 'Потрачено';
  static const income = 'Доход';
  static const operations = 'операций';

  static const reset = 'Сбросить';
  static const cancel = 'Отмена';
  static const apply = 'Применить';
  static const from = 'от';
  static const to = 'до';

  static const searchHint = 'Поиск по merchant / comment / category';

  static const noDataTitle = 'Пока нет транзакций';
  static const noDataSubtitle =
      'Добавьте первую операцию или импортируйте выписку из банка';
  static const addTransaction = 'Добавить транзакцию';
  static const importBank = 'Импортировать из банка';

  static const nothingFoundTitle = 'Ничего не найдено';
  static const nothingFoundSubtitle =
      'Попробуйте изменить фильтры или сбросить их';
  static const resetFilters = 'Сбросить фильтры';

  static const errorTitle = 'Не удалось загрузить транзакции';
  static const errorSubtitle =
      'Проверьте подключение к интернету и попробуйте снова';
  static const retry = 'Retry';

  static const syncSuccess = 'Синхронизировано';
  static const syncError = 'Ошибка синхронизации. Проверьте интернет';

  static const hideAsGift = 'Засекретить (Подарок)';
  static const unhideGift = 'Показать в календаре (отменить подарок)';

  static const markAsLargeExpense = 'Отметить как крупную трату 💎';
  static const unmarkAsLargeExpense = 'Снять пометку крупной траты';

  static const edit = 'Редактировать';
  static const editTitle = 'Редактирование транзакции';

  static const refund = 'Создать компенсирующую операцию (Доход)';
  static const changeCategory = 'Изменить категорию';

  static const attachReceipt = 'Прикрепить чек';
  static const viewReceipt = 'Посмотреть чек';
  static const splitReceipt = 'Разделить по категориям';
  static const manageDebt = 'Управление долгом';

  static const createExpense = 'Расход';
  static const createIncome = 'Доход';
  static const createTransfer = 'Перевод';
  static const importFile = 'Импорт файла';

  static const visible = 'Видимый';
  static const partial = 'Частичный';
  static const hidden = 'Скрытый';

  static const actionDone = 'Действие выполнено';
  static const actionFailed = 'Не удалось выполнить действие';

  static const excludeOwn = 'Без моих';
}
