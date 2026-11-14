import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import '../helpers/semantics_probe.dart';

/// Этап 24: контракт EmptyStateWidget (ТЗ 6.8).
Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  testWidgets('иконка, заголовок и подзаголовок рендерятся', (tester) async {
    await tester.pumpWidget(
      _host(
        const EmptyStateWidget(
          icon: Icons.receipt_long_outlined,
          title: 'Пока нет транзакций',
          subtitle: 'Добавьте первую операцию',
        ),
      ),
    );

    expect(find.byIcon(Icons.receipt_long_outlined), findsOneWidget);
    expect(find.text('Пока нет транзакций'), findsOneWidget);
    expect(find.text('Добавьте первую операцию'), findsOneWidget);
  });

  testWidgets('без подзаголовка рендерится только заголовок', (tester) async {
    await tester.pumpWidget(
      _host(const EmptyStateWidget(icon: Icons.inbox, title: 'Пусто')),
    );

    expect(find.text('Пусто'), findsOneWidget);
  });

  testWidgets('основная кнопка вызывает колбэк', (tester) async {
    var pressed = 0;
    await tester.pumpWidget(
      _host(
        EmptyStateWidget(
          icon: Icons.inbox,
          title: 'Пусто',
          primaryAction: EmptyStateAction(
            label: 'Добавить',
            onPressed: () => pressed++,
          ),
        ),
      ),
    );

    expect(find.byType(ElevatedButton), findsOneWidget);
    await tester.tap(find.text('Добавить'));
    await tester.pump();
    expect(pressed, 1);
  });

  testWidgets('вторичная кнопка рендерится как OutlinedButton', (tester) async {
    var pressed = 0;
    await tester.pumpWidget(
      _host(
        EmptyStateWidget(
          icon: Icons.inbox,
          title: 'Пусто',
          secondaryAction: EmptyStateAction(
            label: 'Импортировать',
            isPrimary: false,
            onPressed: () => pressed++,
          ),
        ),
      ),
    );

    expect(find.byType(OutlinedButton), findsOneWidget);
    await tester.tap(find.text('Импортировать'));
    await tester.pump();
    expect(pressed, 1);
  });

  testWidgets('семантика объединяет заголовок и подзаголовок', (tester) async {
    final handle = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        _host(
          const EmptyStateWidget(
            icon: Icons.inbox,
            title: 'Нет долгов',
            subtitle: 'Отличная дисциплина',
          ),
        ),
      );

      final labels = semanticsLabelsOf(tester, find.byType(EmptyStateWidget));
      expect(
        labels.any(
          (l) => l.contains('Нет долгов') && l.contains('Отличная дисциплина'),
        ),
        isTrue,
        reason: 'Метки семантики: $labels',
      );
    } finally {
      handle.dispose();
    }
  });

  testWidgets('декоративная иконка исключена из семантики', (tester) async {
    await tester.pumpWidget(
      _host(const EmptyStateWidget(icon: Icons.inbox, title: 'Пусто')),
    );

    expect(
      find.descendant(
        of: find.byType(EmptyStateWidget),
        matching: find.byType(ExcludeSemantics),
      ),
      findsWidgets,
    );
  });
}