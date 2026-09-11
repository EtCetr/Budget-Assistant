import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';

/// Нотификатор режима приватности (Riverpod 3.x, без StateProvider).
///
/// Источники режима (подключаются на этапах 21 и 23):
/// - app_settings.default_balance_visibility;
/// - shake-to-hide;
/// - face-down;
/// - auto-hide timeout;
/// - biometric/PIN unhide.
class PrivacyModeNotifier extends Notifier<BalanceVisibilityMode> {
  @override
  BalanceVisibilityMode build() {
    // Базовое значение. Этап 21 заменит на чтение из app_settings.
    return BalanceVisibilityMode.visible;
  }

  void setMode(BalanceVisibilityMode mode) {
    state = mode;
  }

  void toggle() {
    state = switch (state) {
      BalanceVisibilityMode.visible => BalanceVisibilityMode.partial,
      BalanceVisibilityMode.partial => BalanceVisibilityMode.hidden,
      BalanceVisibilityMode.hidden => BalanceVisibilityMode.visible,
    };
  }
}

final privacyModeProvider =
    NotifierProvider<PrivacyModeNotifier, BalanceVisibilityMode>(
      PrivacyModeNotifier.new,
    );

/// Единственная точка доступа к PrivacyFormatter.
/// Виджеты получают formatter ТОЛЬКО отсюда (ТОМ 6, раздел 6.6).
final privacyFormatterProvider = Provider<PrivacyFormatter>((ref) {
  return const PrivacyFormatter();
});
