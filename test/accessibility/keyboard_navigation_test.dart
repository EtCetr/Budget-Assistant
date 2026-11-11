import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/accessibility/focusable_button.dart';
import 'package:budget_assistant/core/accessibility/arrow_navigable_list.dart';

/// Этап 22 (ТЗ 6.10.9): проверка клавиатурной навигации.
void main() {
  group('FocusableButton', () {
    testWidgets('renders child correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: FocusableButton(
                onPressed: () {},
                child: const Text('Нажми меня'),
              ),
            ),
          ),
        ),
      );

      expect(find.text('Нажми меня'), findsOneWidget);
    });

    testWidgets('responds to tap', (tester) async {
      bool pressed = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: FocusableButton(
                onPressed: () => pressed = true,
                child: const Text('Нажми'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byType(FocusableButton));
      await tester.pump();

      expect(pressed, isTrue);
    });

    testWidgets('has button semantics', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: FocusableButton(
                  semanticLabel: 'Кнопка действия',
                  onPressed: () {},
                  child: const Text('Действие'),
                ),
              ),
            ),
          ),
        );

        expect(
          find.bySemanticsLabel('Кнопка действия'),
          findsOneWidget,
        );
      } finally {
        handle.dispose();
      }
    });
  });

  group('ArrowNavigableList', () {
    testWidgets('renders all children', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ArrowNavigableList(
              children: <Widget>[
                Text('Элемент 1'),
                Text('Элемент 2'),
                Text('Элемент 3'),
              ],
            ),
          ),
        ),
      );

      expect(find.text('Элемент 1'), findsOneWidget);
      expect(find.text('Элемент 2'), findsOneWidget);
      expect(find.text('Элемент 3'), findsOneWidget);
    });

    testWidgets('contains ListView', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ArrowNavigableList(
              children: <Widget>[
                Text('Элемент 1'),
                Text('Элемент 2'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(ListView), findsOneWidget);
    });
  });
}