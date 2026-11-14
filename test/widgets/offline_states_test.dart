import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/widgets/offline_error_card.dart';
import 'package:budget_assistant/core/widgets/pending_sync_indicator.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import '../helpers/semantics_probe.dart';

/// Этап 24: offline-состояния (ТЗ 6.7): ошибка, ожидание синка, скелетон.
Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

Future<void> _stopAnimations(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox.shrink());
}

void main() {
  group('OfflineErrorCard', () {
    testWidgets('показывает сообщение и кнопку Retry', (tester) async {
      var retried = 0;
      await tester.pumpWidget(
        _host(
          OfflineErrorCard(
            message: 'Не удалось загрузить данные',
            onRetry: () => retried++,
          ),
        ),
      );

      expect(find.text('Не удалось загрузить данные'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);

      await tester.tap(find.text('Retry'));
      await tester.pump();
      expect(retried, 1);
    });

    testWidgets('без onRetry кнопки нет', (tester) async {
      await tester.pumpWidget(
        _host(const OfflineErrorCard(message: 'Ошибка')),
      );

      expect(find.byType(OutlinedButton), findsNothing);
    });

    testWidgets('showIcon = false убирает иконку', (tester) async {
      await tester.pumpWidget(
        _host(const OfflineErrorCard(message: 'Ошибка', showIcon: false)),
      );

      expect(find.byIcon(Icons.error_outline), findsNothing);
      expect(find.text('Ошибка'), findsOneWidget);
    });

    testWidgets('кастомная подпись кнопки', (tester) async {
      await tester.pumpWidget(
        _host(
          OfflineErrorCard(
            message: 'Ошибка',
            retryLabel: 'Повторить',
            onRetry: () {},
          ),
        ),
      );

      expect(find.text('Повторить'), findsOneWidget);
    });

    testWidgets('семантика содержит текст ошибки', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          _host(const OfflineErrorCard(message: 'Нет сети')),
        );

        final label = semanticsLabelOf(tester, find.byType(OfflineErrorCard));
        expect(label, contains('Нет сети'));
      } finally {
        handle.dispose();
      }
    });

    testWidgets('кнопка Retry остаётся доступной для TalkBack', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          _host(OfflineErrorCard(message: 'Нет сети', onRetry: () {})),
        );

        final label = semanticsLabelOf(tester, find.byType(OutlinedButton));
        expect(label, contains('Retry'));
      } finally {
        handle.dispose();
      }
    });
  });

  group('PendingSyncIndicator', () {
    testWidgets('иконка cloud_off и семантика ожидания', (tester) async {
      final handle = tester.ensureSemantics();
      try {
        await tester.pumpWidget(_host(const PendingSyncIndicator()));
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byIcon(Icons.cloud_off), findsOneWidget);
        final label =
            semanticsLabelOf(tester, find.byType(PendingSyncIndicator));
        expect(label, contains('Ожидает синхронизации'));
      } finally {
        handle.dispose();
      }
      await _stopAnimations(tester);
    });
  });

  group('SkeletonShimmer', () {
    testWidgets('задаёт размеры и скрыт от TalkBack', (tester) async {
      await tester.pumpWidget(
        _host(const SkeletonShimmer(width: 120, height: 24)),
      );
      await tester.pump(const Duration(milliseconds: 100));

      expect(tester.getSize(find.byType(SkeletonShimmer)), const Size(120, 24));
      expect(
        find.descendant(
          of: find.byType(SkeletonShimmer),
          matching: find.byType(ExcludeSemantics),
        ),
        findsOneWidget,
      );
      await _stopAnimations(tester);
    });

    testWidgets('фабрики text/title/field/avatar дают свои размеры',
        (tester) async {
      await tester.pumpWidget(
        _host(
          Column(
            children: [
              SkeletonShimmer.text(),
              SkeletonShimmer.title(),
              SkeletonShimmer.field(),
              SkeletonShimmer.avatar(),
            ],
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));

      final heights = tester
          .widgetList<SkeletonShimmer>(find.byType(SkeletonShimmer))
          .map((w) => w.height)
          .toList();
      expect(heights, [16, 24, 56, 48]);
      await _stopAnimations(tester);
    });

    testWidgets('скелетон журнала заявляет 10 карточек', (tester) async {
      await tester.pumpWidget(_host(const TransactionsLogSkeleton()));
      await tester.pump(const Duration(milliseconds: 100));

      // ListView строит только видимые элементы, поэтому проверяем
      // заявленное число карточек, а не количество построенных виджетов.
      final list = tester.widget<ListView>(find.byType(ListView));
      expect(list.semanticChildCount, 10);
      expect(find.byType(SkeletonShimmer), findsWidgets);
      await _stopAnimations(tester);
    });
  });
}