import 'package:flutter/material.dart';

/// Прогресс-бар сторис (ТЗ 6.3.37.3, стиль Instagram Stories по решению
/// владельца): белые сегменты, активный плавно заполняется за 7 секунд.
class YearReviewProgressBar extends StatelessWidget {
  const YearReviewProgressBar({
    super.key,
    required this.total,
    required this.current,
    required this.progress,
  });

  final int total;
  final int current;

  /// Заполнение активного сегмента 0..1.
  final double progress;

  static const Color _done = Colors.white;
  static const Color _waiting = Color(0x59FFFFFF);
  static const BorderRadius _radius = BorderRadius.all(Radius.circular(2));

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
        decoration: BoxDecoration(color: _done, borderRadius: _radius),
      );
    }
    if (i > current) {
      return const DecoratedBox(
        decoration: BoxDecoration(color: _waiting, borderRadius: _radius),
      );
    }
    final p = progress.clamp(0.0, 1.0);
    // LayoutBuilder + явные SizedBox: гарантированная отрисовка заполнения
    // (Stack с «голыми» ColoredBox схлопывался в нулевую высоту).
    return ClipRRect(
      borderRadius: _radius,
      child: LayoutBuilder(
        builder: (context, c) => Row(
          children: [
            SizedBox(
              width: c.maxWidth * p,
              height: c.maxHeight,
              child: const ColoredBox(color: _done),
            ),
            SizedBox(
              width: c.maxWidth * (1.0 - p),
              height: c.maxHeight,
              child: const ColoredBox(color: _waiting),
            ),
          ],
        ),
      ),
    );
  }
}