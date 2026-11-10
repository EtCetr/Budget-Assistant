import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/accessibility/contrast_checker.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';

/// Этап 22 (ТЗ 6.10.2): автоматическая проверка контраста цветовых пар.
void main() {
  group('Dark mode contrast', () {
    const bg = AppColors.surfaceBackground;
    const cardBg = AppColors.surfaceCard;

    test('textPrimary on surfaceBackground passes AA text contrast', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.textPrimary, bg),
        isTrue,
      );
    });

    test('textPrimary on surfaceCard passes AA text contrast', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.textPrimary, cardBg),
        isTrue,
      );
    });

    test('textSecondary on surfaceBackground passes AA text contrast', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.textSecondary, bg),
        isTrue,
      );
    });

    test('textSecondary on surfaceCard passes AA text contrast', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.textSecondary, cardBg),
        isTrue,
      );
    });

    test('colorIncome on surfaceBackground passes AA text contrast', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.colorIncome, bg),
        isTrue,
      );
    });

    test('colorIncome on surfaceCard passes AA text contrast', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.colorIncome, cardBg),
        isTrue,
      );
    });

    test('colorExpense on surfaceBackground passes AA text contrast', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.colorExpense, bg),
        isTrue,
      );
    });

    test('colorExpense on surfaceCard passes UI contrast', () {
      expect(
        ContrastChecker.meetsUiContrast(AppColors.colorExpense, cardBg),
        isTrue,
      );
    });

    test('colorWarning on surfaceBackground passes AA text contrast', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.colorWarning, bg),
        isTrue,
      );
    });

    test('colorWarning on surfaceCard passes AA text contrast', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.colorWarning, cardBg),
        isTrue,
      );
    });

    test('colorFAB on surfaceBackground passes AA text contrast', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.colorFAB, bg),
        isTrue,
      );
    });

    test('colorTransfer on surfaceBackground passes AA text contrast', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.colorTransfer, bg),
        isTrue,
      );
    });

    test('colorTransfer on surfaceCard passes UI contrast', () {
      expect(
        ContrastChecker.meetsUiContrast(AppColors.colorTransfer, cardBg),
        isTrue,
      );
    });

    test('colorHiddenMask on surfaceBackground passes UI contrast', () {
      expect(
        ContrastChecker.meetsUiContrast(AppColors.colorHiddenMask, bg),
        isTrue,
      );
    });

    test('borderDivider is decorative and not valid for text', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.borderDivider, bg),
        isFalse,
      );
    });
  });

  group('Light mode contrast', () {
    const bg = AppColors.lightSurfaceBackground;
    const cardBg = AppColors.lightSurfaceCard;

    test('light textPrimary on surfaceBackground passes AA text contrast', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.lightTextPrimary, bg),
        isTrue,
      );
    });

    test('light textPrimary on surfaceCard passes AA text contrast', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.lightTextPrimary, cardBg),
        isTrue,
      );
    });

    test('light textSecondary on surfaceBackground passes AA text contrast', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.lightTextSecondary, bg),
        isTrue,
      );
    });

    test('light textSecondary on surfaceCard passes AA text contrast', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.lightTextSecondary, cardBg),
        isTrue,
      );
    });

    test('lightColorExpense on surfaceBackground passes AA text contrast', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.lightColorExpense, bg),
        isTrue,
      );
    });

    test('lightColorExpense on surfaceCard passes AA text contrast', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.lightColorExpense, cardBg),
        isTrue,
      );
    });

    test('lightColorIncome on surfaceBackground passes AA text contrast', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.lightColorIncome, bg),
        isTrue,
      );
    });

    test('lightColorWarning on surfaceBackground passes AA text contrast', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.lightColorWarning, bg),
        isTrue,
      );
    });

    test('lightColorTransfer on surfaceBackground passes AA text contrast', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.lightColorTransfer, bg),
        isTrue,
      );
    });

    test('lightColorFAB on surfaceBackground passes UI contrast', () {
      expect(
        ContrastChecker.meetsUiContrast(AppColors.lightColorFAB, bg),
        isTrue,
      );
    });

    test('lightColorHiddenMask on surfaceBackground passes UI contrast', () {
      expect(
        ContrastChecker.meetsUiContrast(AppColors.lightColorHiddenMask, bg),
        isTrue,
      );
    });

    test('dark income color is not valid as light-mode text', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.colorIncome, bg),
        isFalse,
      );
    });

    test('dark warning color is not valid as light-mode text', () {
      expect(
        ContrastChecker.meetsTextContrast(AppColors.colorWarning, bg),
        isFalse,
      );
    });
  });
}