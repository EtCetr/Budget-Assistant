import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/formatting/money_formatter.dart';
import 'package:budget_assistant/core/formatting/money_input_parser.dart';
import 'package:budget_assistant/core/formatting/money_text_input_formatter.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/async_value_wrapper.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/models/year_budget_models.dart';
import '../providers/year_budget_providers.dart';
import '../widgets/structure_pie.dart';
import 'package:budget_assistant/features/dashboard/presentation/widgets/app_drawer.dart';

/// «Месячная статистика» — реплика месячного листа Excel (Этап 23.5).
class MonthStatsScreen extends ConsumerStatefulWidget {
  const MonthStatsScreen({
    super.key,
    required this.year,
    required this.month,
    this.spaceId,
  });

  final int year;
  final int month;
  final String? spaceId;

  @override
  ConsumerState<MonthStatsScreen> createState() => _MonthStatsScreenState();
}

class _MonthStatsScreenState extends ConsumerState<MonthStatsScreen> {
  late int _year = widget.year;
  late int _month = widget.month;

  static const _monthFull = [
    'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
    'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь',
  ];

  MonthStatsKey _key() =>
      MonthStatsKey(year: _year, month: _month, spaceId: widget.spaceId);

  void _shift(int delta) {
    var m = _month + delta;
    var y = _year;
    if (m < 1) {
      m = 12;
      y--;
    } else if (m > 12) {
      m = 1;
      y++;
    }
    setState(() {
      _month = m;
      _year = y;
    });
  }

  String _fmt(int? k) => k == null
      ? '—'
      : MoneyFormatter.formatKopecks(k, 'RUB', showSign: false);

