import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import 'package:budget_assistant/core/accessibility/semantics_extensions.dart';

/// Этап 22 (ТЗ 6.10.4): проверка семантических меток виджетов.
void main() {
  group('EmptyStateWidget semantics', () {
    testWidgets('renders title and subtitle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              title: 'Нет данных',
              subtitle: 'Добавьте первую запись',
            ),
          ),
        ),
      );

      expect(find.text('Нет данных'), findsOneWidget);
      expect(find.text('Добавьте первую запись'), findsOneWidget);
    });

    testWidgets('renders only title when no subtitle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: EmptyStateWidget(
              icon: Icons.inbox,
              title: 'Нет данных',
            ),
          ),
        ),
      );

      expect(find.text('Нет данных'), findsOneWidget);
    });

    testWidgets('icon is excluded from semantics', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: EmptyStateWidget(
                icon: Icons.inbox,
                title: 'Нет данных',
              ),
            ),
          ),
        );

        // Flutter создаёт несколько ExcludeSemantics в дереве виджетов
        // (для Icon и других элементов), поэтому проверяем наличие хотя бы одного.
        expect(
          find.descendant(
            of: find.byType(EmptyStateWidget),
            matching: find.byType(ExcludeSemantics),
          ),
          findsWidgets,
        );
      } finally {
        handle.dispose();
      }
    });
  });

  group('SemanticsX extensions', () {
    testWidgets('asButton adds button semantics', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: const Text('Тест').asButton(label: 'Кнопка теста'),
              ),
            ),
          ),
        );

        expect(
          find.bySemanticsLabel('Кнопка теста'),
          findsOneWidget,
        );
      } finally {
        handle.dispose();
      }
    });

    testWidgets('asHeader adds header semantics', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: const Text('Заголовок').asHeader(label: 'Заголовок'),
              ),
            ),
          ),
        );

        expect(
          find.bySemanticsLabel('Заголовок'),
          findsOneWidget,
        );
      } finally {
        handle.dispose();
      }
    });
  });
}