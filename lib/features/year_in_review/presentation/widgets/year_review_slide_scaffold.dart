import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';

/// Общий каркас слайда итогов года: фон-градиент + центрированный контент.
class YearReviewSlideScaffold extends StatelessWidget {
  const YearReviewSlideScaffold({super.key, required this.child, this.colors});

  final Widget child;
  final List<Color>? colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: colors ??
              const [AppColors.surfaceBackground, AppColors.surfaceCard],
        ),
      ),
      child: SafeArea(
        child: Padding(
          // Отступ сверху — под progress bar и top bar.
          padding: const EdgeInsets.fromLTRB(24, 72, 24, 48),
          child: Center(child: child),
        ),
      ),
    );
  }
}