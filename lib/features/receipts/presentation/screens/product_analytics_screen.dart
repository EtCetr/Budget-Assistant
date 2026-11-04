import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:budget_assistant/core/providers/security_providers.dart';
import 'package:budget_assistant/core/services/secure_flag_service.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/dashboard/presentation/widgets/app_drawer.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../labels/product_analytics_strings.dart';
import '../providers/product_analytics_providers.dart';
import '../widgets/analytics_trend_ui.dart';
import '../widgets/product_analytics_export_sheet.dart';
import '../widgets/product_details_sheet.dart';
import '../widgets/product_analytics_selectors.dart';
import '../widgets/product_analytics_summary_row.dart';
import '../widgets/price_dynamics_report.dart';
import '../widgets/top_categories_report.dart';
import '../widgets/top_products_report.dart';

/// Экран продуктовой аналитики (ТЗ 6.3.24): 3 отчёта, периоды, скоуп,
/// сводка, stale-баннер с пересчётом, экспорт CSV/PNG, deep-link по
/// product_hash.
class ProductAnalyticsScreen extends ConsumerStatefulWidget {
  const ProductAnalyticsScreen({super.key, this.initialProductHash});

  final String? initialProductHash;

  @override
  ConsumerState<ProductAnalyticsScreen> createState() =>
      _ProductAnalyticsScreenState();
}