  Future<void> _editAmount({
    required String title,
    required int? initial,
    required Future<void> Function(int kopecks) onSave,
  }) async {
    final controller = TextEditingController(
      text: initial == null ? '' : MoneyTextInputFormatter.formatKopecks(initial),
    );
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [MoneyTextInputFormatter()],
          decoration: const InputDecoration(border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
    if (saved != true) return;
    final kopecks = MoneyInputParser.parseKopecks(controller.text) ?? 0;
    try {
      await onSave(kopecks);
      if (!mounted) return;
      ref.invalidate(monthStatsProvider(_key()));
      ref.invalidate(yearBudgetDataProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Ошибка сохранения: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final key = _key();
    final data = ref.watch(monthStatsProvider(key));
    final hidden =
        ref.watch(privacyModeProvider) == BalanceVisibilityMode.hidden;

    return Scaffold(
      drawer: const AppDrawer(currentRoute: '/month-stats'),
      appBar: AppBar(
        title: Text('${_monthFull[_month - 1]} $_year'),
        actions: [
          IconButton(
            tooltip: 'Предыдущий месяц',
            icon: const Icon(Icons.chevron_left),
            onPressed: () => _shift(-1),
          ),
          IconButton(
            tooltip: 'Следующий месяц',
            icon: const Icon(Icons.chevron_right),
            onPressed: () => _shift(1),
          ),
        ],
      ),
      body: AsyncValueWrapper<MonthStatsData>(
        value: data,
        onRetry: () => ref.invalidate(monthStatsProvider(key)),
        dataBuilder: (ctx, d) => ListView(
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          children: [
            Card(
              child: ListTile(
                title: const Text('Выделено'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(hidden ? '•••' : _fmt(d.allocatedKopecks)),
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      onPressed: () => _editAmount(
                        title: 'Выделено на месяц',
                        initial: d.allocatedKopecks,
                        onSave: (k) => ref
                            .read(saveMonthBudgetUseCaseProvider)
                            .saveAllocated(
                                userId: ref.read(currentUserIdProvider),
                                key: key,
                                kopecks: k),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.spacing8),
              child: Text(
                'Нераспределено: ${hidden ? '•••' : _fmt(d.unallocatedKopecks)}',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
            if (d.carryFromMonth != null)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.spacing12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Подставить лимиты категорий и «Выделено» из '
                        '${_monthFull[d.carryFromMonth! - 1]} ${d.carryFromYear}?',
                        style: const TextStyle(fontSize: 14),
                      ),
                      const SizedBox(height: AppSpacing.spacing8),
                      FilledButton(
                        onPressed: () async {
                          try {
                            await ref
                                .read(saveMonthBudgetUseCaseProvider)
                                .carryOver(
                                  userId: ref.read(currentUserIdProvider),
                                  key: key,
                                  fromYear: d.carryFromYear!,
                                  fromMonth: d.carryFromMonth!,
                                );
                            ref.invalidate(monthStatsProvider(key));
                            ref.invalidate(yearBudgetDataProvider);
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Ошибка: $e')));
                            }
                          }
                        },
                        child: const Text('Подставить'),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: AppSpacing.spacing8),
            StructurePie(
              title: 'Структура расходов месяца',
              slices: [
                for (final c in d.categories)
                  PieSlice(c.name, c.sumKopecks, c.colorHex),
              ],
            ),
            const SizedBox(height: AppSpacing.spacing16),
            const Text('Категории: Сумма / Лимит / Осталось',
                style: TextStyle(fontWeight: FontWeight.w700)),
            for (final c in d.categories)
              ListTile(
                dense: true,
                title: Text('${c.emoji ?? ''} ${c.name}',
                    style: const TextStyle(fontSize: 14)),
                subtitle: Text(
                  'Лимит: ${hidden ? '•••' : _fmt(c.limitKopecks)} · '
                  'Осталось: ${hidden ? '•••' : _fmt(c.remainingKopecks)}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
                trailing: Text(
                  hidden ? '•••' : _fmt(c.sumKopecks),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: c.remainingKopecks < 0
                        ? AppColors.colorExpense
                        : AppColors.textPrimary,
                  ),
                ),
                onTap: c.categoryId == '__large__'
                    ? null
                    : () => _editAmount(
                          title: 'Лимит: ${c.name}',
                          initial: c.limitKopecks,
                          onSave: (k) => ref
                              .read(saveMonthBudgetUseCaseProvider)
                              .saveLimit(
                                  userId: ref.read(currentUserIdProvider),
                                  key: key,
                                  categoryId: c.categoryId,
                                  kopecks: k),
                        ),
              ),
            const SizedBox(height: AppSpacing.spacing16),
            Text('Расходы: ${hidden ? '•••' : _fmt(d.sumExpensesKopecks)}',
                style: const TextStyle(fontWeight: FontWeight.w700)),
            for (final t in d.expenses)
              ListTile(
                dense: true,
                title: Text(
                  '${DateFormat('dd.MM').format(t.dateUtc.toLocal())} · '
                  '${t.accountName} · ${t.categoryName}',
                  style: const TextStyle(fontSize: 13),
                ),
                subtitle: t.comment == null
                    ? null
                    : Text(t.comment!,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                trailing: Text(
                  hidden ? '•••' : '-${_fmt(t.amountKopecks)}',
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.colorExpense),
                ),
              ),
            const SizedBox(height: AppSpacing.spacing16),
            Text('Доходы: ${hidden ? '•••' : _fmt(d.sumIncomesKopecks)}',
                style: const TextStyle(fontWeight: FontWeight.w700)),
            for (final t in d.incomes)
              ListTile(
                dense: true,
                title: Text(
                  '${DateFormat('dd.MM').format(t.dateUtc.toLocal())} · '
                  '${t.accountName} · ${t.categoryName}',
                  style: const TextStyle(fontSize: 13),
                ),
                subtitle: t.comment == null
                    ? null
                    : Text(t.comment!,
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.textSecondary)),
                trailing: Text(
                  hidden ? '•••' : _fmt(t.amountKopecks),
                  style: const TextStyle(
                      fontSize: 13, color: AppColors.colorIncome),
                ),
              ),
          ],
        ),
      ),
    );
  }
}