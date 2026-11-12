import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Этап 23 (6.7.1.2): универсальный скелетон с мерцанием.
/// Скрыт от TalkBack (плейсхолдер не несёт смысла).
/// Добавлены фабрики text/title/field/avatar (6.7.1.3).
class SkeletonShimmer extends StatefulWidget {
  const SkeletonShimmer({
    super.key,
    this.width,
    required this.height,
    this.borderRadius = 12,
  });

  final double? width;
  final double height;
  final double borderRadius;

  factory SkeletonShimmer.card({double height = 72}) {
    return SkeletonShimmer(height: height);
  }

  /// Строка короткого текста.
  factory SkeletonShimmer.text() {
    return const SkeletonShimmer(height: 16, borderRadius: 4);
  }

  /// Заголовок.
  factory SkeletonShimmer.title() {
    return const SkeletonShimmer(height: 24, borderRadius: 4);
  }

  /// Поле ввода в формах.
  factory SkeletonShimmer.field() {
    return const SkeletonShimmer(height: 56);
  }

  /// Аватар.
  factory SkeletonShimmer.avatar() {
    return const SkeletonShimmer(width: 48, height: 48, borderRadius: 999);
  }

  @override
  State<SkeletonShimmer> createState() => _SkeletonShimmerState();
}

class _SkeletonShimmerState extends State<SkeletonShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
      lowerBound: 0.4,
      upperBound: 1,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: FadeTransition(
        opacity: _controller,
        child: Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
        ),
      ),
    );
  }
}

class TransactionsLogSkeleton extends StatelessWidget {
  const TransactionsLogSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      itemCount: 10,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppSpacing.spacing12),
      itemBuilder: (_, __) => SkeletonShimmer.card(),
    );
  }
}