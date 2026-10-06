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
  static const String saveFailed =
      'Не удалось сохранить черновик чека. Попробуйте ещё раз';
  static const String previewPlaceholder =
      'Черновик чека создан. Полноценный предпросмотр появится в под-шаге 16.4.';
}