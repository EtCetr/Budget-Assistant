/// Строки экрана разделения транзакции (Этап 13, ТЗ 6.3.15).
abstract final class SplitStrings {
  static const screenTitle = 'Разделение чека';
  static const sourceTitle = 'Исходная транзакция';
  static const alreadySplitNote =
      'Транзакция уже разделена — позиции будут перезаписаны.';
  static const positionsTitle = 'Позиции';
  static const addPosition = 'Добавить позицию';
  static const positionNameHint = 'Название позиции';
  static const positionAmountLabel = 'Сумма';
  static const positionCategoryPick = 'Выбрать категорию';
  static const positionDescriptionHint = 'Комментарий';
  static const deletePosition = 'Удалить позицию';
  static const remainderTitle = 'Нераспределено';
  static const remainderZero = 'Вся сумма распределена';
  static const summaryPositions = 'Позиций';
  static const summaryTotal = 'Сумма позиций';
  static const actionSave = 'Сохранить разделение';
  static const emptyTitle = 'Пока нет позиций';
  static const emptySubtitle =
      'Добавьте позиции вручную — автозаполнение из чека появится '
      'после подключения OCR (Этап 16).';
  static const emptyAction = 'Добавить позицию';
  static const categorySheetTitle = 'Выбор категории';
  static const draftRestoreTitle = 'Найден черновик';
  static const draftRestoreText = 'Восстановить несохранённое разделение?';
  static const draftRestoreAction = 'Восстановить';
  static const draftStartFresh = 'Начать заново';
  static const cancelTitle = 'Отменить разделение?';
  static const cancelSubtitle = 'Несохранённые позиции будут потеряны.';
  static const continueEditing = 'Продолжить редактирование';
  static const discardAction = 'Отменить';
  static const savedSnack = 'Разделение сохранено';
  static const loadingError = 'Не удалось загрузить транзакцию';
  static const retry = 'Повторить';
  static const operationFailed = 'Не удалось выполнить операцию';
}