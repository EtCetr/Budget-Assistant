import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';

/// Этап 24: режимы приватности. Промежуточный partial удалён
/// решением владельца (D19-14) — тест не даёт его вернуть.
void main() {
  test('режимов ровно два: visible и hidden', () {
    expect(BalanceVisibilityMode.values.length, 2);
    expect(
      BalanceVisibilityMode.values,
      [BalanceVisibilityMode.visible, BalanceVisibilityMode.hidden],
    );
  });

  test('имена режимов стабильны (используются в настройках и синке)', () {
    expect(BalanceVisibilityMode.visible.name, 'visible');
    expect(BalanceVisibilityMode.hidden.name, 'hidden');
  });
}