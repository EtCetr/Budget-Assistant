import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/async_value_wrapper.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/dashboard/presentation/widgets/app_drawer.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import 'package:budget_assistant/features/spaces/domain/entities/user_space.dart';
import 'package:budget_assistant/features/spaces/presentation/providers/space_providers.dart';
import '../../domain/models/year_budget_models.dart';
import '../providers/year_budget_providers.dart';
import '../widgets/cashflow_chart.dart';
import '../widgets/matrix_table.dart';
import '../widgets/structure_pie.dart';

/// Годовой отчёт — реплика Excel-модели владельца (Этап 23.5).
/// Верхний уровень: «Анализ 1» (лимиты/траты/итоги) и «Анализ 2» (движение,
/// структуры, графики) — как листы файла владельца.
class YearBudgetScreen extends ConsumerWidget {
  const YearBudgetScreen({super.key});

  static const _monthShort = [
    'Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн',
    'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек',
  ];
  static const _monthFull = [
    'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
    'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь',
  ];

  String _fmt(int? k) {
    if (k == null) return '';
    if (k == 0) return '0';
    return (k / 100).toStringAsFixed(k % 100 == 0 ? 0 : 2);
  }

  String _pct(int bps) => '${(bps / 100).toStringAsFixed(1)}%';

  void _openMonth(BuildContext context, WidgetRef ref, int month) {
    final year = ref.read(yearBudgetYearProvider);
    final scope = ref.read(yearBudgetScopeProvider);
    final space = scope == null ? '' : '&space=$scope';
    context.push('/month-stats?year=$year&month=$month$space');
  }

