import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';

/// Строка матрицы: подпись + 12 ячеек месяцев + хвостовые колонки.
class MatrixRowVm {
  const MatrixRowVm({
    required this.label,
    required this.cells,
    required this.trailing,
    this.isTotal = false,
  });
  final String label;
  final List<String> cells;
  final List<String> trailing;
  final bool isTotal;
}

/// Матрица «категория × 12 месяцев» с закреплённой колонкой категорий и
/// синхронным горизонтальным скроллом строк (Excel-модель владельца).
class MatrixTable extends StatefulWidget {
  const MatrixTable({
    super.key,
    required this.headerLabel,
    required this.monthLabels,
    required this.trailingHeaders,
    required this.rows,
    this.onMonthTap,
  });

  final String headerLabel;
  final List<String> monthLabels;
  final List<String> trailingHeaders;
  final List<MatrixRowVm> rows;
  final ValueChanged<int>? onMonthTap;

  @override
  State<MatrixTable> createState() => _MatrixTableState();
}

class _MatrixTableState extends State<MatrixTable> {
  final List<ScrollController> _controllers = [];
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.rows.length + 1; i++) {
      _controllers.add(ScrollController());
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _sync(double pixels, int from) {
    if (_syncing) return;
    _syncing = true;
    for (var i = 0; i < _controllers.length; i++) {
      if (i == from) continue;
      final c = _controllers[i];
      if (!c.hasClients) continue;
      final target = pixels.clamp(0.0, c.position.maxScrollExtent);
      if ((c.position.pixels - target).abs() > 0.5) {
        c.jumpTo(target);
      }
    }
    _syncing = false;
  }

  Widget _cell(String text, double width, {bool bold = false, Color? color}) {
    return SizedBox(
      width: width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Text(
          text,
          textAlign: TextAlign.right,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  Widget _scrollPart(int controllerIndex, List<Widget> children) {
    return Expanded(
      child: NotificationListener<ScrollUpdateNotification>(
        onNotification: (n) {
          _sync(n.metrics.pixels, controllerIndex);
          return false;
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          controller: _controllers[controllerIndex],
          child: Row(children: children),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final headerCells = <Widget>[
      for (var m = 0; m < widget.monthLabels.length; m++)
        InkWell(
          onTap: widget.onMonthTap == null ? null : () => widget.onMonthTap!(m + 1),
          child: _cell(widget.monthLabels[m], 56, bold: true),
        ),
      for (final h in widget.trailingHeaders) _cell(h, 76, bold: true),
    ];
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SizedBox(
                width: 128,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    widget.headerLabel,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 12,
                        color: AppColors.textSecondary),
                  ),
                ),
              ),
              _scrollPart(0, headerCells),
            ],
          ),
          const Divider(height: 1, color: AppColors.borderDivider),
          for (var r = 0; r < widget.rows.length; r++)
            Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 128,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                        child: Text(
                          widget.rows[r].label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: widget.rows[r].isTotal
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    _scrollPart(r + 1, [
                      for (final c in widget.rows[r].cells)
                        _cell(c, 56, color: AppColors.textSecondary),
                      for (var t = 0; t < widget.rows[r].trailing.length; t++)
                        _cell(widget.rows[r].trailing[t], 76,
                            bold: widget.rows[r].isTotal),
                    ]),
                  ],
                ),
                const Divider(height: 1, color: AppColors.borderDivider),
              ],
            ),
        ],
      ),
    );
  }
}