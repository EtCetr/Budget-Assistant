import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';

/// Прогресс-бар сторис (ТЗ 6.3.37.3): сегментов столько, сколько слайдов
/// реально показано (динамический список по данным).
class YearReviewProgressBar extends StatelessWidget {
  const YearReviewProgressBar({
    super.key,
    required this.total,
    required this.current,
    required this.progress,
  });

  final int total;
  final int current;

  /// Заполнение активного сегмента 0..1 (анимация 7 секунд).
  final double progress;

  static const Color _done = AppColors.colorIncome;
  static const Color _waiting = Color(0x80334155);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < total; i++)
          Expanded(
            child: Container(
              margin: EdgeInsets.only(right: i == total - 1 ? 0 : 4),
              height: 4,
              child: _segment(i),
            ),
          ),
      ],
    );
  }

  Widget _segment(int i) {
    if (i < current) {
      return const DecoratedBox(
        decoration: BoxDecoration(
          color: _done,
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
      );
    }
    if (i > current) {
      return const DecoratedBox(
        decoration: BoxDecoration(
          color: _waiting,
          borderRadius: BorderRadius.all(Radius.circular(2)),
        ),
      );
    }
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(2)),
      child: Stack(
        children: [
          const ColoredBox(color: _waiting),
          FractionallySizedBox(
            widthFactor: progress.clamp(0.0, 1.0),
            child: const ColoredBox(color: _done),
          ),
        ],
      ),
    );
  }
}