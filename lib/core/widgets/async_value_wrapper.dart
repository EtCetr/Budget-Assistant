import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import 'package:budget_assistant/core/widgets/full_screen_error.dart';
import 'package:budget_assistant/core/widgets/offline_error_card.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';

/// Этап 23 (ТОМ 7 §2.1): единая обработка 4 состояний для любых
/// асинхронных экранов:
/// 1. loading — скелетон (не спиннер);
/// 2. error — карточка ошибки + кнопка Retry;
/// 3. empty — EmptyStateWidget с призывом к действию;
/// 4. data — рендер контента.
///
/// Пример:
/// ```dart
/// AsyncValueWrapper<List<TransactionUiModel>>(
///   value: ref.watch(transactionsLogProvider),
///   onRetry: () => ref.invalidate(transactionsLogProvider),
///   isEmpty: (list) => list.isEmpty,
///   emptyIcon: Icons.receipt_long_outlined,
///   emptyTitle: 'Пока нет транзакций',
///   dataBuilder: (context, list) => TransactionsList(items: list),
/// )
/// ```
class AsyncValueWrapper<T> extends ConsumerWidget {
  const AsyncValueWrapper({
    super.key,
    required this.value,
    required this.dataBuilder,
    this.onRetry,
    this.loadingBuilder,
    this.errorMessage = 'Не удалось загрузить данные',
    this.useFullScreenError = false,
    this.isEmpty,
    this.emptyIcon = Icons.inbox_outlined,
    this.emptyTitle = 'Пока пусто',
    this.emptySubtitle,
    this.emptyPrimaryAction,
    this.emptySecondaryAction,
  });

  final AsyncValue<T> value;
  final Widget Function(BuildContext context, T data) dataBuilder;

  /// Колбэк для кнопки Retry.
  /// Обычно передаётся: `() => ref.invalidate(myProvider)`.
  final VoidCallback? onRetry;

  /// Свой скелетон вместо стандартного списка карточек.
  final WidgetBuilder? loadingBuilder;

  final String errorMessage;

  /// true — полноэкранная ошибка, false — компактная карточка.
  final bool useFullScreenError;

  /// Проверка «данные пусты» (для списков: (list) => list.isEmpty).
  final bool Function(T data)? isEmpty;

  final IconData emptyIcon;
  final String emptyTitle;
  final String? emptySubtitle;
  final EmptyStateAction? emptyPrimaryAction;
  final EmptyStateAction? emptySecondaryAction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return value.when(
      loading: () =>
          loadingBuilder?.call(context) ?? const _DefaultLoadingSkeleton(),
      error: (error, stackTrace) {
        if (useFullScreenError) {
          return FullScreenError(
            title: errorMessage,
            message: 'Проверьте данные и попробуйте снова',
            onRetry: onRetry,
          );
        }
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.spacing24),
            child: OfflineErrorCard(message: errorMessage, onRetry: onRetry),
          ),
        );
      },
      data: (data) {
        final checker = isEmpty;
        if (checker != null && checker(data)) {
          return EmptyStateWidget(
            icon: emptyIcon,
            title: emptyTitle,
            subtitle: emptySubtitle,
            primaryAction: emptyPrimaryAction,
            secondaryAction: emptySecondaryAction,
          );
        }
        return dataBuilder(context, data);
      },
    );
  }
}

/// Стандартный скелетон загрузки: 6 карточек (6.7.1.3).
class _DefaultLoadingSkeleton extends StatelessWidget {
  const _DefaultLoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      itemCount: 6,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.only(bottom: AppSpacing.spacing12),
        child: SkeletonShimmer(height: 72),
      ),
    );
  }
}