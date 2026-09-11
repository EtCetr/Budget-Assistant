import 'package:intl/intl.dart';

import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';

/// Централизованное форматирование приватных данных.
///
/// Архитектурное правило:
/// - запрещено хардкодить '•••' в виджетах;
/// - любой экран использует только этот класс через провайдер.
class PrivacyFormatter {
  const PrivacyFormatter();

  /// Форматирование денежной суммы.
  ///
  /// В режимах partial и hidden сумма полностью скрывается.
  String formatAmount(
    int kopecks,
    String currencyCode,
    BalanceVisibilityMode mode,
  ) {
    if (mode != BalanceVisibilityMode.visible) {
      return '•••';
    }

    return _formatKopecks(kopecks, currencyCode);
  }

  /// Мерчант виден в visible и partial.
  /// В hidden скрывается.
  String formatMerchant(String? merchantName, BalanceVisibilityMode mode) {
    if (mode == BalanceVisibilityMode.hidden) {
      return '•••';
    }

    return merchantName ?? '';
  }

  /// Комментарий может содержать личные данные.
  String formatComment(String? comment, BalanceVisibilityMode mode) {
    if (mode == BalanceVisibilityMode.hidden) {
      return '•••';
    }

    return comment ?? '';
  }

  /// Имя пользователя/участника.
  String formatName(String? name, BalanceVisibilityMode mode) {
    if (mode == BalanceVisibilityMode.hidden) {
      return '•••';
    }

    return name ?? '';
  }

  /// Email является персональным данными.
  String formatEmail(String? email, BalanceVisibilityMode mode) {
    if (mode == BalanceVisibilityMode.hidden) {
      return '•••';
    }

    return email ?? '';
  }

  /// Название пространства.
  String formatSpaceName(String? spaceName, BalanceVisibilityMode mode) {
    if (mode == BalanceVisibilityMode.hidden) {
      return '•••';
    }

    return spaceName ?? '';
  }

  /// Номер карты.
  ///
  /// visible: *1234
  /// partial: *•••
  /// hidden: ••••
  String formatCardNumber(String? cardNumber, BalanceVisibilityMode mode) {
    if (cardNumber == null || cardNumber.isEmpty) {
      return '';
    }

    switch (mode) {
      case BalanceVisibilityMode.visible:
        return cardNumber;
      case BalanceVisibilityMode.partial:
        return '*•••';
      case BalanceVisibilityMode.hidden:
        return '••••';
    }
  }

  /// Проценты можно показывать в visible и partial.
  ///
  /// В hidden они могут деанонимизировать масштаб данных.
  String formatPercent(int percent, BalanceVisibilityMode mode) {
    if (mode == BalanceVisibilityMode.hidden) {
      return '';
    }

    return '$percent%';
  }

  /// Тренд цены.
  String formatPriceTrend(String? trend, BalanceVisibilityMode mode) {
    if (mode == BalanceVisibilityMode.hidden) {
      return '';
    }

    return trend ?? '';
  }

  bool shouldShowFamilyColors(BalanceVisibilityMode mode) {
    return mode != BalanceVisibilityMode.hidden;
  }

  bool shouldShowChart(BalanceVisibilityMode mode) {
    return mode != BalanceVisibilityMode.hidden;
  }

  bool shouldShowCategoryColors(BalanceVisibilityMode mode) {
    return mode != BalanceVisibilityMode.hidden;
  }

  bool shouldShowBrandColors(BalanceVisibilityMode mode) {
    return mode != BalanceVisibilityMode.hidden;
  }

  bool shouldShowReceiptImage(BalanceVisibilityMode mode) {
    return mode != BalanceVisibilityMode.hidden;
  }

  bool shouldShowCelebration(BalanceVisibilityMode mode) {
    return mode != BalanceVisibilityMode.hidden;
  }

  /// Форматирование копеек без использования double.
  ///
  /// Пример:
  /// 15000000 -> "150 000,00 RUB"
  /// -210000 -> "-2 100,00 RUB"
  String _formatKopecks(int kopecks, String currencyCode) {
    final isNegative = kopecks < 0;
    final absKopecks = kopecks.abs();

    final whole = absKopecks ~/ 100;
    final fraction = absKopecks % 100;

    final formattedWhole = NumberFormat('#,##0', 'ru').format(whole);
    final formattedFraction = fraction.toString().padLeft(2, '0');

    final sign = isNegative ? '-' : '';

    return '$sign$formattedWhole,$formattedFraction $currencyCode';
  }
}
