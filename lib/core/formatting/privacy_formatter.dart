import '../../features/privacy/domain/models/balance_visibility_mode.dart';
import 'money_formatter.dart';

class PrivacyFormatter {
  static const String _mask = '•••';

  String amount({
    required int kopecks,
    required String currencyCode,
    required BalanceVisibilityMode mode,
    bool showSign = false,
  }) {
    if (mode != BalanceVisibilityMode.visible) {
      return _mask;
    }
    return MoneyFormatter.formatKopecks(
      kopecks,
      currencyCode,
      showSign: showSign,
    );
  }

  String text(
    String? value,
    BalanceVisibilityMode mode, {
    String fallback = '',
  }) {
    if (mode == BalanceVisibilityMode.hidden) {
      return _mask;
    }
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) {
      return fallback;
    }
    return trimmed;
  }
}
