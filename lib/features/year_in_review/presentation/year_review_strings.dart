import 'package:intl/intl.dart';

/// Тексты экрана «Итоги года» (ТЗ 6.3.37). Хардкод строк в виджетах запрещён.
abstract final class YearReviewStrings {
  static String title(int year) => 'Твой $year в цифрах';
  static const subtitle = 'Посмотрим, каким был твой год';
  static const start = 'Начать →';
  static const onlyMe = 'Только я';

  static const youEarned = 'Ты заработал';
  static const firstYear = 'Это твой первый год в Budget Assistant! 🎉';
  static String moreThanLastYear(int p) =>
      'Это на $p% больше, чем в прошлом году! 📈';
  static String lessThanLastYear(int p) =>
      'Это на $p% меньше, чем в прошлом году 📉';

  static const spent = 'Потрачено';
  static String mostGenerousMonth(String m) => 'Самый щедрый месяц — $m 🎄';
  static String startedBudgeting(String m) => 'Ты начал вести бюджет в $m!';
  static const addMoreOps =
      'Добавь больше операций, чтобы увидеть полную статистику за год';

  static const topCategories = 'Топ-3 категории';
  static const yourRecord = 'Твой рекорд';

  static const investments = 'Инвестиции';
  static const investedLine = 'Вложено в инвестиционные счета за год';

  static const savings = 'Накопления';
  static const savedLine = 'Отложено в цели';
  static String goalsClosed(int c, int t) => 'Закрыто $c из $t целей 🎯';
  static const allGoalsDone = '🎉 Все цели достигнуты!';

  static const cashback = 'Кэшбэк';
  static const cashbackEarned = 'Заработано кэшбэка';
  static const bestCategory = 'Лучшая категория';

  static const familyBudget = 'Семейный бюджет';
  static const familySpent = 'Совместных трат';
  static String familyPercent(int p) => 'Ты закрыл $p% семейных расходов';
  static String secretLine(String s) => '🎁 Секретные траты: $s';

  static const subscriptions = 'Подписки';
  static const subsSpent = 'Потрачено на подписки';
  static const mostExpensiveSub = 'Самая дорогая';

  static const savingsRate = 'Savings Rate';
  static const savingsRateLine = 'Твоя норма сбережений';
  static const aboveAverage = 'Это выше среднего по стране! 🏆';
  static const belowAverage =
      'Это ниже среднего, но ты можешь улучшить! 💪';
  static const negativeRate =
      'В этом году ты тратил больше, чем зарабатывал. В следующем году получится лучше! 🚀';

  static String finaleTitle(int nextYear) =>
      'Готов к новым целям в $nextYear? 🚀';
  static const shareResults = '📤 Поделиться результатами';
  static const goHome = '🏠 Вернуться на главный экран';

  static const closeConfirmTitle = 'Закрыть статистику?';
  static const closeConfirmBody =
      'Вы сможете вернуться к ней позже в профиле';
  static const closeConfirmYes = 'Закрыть';
  static const cancel = 'Отмена';

  static const shareBlockedHidden = '🔒 Шеринг недоступен в скрытом режиме';
  static const shareCancelledPin = '❌ Экспорт отменён';
  static const secureFlagNotice =
      'Для создания картинки защита экрана временно отключена на 5 секунд';
  static const shareError = '❌ Не удалось поделиться';

  static const noDataTitle = 'Статистика пока недоступна';
  static const noDataSubtitle =
      'Добавь первую транзакцию, чтобы начать отслеживать свои финансы';
  static const addFirstTx = '➕ Добавить первую транзакцию';

  static const calculating = 'Пересчитываем статистику...';
  static const loadingError = 'Не удалось загрузить статистику';
  static const retry = 'Повторить';

  static const selectTitle = 'Статистика по годам';
  static const ready = 'Готово';
  static const willCalculate = 'Посчитается при открытии';
  static String txCount(int n) => 'Операций: $n';

  /// Название месяца по-русски (1..12).
  static String monthName(int month) =>
      DateFormat.MMMM('ru').format(DateTime(2000, month));
}