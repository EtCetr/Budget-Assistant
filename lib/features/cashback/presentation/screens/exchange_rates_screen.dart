// lib/features/cashback/presentation/screens/exchange_rates_screen.dart
// Этап 21 (ТЗ 6.3.38.8): график курса за год + таблица последних 30 значений.
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/cashback/presentation/providers/exchange_rates_screen_providers.dart';
import 'package:budget_assistant/features/settings/presentation/providers/settings_providers.dart';

class ExchangeRatesScreen extends ConsumerStatefulWidget {
  const ExchangeRatesScreen({super.key});

  @override
  ConsumerState<ExchangeRatesScreen> createState() =>
      _ExchangeRatesScreenState();
}

class _ExchangeRatesScreenState extends ConsumerState<ExchangeRatesScreen> {
  String? _from;

  @override
  Widget build(BuildContext context) {
    final base =
        ref.watch(appSettingsRowProvider).value?.baseCurrency ?? 'RUB';
    final currenciesAsync = ref.watch(rateCurrenciesProvider);
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceBackground,
        title: const Text('История курсов'),
      ),
      body: currenciesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => const Center(
          child: Text(
            'Не удалось загрузить валюты',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        data: (currencies) {
          final available = currencies.where((c) => c != base).toList();
          if (available.isEmpty) {
            return const Center(
              child: Text(
                'Курсов других валют пока нет.\nДобавьте курс через экран кэшбэка.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          final from = (_from != null && available.contains(_from))
              ? _from!
              : available.first;
          final ratesAsync = ref.watch(
            pairRatesProvider(RatePairQuery(from: from, to: base)),
          );
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DropdownButtonFormField<String>(
                initialValue: from,
                decoration: const InputDecoration(labelText: 'Валютная пара'),
                items: [
                  for (final c in available)
                    DropdownMenuItem(value: c, child: Text('$c → $base')),
                ],
                onChanged: (v) {
                  HapticFeedback.selectionClick();
                  setState(() => _from = v);
                },
              ),
              const SizedBox(height: 16),
              ratesAsync.when(
                loading: () => const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, st) => const SizedBox.shrink(),
                data: (rates) {
                  if (rates.isEmpty) {
                    return const SizedBox(
                      height: 200,
                      child: Center(
                        child: Text(
                          'Нет курсов за последний год',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ),
                    );
                  }
                  final chronological = rates.reversed.toList();
                  final spots = <FlSpot>[
                    for (var i = 0; i < chronological.length; i++)
                      FlSpot(i.toDouble(), chronological[i].rate),
                  ];
                  final minY =
                      spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
                  final maxY =
                      spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
                  final pad =
                      (maxY - minY) == 0 ? 1.0 : (maxY - minY) * 0.1;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 200,
                        child: LineChart(
                          LineChartData(
                            minY: minY - pad,
                            maxY: maxY + pad,
                            gridData: const FlGridData(show: false),
                            borderData: FlBorderData(show: false),
                            titlesData: const FlTitlesData(show: false),
                            lineBarsData: [
                              LineChartBarData(
                                spots: spots,
                                isCurved: true,
                                color: AppColors.colorTransfer,
                                barWidth: 2,
                                dotData: const FlDotData(show: false),
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: AppColors.colorTransfer
                                      .withValues(alpha: 0.15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Последние 30 значений',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (final r in rates.take(30))
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Text(
                                DateFormat('dd.MM.yyyy')
                                    .format(r.date.toLocal()),
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${r.rate.toStringAsFixed(4)} $base',
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}