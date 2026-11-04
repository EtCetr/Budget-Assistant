import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import '../labels/product_analytics_strings.dart';

/// Bottom-sheet экспорта (ТЗ 6.3.24.7): CSV / PNG / отмена.
class ProductAnalyticsExportSheet extends StatelessWidget {
  const ProductAnalyticsExportSheet({
    super.key,
    required this.onCsv,
    required this.onPng,
  });

  final Future<void> Function() onCsv;
  final Future<void> Function() onPng;

  static Future<void> show(
    BuildContext context, {
    required Future<void> Function() onCsv,
    required Future<void> Function() onPng,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (ctx) => ProductAnalyticsExportSheet(onCsv: onCsv, onPng: onPng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              ProductAnalyticsStrings.exportTitle,
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.table_chart_outlined,
                color: AppColors.colorIncome),
            title: const Text(ProductAnalyticsStrings.exportCsv),
            subtitle: const Text(ProductAnalyticsStrings.exportCsvSub),
            onTap: () {
              Navigator.pop(context);
              onCsv();
            },
          ),
          ListTile(
            leading: const Icon(Icons.image_outlined,
                color: AppColors.colorTransfer),
            title: const Text(ProductAnalyticsStrings.exportPng),
            subtitle: const Text(ProductAnalyticsStrings.exportPngSub),
            onTap: () {
              Navigator.pop(context);
              onPng();
            },
          ),
          ListTile(
            leading: const Icon(Icons.close),
            title: const Text(ProductAnalyticsStrings.exportCancel),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}