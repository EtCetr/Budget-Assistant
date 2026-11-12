import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/widgets/async_value_wrapper.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import 'package:budget_assistant/core/widgets/full_screen_error.dart';
import 'package:budget_assistant/core/widgets/offline_error_card.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';

/// Этап 23.7: регресс-тесты AsyncValueWrapper (решение D23-6).
/// Проверяем контракт обёртки: 4 состояния + кастомные билдеры + Retry.
Widget _host(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      home: Scaffold(body: child),
    ),
  );
}

/// Кнопка Retry внутри карточки ошибки: тип кнопки не зашит в тест,
/// чтобы не зависеть от внутренней вёрстки OfflineErrorCard.
Future<bool> _tapRetry(WidgetTester tester) async {
  final candidates = <Finder>[
    find.descendant(
      of: find.byType(OfflineErrorCard),
      matching: find.bySubtype<ButtonStyleButton>(),
    ),
    find.descendant(
      of: find.byType(OfflineErrorCard),
      matching: find.byType(InkWell),
    ),
    find.byIcon(Icons.refresh),
  ];
  for (final finder in candidates) {
    if (finder.evaluate().isNotEmpty) {
      await tester.tap(finder.first, warnIfMissed: false);
      await tester.pump();
      return true;
    }
  }
  return false;
}

void main() {
  group('AsyncValueWrapper — 4 состояния (D23-3 / D23-6)', () {
    testWidgets('loading: скелетон, контент не рендерится', (tester) async {
      await tester.pumpWidget(
        _host(
          AsyncValueWrapper<int>(
            value: const AsyncValue<int>.loading(),
            dataBuilder: (_, __) => const Text('КОНТЕНТ'),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(SkeletonShimmer), findsWidgets);
      expect(find.text('КОНТЕНТ'), findsNothing);
      expect(find.byType(OfflineErrorCard), findsNothing);
      expect(find.byType(EmptyStateWidget), findsNothing);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('loading: кастомный loadingBuilder заменяет скелетон',
        (tester) async {
      await tester.pumpWidget(
        _host(
          AsyncValueWrapper<int>(
            value: const AsyncValue<int>.loading(),
            loadingBuilder: (_) => const Text('МОЙ СКЕЛЕТОН'),
            dataBuilder: (_, __) => const Text('КОНТЕНТ'),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('МОЙ СКЕЛЕТОН'), findsOneWidget);
      expect(find.byType(SkeletonShimmer), findsNothing);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('error: компактная карточка ошибки', (tester) async {
      await tester.pumpWidget(
        _host(
          AsyncValueWrapper<int>(
            value: AsyncValue<int>.error(Exception('boom'), StackTrace.current),
            errorMessage: 'Тестовая ошибка',
            dataBuilder: (_, __) => const Text('КОНТЕНТ'),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(OfflineErrorCard), findsOneWidget);
      expect(find.byType(FullScreenError), findsNothing);
      expect(find.text('КОНТЕНТ'), findsNothing);
    });

    testWidgets('error: useFullScreenError разворачивает FullScreenError',
        (tester) async {
      await tester.pumpWidget(
        _host(
          AsyncValueWrapper<int>(
            value: AsyncValue<int>.error(Exception('boom'), StackTrace.current),
            useFullScreenError: true,
            dataBuilder: (_, __) => const Text('КОНТЕНТ'),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(FullScreenError), findsOneWidget);
      expect(find.byType(OfflineErrorCard), findsNothing);
    });

    testWidgets('error: onRetry вызывается по кнопке Retry', (tester) async {
      var retried = 0;
      await tester.pumpWidget(
        _host(
          AsyncValueWrapper<int>(
            value: AsyncValue<int>.error(Exception('boom'), StackTrace.current),
            onRetry: () => retried++,
            dataBuilder: (_, __) => const Text('КОНТЕНТ'),
          ),
        ),
      );
      await tester.pump();

      final tapped = await _tapRetry(tester);
      expect(tapped, isTrue, reason: 'Кнопка Retry не найдена в OfflineErrorCard');
      expect(retried, 1);
    });

    testWidgets('error: onRetry = null не роняет экран', (tester) async {
      await tester.pumpWidget(
        _host(
          AsyncValueWrapper<int>(
            value: AsyncValue<int>.error(Exception('boom'), StackTrace.current),
            dataBuilder: (_, __) => const Text('КОНТЕНТ'),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(OfflineErrorCard), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('empty: isEmpty = true показывает EmptyStateWidget',
        (tester) async {
      await tester.pumpWidget(
        _host(
          AsyncValueWrapper<List<int>>(
            value: const AsyncValue<List<int>>.data(<int>[]),
            isEmpty: (list) => list.isEmpty,
            emptyIcon: Icons.inbox_outlined,
            emptyTitle: 'Тестовое пусто',
            emptySubtitle: 'Подзаголовок пусто',
            dataBuilder: (_, __) => const Text('КОНТЕНТ'),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(EmptyStateWidget), findsOneWidget);
      expect(find.text('Тестовое пусто'), findsOneWidget);
      expect(find.text('Подзаголовок пусто'), findsOneWidget);
      expect(find.text('КОНТЕНТ'), findsNothing);
    });

    testWidgets('empty: кнопка действия вызывает колбэк', (tester) async {
      var pressed = 0;
      await tester.pumpWidget(
        _host(
          AsyncValueWrapper<List<int>>(
            value: const AsyncValue<List<int>>.data(<int>[]),
            isEmpty: (list) => list.isEmpty,
            emptyTitle: 'Тестовое пусто',
            emptyPrimaryAction: EmptyStateAction(
              label: 'Тестовое действие',
              onPressed: () => pressed++,
            ),
            dataBuilder: (_, __) => const Text('КОНТЕНТ'),
          ),
        ),
      );
      await tester.pump();

      final action = find.text('Тестовое действие');
      expect(action, findsOneWidget);
      await tester.tap(action, warnIfMissed: false);
      await tester.pump();
      expect(pressed, 1);
    });

    testWidgets('data: isEmpty = false рендерит контент', (tester) async {
      await tester.pumpWidget(
        _host(
          AsyncValueWrapper<List<int>>(
            value: const AsyncValue<List<int>>.data(<int>[1, 2, 3]),
            isEmpty: (list) => list.isEmpty,
            emptyTitle: 'Тестовое пусто',
            dataBuilder: (_, data) => Text('КОНТЕНТ ${data.length}'),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('КОНТЕНТ 3'), findsOneWidget);
      expect(find.byType(EmptyStateWidget), findsNothing);
    });

    testWidgets('data: без isEmpty пустой список всё равно рендерит контент',
        (tester) async {
      await tester.pumpWidget(
        _host(
          AsyncValueWrapper<List<int>>(
            value: const AsyncValue<List<int>>.data(<int>[]),
            dataBuilder: (_, data) => Text('КОНТЕНТ ${data.length}'),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('КОНТЕНТ 0'), findsOneWidget);
      expect(find.byType(EmptyStateWidget), findsNothing);
    });
  });
}