class _ProductAnalyticsScreenState
    extends ConsumerState<ProductAnalyticsScreen> {
  final SecureFlagService _secureFlag = SecureFlagService();
  final GlobalKey _reportKey = GlobalKey();
  bool _recalculating = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _maybeAutoRecalc();
      final hash = widget.initialProductHash;
      if (hash != null && hash.isNotEmpty) {
        // Deep-link из чеков / слайда итогов года.
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: AppColors.surfaceBackground,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (ctx) => ProductDetailsSheet(productHash: hash),
        );
      }
    });
  }

  Future<void> _maybeAutoRecalc() async {
    final stale = await ref.read(productAnalyticsStaleProvider.future);
    if (!stale || !mounted) return;
    final entries = await ref.read(productAnalyticsCacheProvider.future);
    if (!mounted) return;
    if (entries.isEmpty) {
      await _recalc();
    }
  }

  Future<void> _recalc() async {
    if (_recalculating) return;
    setState(() => _recalculating = true);
    MotionTokens.medium();
    final userId = ref.read(currentUserIdProvider);
    await ref
        .read(recalculateProductAnalyticsCacheUseCaseProvider)
        .call(userId: userId);
    if (!mounted) return;
    ref.invalidate(productAnalyticsCacheProvider);
    ref.invalidate(productAnalyticsStaleProvider);
    ref.invalidate(productAnalyticsSummaryProvider);
    ref.invalidate(topProductsProvider);
    ref.invalidate(topCategoriesProvider);
    ref.invalidate(priceDynamicsProvider);
    setState(() => _recalculating = false);
  }

  void _onScan() {
    context.push('/receipts/scan');
  }

  void _onPickPeriod() {
    ref.read(productAnalyticsPeriodProvider.notifier).set('all');
  }

  void _snack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  Future<void> _exportCsv() async {
    final mode = ref.read(privacyModeProvider);
    if (mode == BalanceVisibilityMode.hidden) {
      MotionTokens.error();
      _snack(ProductAnalyticsStrings.exportBlockedHidden);
      return;
    }
    try {
      final products = await ref.read(topProductsProvider.future);
      final categories =
          ref.read(productCategoriesMapProvider).value ?? const {};
      final formatter = ref.read(privacyFormatterProvider);
      final buffer = StringBuffer();
      buffer.writeln('Название;Категория;Покупок;Средняя цена;Сумма;Тренд');
      for (final p in products) {
        final name = _csvEscape(formatter.formatProductName(p.name, mode));
        final cat = _csvEscape(
          p.categoryId == null
              ? ''
              : (categories[p.categoryId]?.$1 ?? ''),
        );
        buffer.writeln(
          '$name;$cat;${p.purchases};${p.avgPriceKopecks};'
          '${p.totalSpendKopecks};${TrendUi.label(p.trend)}',
        );
      }
      final file = File(
        '${Directory.systemTemp.path}${Platform.pathSeparator}product_analytics.csv',
      );
      await file.writeAsString('﻿${buffer.toString()}', flush: true);
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], subject: ProductAnalyticsStrings.exportTitle),
      );
      if (mounted) _snack(ProductAnalyticsStrings.exportSuccess);
    } catch (_) {
      if (mounted) _snack(ProductAnalyticsStrings.exportFailed);
    }
  }

  String _csvEscape(String value) {
    if (value.contains(';') || value.contains('"')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  Future<void> _exportPng() async {
    final mode = ref.read(privacyModeProvider);
    if (mode == BalanceVisibilityMode.hidden) {
      MotionTokens.error();
      _snack(ProductAnalyticsStrings.exportBlockedHidden);
      return;
    }
    final boundary = _reportKey.currentContext?.findRenderObject();
    if (boundary is! RenderRepaintBoundary) {
      if (mounted) _snack(ProductAnalyticsStrings.exportFailed);
      return;
    }
    bool? wasSecure;
    try {
      // Скриншот при активном FLAG_SECURE вернёт чёрный экран — снимаем на 5 сек.
      wasSecure = await _secureFlag.disableTemporarily(
        const Duration(seconds: 5),
      );
      await Future<void>.delayed(const Duration(milliseconds: 300));
      final image = await boundary.toImage(pixelRatio: 3);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      if (bytes == null) throw StateError('empty png');
      final file = File(
        '${Directory.systemTemp.path}${Platform.pathSeparator}product_analytics.png',
      );
      await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], subject: ProductAnalyticsStrings.exportTitle),
      );
      if (mounted) _snack(ProductAnalyticsStrings.exportSuccess);
    } catch (_) {
      if (mounted) _snack(ProductAnalyticsStrings.exportFailed);
    } finally {
      if (wasSecure == true) {
        await _secureFlag.restore();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(privacyModeProvider);
    final spaceId = ref.watch(currentSpaceIdProvider);
    final stale = ref.watch(productAnalyticsStaleProvider).value ?? false;
    final tab = ref.watch(productAnalyticsTabProvider);
    return Scaffold(
      drawer: const AppDrawer(currentRoute: '/product-analytics'),
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceBackground,
        title: const Text(ProductAnalyticsStrings.screenTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.download_outlined),
            onPressed: () {
              MotionTokens.light();
              ProductAnalyticsExportSheet.show(
                context,
                onCsv: _exportCsv,
                onPng: _exportPng,
              );
            },
          ),
          IconButton(
            icon: Icon(mode == BalanceVisibilityMode.visible
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined),
            onPressed: () {
              MotionTokens.light();
              ref.read(privacyModeProvider.notifier).toggle();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: AppSpacing.spacing8),
          const ProductAnalyticsPeriodSelector(),
          if (spaceId != null) const ProductAnalyticsScopeSelector(),
          const ProductAnalyticsSummaryRow(),
          if (stale || _recalculating)
            Container(
              margin: const EdgeInsets.fromLTRB(
                AppSpacing.spacing16,
                AppSpacing.spacing8,
                AppSpacing.spacing16,
                0,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spacing12,
                vertical: AppSpacing.spacing8,
              ),
              decoration: BoxDecoration(
                color: AppColors.surfaceElevated,
                borderRadius: AppRadius.radiusFull,
                border: Border.all(color: AppColors.colorWarning),
              ),
              child: Row(
                children: [
                  const Icon(Icons.schedule,
                      size: 16, color: AppColors.colorWarning),
                  const SizedBox(width: AppSpacing.spacing8),
                  Expanded(
                    child: Text(
                      _recalculating
                          ? ProductAnalyticsStrings.aggregating
                          : ProductAnalyticsStrings.staleBanner,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  if (!_recalculating)
                    TextButton(
                      onPressed: _recalc,
                      child: const Text(ProductAnalyticsStrings.staleUpdate),
                    ),
                ],
              ),
            ),
          const ProductAnalyticsTabs(),
          Expanded(
            child: RepaintBoundary(
              key: _reportKey,
              child: switch (tab) {
                'categories' => TopCategoriesReport(
                    onScan: _onScan,
                    onPickPeriod: _onPickPeriod,
                  ),
                'dynamics' => PriceDynamicsReport(
                    onScan: _onScan,
                    onPickPeriod: _onPickPeriod,
                  ),
                _ => TopProductsReport(
                    onScan: _onScan,
                    onPickPeriod: _onPickPeriod,
                  ),
              },
            ),
          ),
        ],
      ),
    );
  }
}