  Future<void> _export(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final uid = ref.read(currentUserIdProvider);
      final year = ref.read(yearBudgetYearProvider);
      final scope = ref.read(yearBudgetScopeProvider);
      final path = await ref.read(exportYearBudgetXlsxUseCaseProvider)(
        userId: uid,
        year: year,
        spaceId: scope,
      );
      if (!context.mounted) return;
      final choice = await showDialog<String>(
        context: context,
        builder: (d) => AlertDialog(
          backgroundColor: AppColors.surfaceCard,
          title: const Text('Отчёт готов'),
          content: const Text('Куда сохранить файл отчёта?'),
          actions: [
            FilledButton.icon(
              icon: const Icon(Icons.save_outlined),
              label: const Text('Сохранить'),
              onPressed: () => Navigator.of(d).pop('save'),
            ),
            FilledButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('Поделиться'),
              onPressed: () => Navigator.of(d).pop('share'),
            ),
            TextButton(
              onPressed: () => Navigator.of(d).pop(),
              child: const Text('Отмена'),
            ),
          ],
        ),
      );
      if (choice == 'save') {
        final file = File(path);
        final bytes = await file.readAsBytes();
        const channel = MethodChannel('budget_assistant/clock');
        final uri = await channel.invokeMethod<String>('saveToDownloads', {
          'fileName': file.uri.pathSegments.last,
          'bytes': bytes,
          'mime':
              'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        });
        messenger.showSnackBar(SnackBar(
            content: Text('Сохранено: ${uri ?? 'Downloads/BudgetAssistant'}')));
      } else if (choice == 'share') {
        await SharePlus.instance.share(
          ShareParams(files: [XFile(path)], subject: 'Годовой отчёт $year'),
        );
      }
    } catch (e, st) {
      AppLogger.e('Year budget export failed', e, st);
      messenger.showSnackBar(SnackBar(content: Text('Ошибка экспорта: $e')));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = ref.watch(yearBudgetScopeProvider);
    final year = ref.watch(yearBudgetYearProvider);
    final years = ref.watch(yearBudgetYearsProvider).value ?? [year];
    final spaces = ref.watch(userSpacesProvider).value ?? const <UserSpace>[];
    final data = ref.watch(yearBudgetDataProvider);
    final privacy = ref.watch(privacyModeProvider);

    return Scaffold(
      drawer: const AppDrawer(currentRoute: '/year-budget'),
      appBar: AppBar(
        title: const Text('Годовой отчёт'),
        actions: [
          IconButton(
            tooltip: 'Месячная статистика',
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: () => _openMonth(context, ref, DateTime.now().month),
          ),
          if (privacy != BalanceVisibilityMode.hidden)
            IconButton(
              tooltip: 'Экспорт XLSX',
              icon: const Icon(Icons.download_outlined),
              onPressed: () => _export(context, ref),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('Лично'),
                    selected: scope == null,
                    onSelected: (_) =>
                        ref.read(yearBudgetScopeProvider.notifier).set(null),
                  ),
                  for (final s in spaces) ...[
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: Text(s.name),
                      selected: scope == s.id,
                      onSelected: (_) =>
                          ref.read(yearBudgetScopeProvider.notifier).set(s.id),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: DropdownButtonFormField<int>(
              initialValue: year,
              decoration: const InputDecoration(
                labelText: 'Год',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final y in years)
                  DropdownMenuItem(value: y, child: Text('$y')),
              ],
              onChanged: (v) {
                if (v != null) {
                  ref.read(yearBudgetYearProvider.notifier).set(v);
                }
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: Text(
              'Нажмите на название месяца в шапке таблицы — откроется месячная статистика.',
              style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            child: AsyncValueWrapper<YearBudgetData>(
              value: data,
              onRetry: () => ref.invalidate(yearBudgetDataProvider),
              isEmpty: (d) =>
                  d.totalExpenseKopecks == 0 &&
                  d.totalIncomeKopecks == 0 &&
                  d.totalLimitKopecks == 0,
              emptyIcon: Icons.table_chart_outlined,
              emptyTitle: 'Нет данных за выбранный год',
              emptySubtitle: 'Создайте операции или выберите другой год',
              dataBuilder: (ctx, d) => DefaultTabController(
                length: 2,
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'Анализ 1'),
                        Tab(text: 'Анализ 2'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _analysis1(context, ref, d),
                          _analysis2(context, ref, d),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Анализ 1: лимиты, траты, итоги (таблицы категория × месяц).
  Widget _analysis1(BuildContext context, WidgetRef ref, YearBudgetData d) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Лимиты'),
              Tab(text: 'Траты'),
              Tab(text: 'Итоги'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _limitsTab(context, ref, d),
                _expenseTab(context, ref, d),
                _summaryTab(d),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Анализ 2: движение, графики и структуры (как лист файла владельца).
  Widget _analysis2(BuildContext context, WidgetRef ref, YearBudgetData d) {
    final year = ref.watch(yearBudgetYearProvider);
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      children: [
        const Text('Доходы-расходы',
            style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.spacing8),
        CashflowChart(months: d.cashflow),
        const SizedBox(height: AppSpacing.spacing8),
        const Row(
          children: [
            Icon(Icons.square, size: 10, color: AppColors.colorIncome),
            SizedBox(width: 4),
            Text('Доходы', style: TextStyle(fontSize: 12)),
            SizedBox(width: 12),
            Icon(Icons.square, size: 10, color: AppColors.colorExpense),
            SizedBox(width: 4),
            Text('Расходы', style: TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: AppSpacing.spacing16),
        const Text('Профицит (доходы − расходы)',
            style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.spacing8),
        SurplusBarChart(months: d.cashflow),
        const SizedBox(height: AppSpacing.spacing16),
        const Text('Сумма трат',
            style: TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.spacing8),
        ExpenseBarChart(months: d.cashflow),
        const SizedBox(height: AppSpacing.spacing16),
        for (final c in d.cashflow)
          ListTile(
            dense: true,
            title: Text(_monthFull[c.month - 1],
                style: const TextStyle(fontSize: 14)),
            subtitle: Text(
              'Доходы ${_fmt(c.incomeKopecks)} · Расходы ${_fmt(c.expenseKopecks)}',
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _fmt(c.surplusKopecks),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: c.surplusKopecks >= 0
                        ? AppColors.colorIncome
                        : AppColors.colorExpense,
                  ),
                ),
                const Icon(Icons.chevron_right, size: 18),
              ],
            ),
            onTap: () => _openMonth(context, ref, c.month),
          ),
        const SizedBox(height: AppSpacing.spacing16),
        StructurePie(
          title: 'Структура доходов $year',
          slices: [
            for (final r in d.incomeRows)
              PieSlice(r.name, r.sumKopecks, r.colorHex),
          ],
        ),
        const SizedBox(height: AppSpacing.spacing16),
        StructurePie(
          title: 'Структура расходов $year',
          slices: [
            for (final r in d.expenseRows)
              PieSlice(r.name, r.sumKopecks, r.colorHex),
          ],
        ),
        const SizedBox(height: AppSpacing.spacing16),
        StructurePie(
          title: 'Средние лимиты по категориям',
          slices: [
            for (final r in d.limitRows)
              PieSlice(r.name, r.avgKopecks, r.colorHex),
          ],
        ),
        const SizedBox(height: AppSpacing.spacing16),
        const Text('Структура доходов (таблица)',
            style: TextStyle(fontWeight: FontWeight.w700)),
        SizedBox(
          height: 44 * (d.incomeRows.length + 2).toDouble(),
          child: MatrixTable(
            headerLabel: 'Категория',
            monthLabels: _monthShort,
            trailingHeaders: const ['Сумма', '%'],
            onMonthTap: (m) => _openMonth(context, ref, m),
            rows: [
              for (final r in d.incomeRows)
                MatrixRowVm(
                  label: r.name,
                  cells: [for (final v in r.months) _fmt(v)],
                  trailing: [_fmt(r.sumKopecks), _pct(r.percentBps)],
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.spacing16),
        const Text('Структура расходов (таблица)',
            style: TextStyle(fontWeight: FontWeight.w700)),
        SizedBox(
          height: 44 * (d.expenseRows.length + 2).toDouble(),
          child: MatrixTable(
            headerLabel: 'Категория',
            monthLabels: _monthShort,
            trailingHeaders: const ['Сумма', '%'],
            onMonthTap: (m) => _openMonth(context, ref, m),
            rows: [
              for (final r in d.expenseRows)
                MatrixRowVm(
                  label: r.name,
                  cells: [for (final v in r.months) _fmt(v)],
                  trailing: [_fmt(r.sumKopecks), _pct(r.percentBps)],
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _limitsTab(BuildContext context, WidgetRef ref, YearBudgetData d) {
    return MatrixTable(
      headerLabel: 'Категория',
      monthLabels: _monthShort,
      trailingHeaders: const ['Сумма', 'Средняя'],
      onMonthTap: (m) => _openMonth(context, ref, m),
      rows: [
        for (final r in d.limitRows)
          MatrixRowVm(
            label: r.name,
            cells: [for (final v in r.months) _fmt(v)],
            trailing: [_fmt(r.sumKopecks), _fmt(r.avgKopecks)],
          ),
        MatrixRowVm(
          label: 'Сумма лимита',
          isTotal: true,
          cells: [for (var m = 1; m <= 12; m++) _fmt(_monthSum(d.limitRows, m))],
          trailing: [_fmt(d.totalLimitKopecks), ''],
        ),
      ],
    );
  }

  Widget _expenseTab(BuildContext context, WidgetRef ref, YearBudgetData d) {
    return MatrixTable(
      headerLabel: 'Категория',
      monthLabels: _monthShort,
      trailingHeaders: const ['Сумма', 'Средняя', '%'],
      onMonthTap: (m) => _openMonth(context, ref, m),
      rows: [
        for (final r in d.expenseRows)
          MatrixRowVm(
            label: r.name,
            cells: [for (final v in r.months) _fmt(v)],
            trailing: [
              _fmt(r.sumKopecks),
              _fmt(r.avgKopecks),
              _pct(r.percentBps),
            ],
          ),
        MatrixRowVm(
          label: 'Сумма трат',
          isTotal: true,
          cells: [
            for (var m = 1; m <= 12; m++) _fmt(_monthSum(d.expenseRows, m)),
          ],
          trailing: [_fmt(d.totalExpenseKopecks), '', '100%'],
        ),
      ],
    );
  }

  Widget _summaryTab(YearBudgetData d) {
    final limitById = {for (final r in d.limitRows) r.categoryId: r.sumKopecks};
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      children: [
        for (final e in d.expenseRows)
          ListTile(
            dense: true,
            title: Text(e.name, style: const TextStyle(fontSize: 14)),
            subtitle: Text(
              'Лимит ${_fmt(limitById[e.categoryId] ?? 0)} · Траты ${_fmt(e.sumKopecks)}',
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary),
            ),
            trailing: Text(
              _fmt((limitById[e.categoryId] ?? 0) - e.sumKopecks),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: (limitById[e.categoryId] ?? 0) - e.sumKopecks >= 0
                    ? AppColors.colorIncome
                    : AppColors.colorExpense,
              ),
            ),
          ),
        const Divider(),
        ListTile(
          dense: true,
          title: const Text('Общая',
              style: TextStyle(fontWeight: FontWeight.w700)),
          subtitle: Text(
            'Лимит ${_fmt(d.totalLimitKopecks)} · Траты ${_fmt(d.totalExpenseKopecks)}',
            style: const TextStyle(
                fontSize: 12, color: AppColors.textSecondary),
          ),
          trailing: Text(
            _fmt(d.totalLimitKopecks - d.totalExpenseKopecks),
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: d.totalLimitKopecks - d.totalExpenseKopecks >= 0
                  ? AppColors.colorIncome
                  : AppColors.colorExpense,
            ),
          ),
        ),
      ],
    );
  }

  int? _monthSum(List<YearCategoryRow> rows, int m) {
    var any = false;
    var sum = 0;
    for (final r in rows) {
      final v = r.months[m - 1];
      if (v != null) {
        any = true;
        sum += v;
      }
    }
    return any ? sum : null;
  }
}