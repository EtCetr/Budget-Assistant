import 'package:logger/logger.dart';
import '../../data/export/year_budget_xlsx_writer.dart';
import '../models/year_budget_models.dart';
import '../repositories/year_budget_repository.dart';
import 'calculate_year_budget_usecase.dart';

/// Динамическая копия файла владельца: «Анализ 1», «Анализ 2» + листы месяцев
/// ТОЛЬКО с данными (D23.5-7). Суммы в рублях — деление на 100 только здесь,
/// на границе экспорта-презентации.
class ExportYearBudgetXlsxUseCase {
  ExportYearBudgetXlsxUseCase({
    required YearBudgetRepository repository,
    required CalculateYearBudgetUseCase yearUseCase,
    required Logger logger,
  })  : _repository = repository,
        _yearUseCase = yearUseCase,
        _logger = logger;

  final YearBudgetRepository _repository;
  final CalculateYearBudgetUseCase _yearUseCase;
  final Logger _logger;

  static const _monthNames = [
    'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
    'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь',
  ];

  Future<String> call({
    required String userId,
    required int year,
    String? spaceId,
  }) async {
    try {
      final data = await _yearUseCase(
          userId: userId, year: year, spaceId: spaceId);
      final sheets = <XlsxSheetSpec>[
        _analysis1(data),
        _analysis2(data),
      ];
      for (final m in data.monthsWithData) {
        sheets.add(await _monthSheet(
            userId: userId, spaceId: spaceId, year: year, month: m));
      }
      final writer = YearBudgetXlsxWriter(logger: _logger);
      return writer.write(
        fileName: 'godovoy_otchet_$year.xlsx',
        sheets: sheets,
      );
    } catch (e, st) {
      _logger.e('ExportYearBudgetXlsx failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  XlsxCell _c(int? k) =>
      k == null ? const XlsxCell.text('') : XlsxCell.num(k / 100.0);
  XlsxCell _t(String v) => XlsxCell.text(v);

  List<XlsxCell> _rowCells(YearCategoryRow r) => [
        for (final v in r.months) _c(v),
        _c(r.sumKopecks),
        _c(r.avgKopecks),
      ];

  XlsxSheetSpec _analysis1(YearBudgetData d) {
    final header = [
      _t('№'), _t('Категория'),
      for (var m = 1; m <= 12; m++) _t(_monthNames[m - 1]),
      _t('Сумма'), _t('Средняя'),
    ];
    final rows = <List<XlsxCell>>[[_t('Заданные лимиты')], header];
    var n = 1;
    for (final r in d.limitRows) {
      rows.add([_t('$n'), _t(r.name), ..._rowCells(r)]);
      n++;
    }
    rows.add(_totalsRow('Сумма лимита', d.limitRows));
    rows.add([_t('')]);
    rows.add([
      _t('№'), _t('Категория'),
      for (var m = 1; m <= 12; m++) _t(_monthNames[m - 1]),
      _t('Сумма'), _t('Средняя'), _t('%'),
    ]);
    n = 1;
    for (final r in d.expenseRows) {
      rows.add([
        _t('$n'), _t(r.name), ..._rowCells(r),
        _t('${(r.percentBps / 100).toStringAsFixed(2)}%'),
      ]);
      n++;
    }
    rows.add(_totalsRow('Сумма трат', d.expenseRows));
    rows.add([
      _t(''), _t('Разница'),
      for (var m = 1; m <= 12; m++)
        _c(_monthSum(d.limitRows, m) == null &&
                _monthSum(d.expenseRows, m) == null
            ? null
            : (_monthSum(d.limitRows, m) ?? 0) -
                (_monthSum(d.expenseRows, m) ?? 0)),
    ]);
    rows.add([_t('')]);
    rows.add([
      _t('№'), _t('Категория'), _t('Лимит'), _t('Траты'),
      _t('Разница'), _t('%'),
    ]);
    n = 1;
    for (var i = 0; i < d.expenseRows.length; i++) {
      final e = d.expenseRows[i];
      final l = i < d.limitRows.length ? d.limitRows[i].sumKopecks : 0;
      rows.add([
        _t('$n'), _t(e.name), _c(l), _c(e.sumKopecks), _c(l - e.sumKopecks),
        _t('${(e.percentBps / 100).toStringAsFixed(2)}%'),
      ]);
      n++;
    }
    rows.add([
      _t(''), _t('Общая'), _c(d.totalLimitKopecks),
      _c(d.totalExpenseKopecks),
      _c(d.totalLimitKopecks - d.totalExpenseKopecks),
    ]);
    return XlsxSheetSpec(name: 'Анализ 1', rows: rows);
  }

  XlsxSheetSpec _analysis2(YearBudgetData d) {
    final rows = <List<XlsxCell>>[
      [_t('Доходы-расходы')],
      [
        _t('№'), _t('Месяц'), _t('Доходы'), _t('Расходы'),
        _t('Профицит'), _t('Разница, %'),
      ],
    ];
    for (final c in d.cashflow) {
      rows.add([
        _t('${c.month}'), _t(_monthNames[c.month - 1]),
        _c(c.incomeKopecks), _c(c.expenseKopecks), _c(c.surplusKopecks),
        _t(c.percentBps == null
            ? ''
            : '${(c.percentBps! / 100).toStringAsFixed(0)}%'),
      ]);
    }
    rows.add([
      _t(''), _t('За год'), _c(d.totalIncomeKopecks),
      _c(d.totalExpenseKopecks), _c(d.totalSurplusKopecks),
      _t(d.surplusPercentBps == null
          ? ''
          : '${(d.surplusPercentBps! / 100).toStringAsFixed(0)}%'),
    ]);
    rows.add([_t('')]);
    rows.add([_t('Структура доходов')]);
    rows.add([
      _t('№'), _t('Категория'),
      for (var m = 1; m <= 12; m++) _t(_monthNames[m - 1]),
      _t('Сумма'), _t('структура, %'),
    ]);
    var n = 1;
    for (final r in d.incomeRows) {
      rows.add([
        _t('$n'), _t(r.name),
        for (final v in r.months) _c(v),
        _c(r.sumKopecks),
        _t('${(r.percentBps / 100).toStringAsFixed(2)}%'),
      ]);
      n++;
    }
    rows.add([_t('')]);
    rows.add([_t('Структура расходов')]);
    rows.add([
      _t('№'), _t('Категория'),
      for (var m = 1; m <= 12; m++) _t(_monthNames[m - 1]),
      _t('Сумма'), _t('структура, %'),
    ]);
    n = 1;
    for (final r in d.expenseRows) {
      rows.add([
        _t('$n'), _t(r.name),
        for (final v in r.months) _c(v),
        _c(r.sumKopecks),
        _t('${(r.percentBps / 100).toStringAsFixed(2)}%'),
      ]);
      n++;
    }
    return XlsxSheetSpec(name: 'Анализ 2', rows: rows);
  }

  Future<XlsxSheetSpec> _monthSheet({
    required String userId,
    required String? spaceId,
    required int year,
    required int month,
  }) async {
    final cats =
        await _repository.categories(userId: userId, spaceId: spaceId);
    final sums = await _repository.expenseMatrix(
        userId: userId, spaceId: spaceId, year: year);
    final limits = await _repository.limitsForMonth(
        userId: userId, spaceId: spaceId, year: year, month: month);
    final allocated = await _repository.allocated(
        userId: userId, spaceId: spaceId, year: year, month: month);
    final expenses = await _repository.monthTransactions(
        userId: userId,
        spaceId: spaceId,
        year: year,
        month: month,
        type: 'expense');
    final incomes = await _repository.monthTransactions(
        userId: userId,
        spaceId: spaceId,
        year: year,
        month: month,
        type: 'income');
    final sumLimits = limits.values.fold<int>(0, (a, b) => a + b);
    final rows = <List<XlsxCell>>[
      [
        _t('${_monthNames[month - 1]} $year'),
        _t('Выделено'), _c(allocated),
        _t('Нераспределено'),
        _c(allocated == null ? null : allocated - sumLimits),
      ],
      [_t('№'), _t('Категория'), _t('Сумма'), _t('Лимит'), _t('Осталось')],
    ];
    var n = 1;
    for (final c in cats.where((c) => c.type == 'expense')) {
      final s = sums
          .where((e) => e.month == month && e.categoryId == c.id)
          .fold<int>(0, (a, e) => a + e.totalKopecks);
      rows.add([
        _t('$n'), _t(c.name), _c(s), _c(limits[c.id]),
        _c((limits[c.id] ?? 0) - s),
      ]);
      n++;
    }
    rows.add([_t('')]);
    rows.add([
      _t('№'), _t('Дата'), _t('Счёт'), _t('Категория'),
      _t('Сумма'), _t('Комментарий'),
    ]);
    for (final t in expenses) {
      final ld = t.dateUtc.toLocal();
      rows.add([
        _t(''), _t('${ld.day}.${ld.month}.${ld.year}'),
        _t(t.accountName), _t(t.categoryName),
        _c(t.amountKopecks), _t(t.comment ?? ''),
      ]);
    }
    rows.add([_t('')]);
    rows.add([_t('Доходы:')]);
    for (final t in incomes) {
      final ld = t.dateUtc.toLocal();
      rows.add([
        _t(''), _t('${ld.day}.${ld.month}.${ld.year}'),
        _t(t.accountName), _t(t.categoryName),
        _c(t.amountKopecks), _t(t.comment ?? ''),
      ]);
    }
    return XlsxSheetSpec(
        name: month.toString().padLeft(2, '0'), rows: rows);
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

  /// Итоговая строка. Средняя = сумма ÷ месяцы с данными (D23.5-3).
  List<XlsxCell> _totalsRow(String label, List<YearCategoryRow> rows) {
    final cells = <XlsxCell>[_t(''), _t(label)];
    var monthsWithData = 0;
    for (var m = 1; m <= 12; m++) {
      final v = _monthSum(rows, m);
      if (v != null) monthsWithData++;
      cells.add(_c(v));
    }
    final total = rows.fold<int>(0, (s, r) => s + r.sumKopecks);
    cells.add(_c(total));
    cells.add(_c(monthsWithData == 0 ? 0 : total ~/ monthsWithData));
    return cells;
  }
}