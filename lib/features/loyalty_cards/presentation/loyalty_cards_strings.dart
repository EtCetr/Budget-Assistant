/// Строки экрана скидочных карт (хардкод в UI запрещён).
abstract final class LoyaltyCardsStrings {
  static const String screenTitle = 'Скидочные карты';
  static const String addCard = 'Добавить карту';
  static const String searchHint = 'Поиск по названию магазина...';
  static const String scopePersonal = 'Только мои';
  static const String scopeFamily = 'Все семейные';
  static const String filterFavorite = 'Избранное';
  static const String statsTotal = 'Карт:';
  static const String statsFavorites = 'Избранных:';
  static const String statsFamily = 'Семейных:';
  static const String reorderBanner = 'Перетаскивайте карты, чтобы изменить порядок';
  static const String reorderDone = 'Готово';
  static const String emptyNoCardsTitle = 'У вас пока нет скидочных карт';
  static const String emptyNoCardsSubtitle =
      'Добавьте первую карту, чтобы показывать штрих-код на кассе прямо с телефона';
  static const String emptyNoCardsCta = 'Добавить первую карту';
  static const String emptyFilterTitle = 'Нет карт по этому фильтру';
  static const String emptyFilterSubtitle =
      'Попробуйте изменить фильтр или добавить новую карту';
  static const String emptyFilterCta = 'Сбросить фильтры';
  static const String emptyFamilyTitle = 'В семье пока нет общих карт';
  static const String emptyFamilySubtitle =
      'Добавьте карту и включите «Поделиться с семьёй», чтобы все члены семьи могли ей пользоваться';
  static const String emptyFamilyCta = 'Добавить карту';
  static const String errorTitle = 'Не удалось загрузить карты';
  static const String errorSubtitle = 'Проверьте подключение и попробуйте снова';
  static const String errorRetry = 'Повторить';
  static const String menuOpen = 'Открыть';
  static const String menuEdit = 'Редактировать';
  static const String menuFavoriteAdd = 'В избранное';
  static const String menuFavoriteRemove = 'Убрать из избранного';
  static const String menuShareFamily = 'Поделиться с семьёй';
  static const String menuMakePersonal = 'Сделать личной';
  static const String menuDelete = 'Удалить';
  static const String deleteConfirmTitle = 'Удалить карту?';
  static const String deleteConfirmText = 'Действие нельзя отменить.';
  static const String deleteConfirmAction = 'Удалить';
  static const String cancel = 'Отмена';
  static const String displayBlockedHidden =
      'Для показа карты кассиру переключитесь в видимый режим';
  static const String actionFailed = 'Не удалось выполнить действие';
  static const String stubAdd = 'Экран добавления появится в подэтапе 20.4';
  static const String stubDisplay = 'Экран показа кассиру появится в подэтапе 20.5';
  static const String profileCardTitle = 'Скидочные карты';
  static const String profileCardAction = 'Мои карты лояльности';
  static const String editTitle = 'Редактировать карту';
  static const String modeScan = 'Сканер';
  static const String modeManual = 'Вручную';
  static const String scanHint = 'Наведите камеру на штрих-код';
  static const String scanDetected = 'Код распознан';
  static const String storeNameLabel = 'Название магазина';
  static const String barcodeLabel = 'Номер карты / данные кода';
  static const String typeLabel = 'Тип кода';
  static const String categoryLabel = 'Категория';
  static const String colorLabel = 'Цвет бренда';
  static const String emojiLabel = 'Иконка';
  static const String visibilityPersonal = 'Личная';
  static const String visibilityFamily = 'Семейная';
  static const String popularLabel = 'Популярные магазины';
  static const String saveCard = 'Сохранить карту';
  static const String draftRestoreTitle = 'Восстановить черновик?';
  static const String draftRestoreText = 'Найден несохранённый черновик формы.';
  static const String draftRestoreYes = 'Восстановить';
  static const String draftRestoreNo = 'Удалить';
  static const String notCreator = 'Редактировать карту может только её создатель';
  static const String noColor = 'Без цвета';
  static const String typeEan13 = 'EAN-13';
  static const String typeCode128 = 'Code 128';
  static const String typeQr = 'QR';
  static const String typePdf417 = 'PDF417';
  static const String typeManual = 'Только номер';
  static const String cameraDenied = 'Нет доступа к камере';
  static const String cameraUnavailable = 'Камера недоступна';
  static const String displaySubtitle = 'Карта лояльности';
  static const String displayHint = 'Покажите экран кассиру для сканирования';
  static const String displayClose = 'Закрыть';
  static const String displayRotate = 'Повернуть';
  static const String displayEdit = 'Редактировать';
  static const String displayNotFoundTitle = 'Карта не найдена';
  static const String displayNotFoundSubtitle = 'Возможно, она была удалена';
  static const String displayBack = 'Вернуться к списку';
  static const String hiddenWarningTitle = 'Скрытый режим активен';
  static const String hiddenWarningText =
      'Для показа карты кассиру нужно переключиться в режим видимости. Переключить сейчас?';
  static const String hiddenWarningSwitch = 'Переключить';
}