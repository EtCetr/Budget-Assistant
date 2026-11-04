import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/product_analytics_models.dart';

/// Мини-график истории цены (спарклайн). Менее 2 точек — не рисуем.
class SparklineChart extends StatelessWidget {
  const SparklineChart({
    super.key,
    required this.points,
    required this.color,
    this.width = 64,
    this.height = 24,
  });

  final List<PricePoint> points;
  final Color color;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) return const SizedBox.shrink();
    final spots = <FlSpot>[
      for (var i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].priceKopecks.toDouble()),
    ];
    return SizedBox(
      width: width,
      height: height,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: false,
              barWidth: 2,
              color: color,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
          titlesData: const FlTitlesData(show: false),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          lineTouchData: const LineTouchData(enabled: false),
        ),
      ),
    );
  }
}