/// Строки экранов группы «Чеки» (Этап 16).
abstract final class ReceiptsStrings {
  static const String scanTitle = 'Сканирование чека';
  static const String modeQr = 'QR-код';
  static const String modeOcr = 'OCR текст';
  static const String modeGallery = 'Из галереи';
  static const String qrHint = 'Наведите на QR-код чека';
  static const String qrTip =
      'QR-код находится внизу бумажного чека. Содержит дату, сумму и фискальные данные.';
  static const String noQrFallback = 'Не нашли QR? Сканировать текст чека';
  static const String ocrHint = 'Сфотографируйте весь чек целиком';
  static const String ocrButton = 'Сделать фото';
  static const String galleryPick = 'Выбрать изображение';
  static const String galleryTypeLabel = 'Тип содержимого';
  static const String galleryTypeQr = 'QR-код';
  static const String galleryTypeText = 'Фото текста';
  static const String galleryRecognize = 'Распознать';
  static const String galleryHidden = 'Фото скрыто в приватном режиме';
  static const String processing = 'Распознаём чек...';
  static const String scanSuccess = 'Чек распознан. Проверьте данные';
  static const String qrParseFailed =
      'Не удалось распознать QR-код. Попробуйте ещё раз или сфотографируйте текст чека';
  static const String galleryLoadError = 'Не удалось загрузить изображение';
  static const String cancel = 'Отмена';
  static const String fabScanReceipt = 'Отсканировать чек';
  static const String helpTitle = 'Как сканировать чек';
  static const String helpQr = 'Наведите камеру на QR-код внизу чека и держите ровно.';
  static const String helpOcr = 'Сфотографируйте чек целиком при хорошем освещении.';
  static const String helpGallery =
      'Выберите сохранённое фото или скриншот чека и укажите тип содержимого.';
  static const String previewTitle = 'Предпросмотр чека';
  static const String previewPlaceholder =
      'Черновик чека создан. Полноценный предпросмотр появится в под-шаге 16.4.';
  static const String saveFailed =
      'Не удалось сохранить черновик чека. Попробуйте ещё раз';
  static const String metadataStore = 'Магазин';
  static const String metadataDate = 'Дата чека';
  static const String metadataTotal = 'Итоговая сумма';
  static const String matchTitle = 'Привязка к операции';
  static const String matchNone = 'Автоматических совпадений не найдено';
  static const String matchCreate = 'Создать новую транзакцию';
  static const String matchSkip = 'Пропустить';
  static const String matchAttach = 'Прикрепить';
  static const String matchChooseOther = 'Выбрать другую';
  static const String matchConfirmSel = 'Подтвердить выбор';
  static const String matchPending =
      'Операция в статусе hold — привязка будет доступна после верификации';
  static const String matchAlready = 'Чек привязан к операции';
  static const String matchAttached = 'Чек прикреплён';
  static const String itemsTitle = 'Позиции чека';
  static const String itemAdd = 'Добавить позицию';
  static const String itemName = 'Название';
  static const String itemQty = 'Кол-во';
  static const String itemPrice = 'Цена';
  static const String itemCategory = 'Категория';
  static const String itemExclude = 'Исключить';
  static const String summaryOk = 'Сумма позиций сходится с итогом';
  static const String summaryMismatch = 'Сумма позиций НЕ сходится с итогом';
  static const String confirmButton = 'Подтвердить и сохранить';
  static const String savedSnack = 'Чек сохранён';
  static const String namingTitle = 'Дать название товару?';
  static const String namingHint =
      'Название поможет точнее считать аналитику товаров';
  static const String namingScopeSelf = 'Только я';
  static const String namingScopeFamily = 'Семья';
  static const String namingSave = 'Дать название';
  static const String namingSkip = 'Пропустить';
  static const String matchPreselected =
      'Прикрепить к операции, из которой открыт экран?';
  static const String scanNoTransaction =
      'Сканирование доступно из операции: удерживайте транзакцию и выберите «Прикрепить чек»';
  static const String hintLink = 'привяжите чек к операции';
  static const String splitTitle = 'Разделение чека';
  static const String splitNotFound = 'Чек не найден';
  static const String splitNeedLink = 'Сначала привяжите чек к операции - разделение доступно только для привязанного чека';
  static const String splitInfoBanner = 'Разделите чек по категориям для точной аналитики. Сумма всех позиций должна равняться сумме чека';
  static const String splitRestoreTitle = 'Восстановить черновик?';
  static const String splitRestoreText = 'Найдено несохранённое разделение этого чека';
  static const String splitRestoreYes = 'Восстановить';
  static const String splitRestoreNo = 'Начать заново';
  static const String splitPickCategory = 'Категория';
  static const String splitNeedCategory = 'Выберите категорию';
  static const String splitRemainder = 'Нераспределённый остаток';
  static const String splitRemainderPosition = 'Прочее';
  static const String splitAdd = 'Добавить позицию вручную';
  static const String splitNoPositions = 'Позиции не распознаны. Добавьте позиции вручную';
  static const String splitSumPositions = 'Позиции';
  static const String splitSumReceipt = 'Чек';
  static const String splitCancel = 'Отмена';
  static const String splitDo = 'Разделить';
  static const String splitSaved = 'Чек разделён';
  static const String splitError = 'Не удалось разделить чек';
  static const String splitMinTwo = 'Нужно минимум 2 позиции';
  static const String splitSumMismatch = 'Сумма позиций не равна сумме чека';
  static const String splitMissingCategory = 'У позиций нет категорий';
  static const String splitConfirmCancelTitle = 'Отменить разделение?';
  static const String splitConfirmCancelText = 'Несохранённые позиции будут оставлены в черновике';
  static const String splitPlaceholder =
      'Экран разделения чека появится в под-шаге 16.5.';
  static const String imageHidden = 'Фото скрыто (приватный режим)';
  static const String imageCloud = 'Фото будет доступно после синхронизации';
}