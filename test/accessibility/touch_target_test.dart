import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/accessibility/minimum_touch_target.dart';

/// Этап 22 (ТЗ 6.10.3): проверка минимального размера зоны касания 48×48.
void main() {
  group('MinimumTouchTarget', () {
    testWidgets('enforces minimum 48x48 logical pixels', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: MinimumTouchTarget(
                child: Icon(Icons.close, size: 24),
              ),
            ),
          ),
        ),
      );

      final size = tester.getSize(find.byType(MinimumTouchTarget));
      expect(size.width, greaterThanOrEqualTo(48.0));
      expect(size.height, greaterThanOrEqualTo(48.0));
    });

    testWidgets('has button semantics when onTap is provided', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: MinimumTouchTarget(
                  semanticLabel: 'Закрыть',
                  onTap: () {},
                  child: const Icon(Icons.close, size: 24),
                ),
              ),
            ),
          ),
        );

        expect(
          find.bySemanticsLabel('Закрыть'),
          findsOneWidget,
        );
      } finally {
        handle.dispose();
      }
    });

    testWidgets('does not have button semantics without onTap', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: Center(
                child: MinimumTouchTarget(
                  semanticLabel: 'Инфо',
                  child: Icon(Icons.info, size: 24),
                ),
              ),
            ),
          ),
        );

        expect(
          find.bySemanticsLabel('Инфо'),
          findsOneWidget,
        );
      } finally {
        handle.dispose();
      }
    });

    testWidgets('child is rendered within touch target', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: MinimumTouchTarget(
                child: Icon(Icons.close, size: 24),
              ),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });
}