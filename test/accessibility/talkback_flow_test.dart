import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/accessibility/minimum_touch_target.dart';
import 'package:budget_assistant/core/accessibility/semantics_extensions.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';

/// Этап 22 (ТЗ 6.10.5): проверка структуры для потоков TalkBack.
void main() {
  group('TalkBack flow: semantic structure', () {
    testWidgets('interactive elements have labels', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  MinimumTouchTarget(
                    semanticLabel: 'Создать',
                    onTap: () {},
                    child: const Icon(Icons.add),
                  ),
                  MinimumTouchTarget(
                    semanticLabel: 'Закрыть',
                    onTap: () {},
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
          ),
        );

        expect(find.bySemanticsLabel('Создать'), findsOneWidget);
        expect(find.bySemanticsLabel('Закрыть'), findsOneWidget);
      } finally {
        handle.dispose();
      }
    });

    testWidgets('headers are marked for navigation', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  const Text('Раздел 1').asHeader(label: 'Раздел 1'),
                  const Text('Контент раздела 1'),
                  const Text('Раздел 2').asHeader(label: 'Раздел 2'),
                  const Text('Контент раздела 2'),
                ],
              ),
            ),
          ),
        );

        expect(find.text('Раздел 1'), findsOneWidget);
        expect(find.text('Раздел 2'), findsOneWidget);
      } finally {
        handle.dispose();
      }
    });

    testWidgets('empty state provides complete description', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: EmptyStateWidget(
                icon: Icons.receipt_long,
                title: 'Нет транзакций',
                subtitle: 'Нажмите + чтобы добавить',
                primaryAction: EmptyStateAction(
                  label: 'Добавить',
                  onPressed: () {},
                ),
              ),
            ),
          ),
        );

        expect(find.text('Нет транзакций'), findsOneWidget);
        expect(find.text('Нажмите + чтобы добавить'), findsOneWidget);
        expect(find.text('Добавить'), findsOneWidget);
      } finally {
        handle.dispose();
      }
    });
  });
}