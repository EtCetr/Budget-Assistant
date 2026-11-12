import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';

class PieSlice {
  const PieSlice(this.label, this.valueKopecks, this.colorHex);
  final String label;
  final int valueKopecks;
  final String? colorHex;
}

const _palette = <Color>[
  Color(0xFF4E79A7), Color(0xFFF28E2B), Color(0xFFE15759), Color(0xFF76B7B2),
  Color(0xFF59A14F), Color(0xFFEDC948), Color(0xFFB07AA1), Color(0xFFFF9DA7),
  Color(0xFF9C755F), Color(0xFFBAB0AC), Color(0xFF86BCB6), Color(0xFFD37295),
];

Color _colorOf(PieSlice s, int i) {
  final h = s.colorHex;
  if (h != null && h.length >= 6) {
    final v = int.tryParse(h.replaceAll('#', ''), radix: 16);
    if (v != null) return Color(0xFF000000 | v);
  }
  return _palette[i % _palette.length];
}

/// Круговая диаграмма структуры (доходы / расходы / средние лимиты).
class StructurePie extends StatelessWidget {
  const StructurePie({super.key, required this.title, required this.slices});
  final String title;
  final List<PieSlice> slices;

  @override
  Widget build(BuildContext context) {
    final positive = slices.where((s) => s.valueKopecks > 0).toList();
    final total = positive.fold<int>(0, (s, e) => s + e.valueKopecks);
    if (total == 0) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.spacing8),
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sectionsSpace: 1,
              centerSpaceRadius: 0,
              sections: [
                for (var i = 0; i < positive.length; i++)
                  PieChartSectionData(
                    value: positive[i].valueKopecks / 100.0,
                    color: _colorOf(positive[i], i),
                    radius: 110,
                    title:
                        '${(positive[i].valueKopecks * 100 / total).toStringAsFixed(0)}%',
                    titleStyle: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.spacing8),
        Wrap(
          spacing: 10,
          runSpacing: 4,
          children: [
            for (var i = 0; i < positive.length; i++)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    color: _colorOf(positive[i], i),
                  ),
                  const SizedBox(width: 4),
                  Text(positive[i].label,
                      style: const TextStyle(fontSize: 11)),
                ],
              ),
          ],
        ),
      ],
    );
  }
}