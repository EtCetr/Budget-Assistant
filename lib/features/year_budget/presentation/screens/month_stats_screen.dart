import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/core/formatting/money_formatter.dart';
import 'package:budget_assistant/core/formatting/money_input_parser.dart';
import 'package:budget_assistant/core/formatting/money_text_input_formatter.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/async_value_wrapper.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/models/year_budget_models.dart';
import '../providers/year_budget_providers.dart';

/// «Месячная статистика» — реплика месячного листа Excel (Этап 23.5).
class MonthStatsScreen extends ConsumerWidget {
  const MonthStatsScreen({
    super.key,
    required this.year,
    required this.month,
    this.spaceId,
  });

  final int year;
  final int month;
  final String? spaceId;

  static const _monthFull = [
    'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
    'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь',
  ];

  String _fmt(int? k) => k == null
      ? '—'
      : MoneyFormatter.formatKopecks(k, 'RUB', showSign: false);

  MonthStatsKey _key() => MonthStatsKey(year: year, month: month, spaceId: spaceId);

  Future<void> _editAmount({
    required BuildContext context,
    required WidgetRef ref,
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
      if (!context.mounted) return;
      ref.invalidate(monthStatsProvider(_key()));
      ref.invalidate(yearBudgetDataProvider);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Ошибка сохранения: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = _key();
    final data = ref.watch(monthStatsProvider(key));
    final privacy = ref.watch(privacyModeProvider);
    final hidden = privacy == BalanceVisibilityMode.hidden;

    return Scaffold(
      appBar: AppBar(title: Text('${_monthFull[month - 1]} $year')),
      body: AsyncValueWrapper<MonthStatsData>(
        value: data,
        onRetry: () => ref.invalidate(monthStatsProvider(key)),
        isEmpty: (d) =>
            d.expenses.isEmpty && d.incomes.isEmpty && d.sumLimitsKopecks == 0,
        emptyIcon: Icons.calendar_month_outlined,
        emptyTitle: 'За этот месяц данных нет',
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
                        context: context,
                        ref: ref,
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
            if (d.allocatedKopecks != null)
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
                        'Подставить лимиты и «Выделено» из '
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
                                  userId:
                                      ref.read(currentUserIdProvider),
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
                  style: const TextStyle(fontSize: 12,
                      color: AppColors.textSecondary),
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
                          context: context,
                          ref: ref,
                          title: 'Лимит: ${c.name}',
                          initial: c.limitKopecks,
                          onSave: (k) => ref
                              .read(saveMonthBudgetUseCaseProvider)
                              .saveLimit(
                                  userId:
                                      ref.read(currentUserIdProvider),
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
                        style: const TextStyle(fontSize: 12,
                            color: AppColors.textSecondary)),
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
                        style: const TextStyle(fontSize: 12,
                            color: AppColors.textSecondary)),
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
