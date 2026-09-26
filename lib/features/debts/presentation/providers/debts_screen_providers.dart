import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import '../../domain/entities/debt.dart';
import 'debts_providers.dart';

/// Вкладка экрана долгов (6.3.13.3).
enum DebtsTab { payable, receivable }

/// Фильтр списка долгов (6.3.13.5).
enum DebtsScreenFilter { all, active, overdue, resolved }

class DebtsTabNotifier extends Notifier<DebtsTab> {
  @override
  DebtsTab build() => DebtsTab.payable;
  void set(DebtsTab tab) => state = tab;
}

final debtsTabProvider = NotifierProvider<DebtsTabNotifier, DebtsTab>(
  DebtsTabNotifier.new,
);

class DebtsScreenFilterNotifier extends Notifier<DebtsScreenFilter> {
  @override
  DebtsScreenFilter build() => DebtsScreenFilter.all;
  void set(DebtsScreenFilter filter) => state = filter;
}

final debtsScreenFilterProvider =
    NotifierProvider<DebtsScreenFilterNotifier, DebtsScreenFilter>(
  DebtsScreenFilterNotifier.new,
);

/// Секция списка долгов (заголовок + карточки).
class DebtSection {
  const DebtSection({required this.title, required this.debts});
  final String title;
  final List<Debt> debts;
}

/// Видимые секции для текущей вкладки и фильтра.
///
/// Правила (6.3.13.1/.5/.8):
/// - ex-member долги живут в отдельной секции и исключены из
///   «Активные»/«Просрочено» в фильтре «Все»;
/// - фильтр «Активные»/«Просрочено» показывает только свою секцию;
/// - фильтр «Закрытые» показывает закрытые долги обоих направлений
///   текущей вкладки.
final debtSectionsProvider = Provider<List<DebtSection>>((ref) {
  final groups = ref.watch(debtsGroupsProvider);
  final tab = ref.watch(debtsTabProvider);
  final filter = ref.watch(debtsScreenFilterProvider);
  final now = DateTime.now().toUtc();

  final active = tab == DebtsTab.payable
      ? groups.payableActive
      : groups.receivableActive;
  final closed = tab == DebtsTab.payable
      ? groups.payableClosed
      : groups.receivableClosed;

  final ex = active.where((d) => d.isExMemberDebt).toList();
  final overdue = active
      .where((d) => !d.isExMemberDebt && d.isOverdueAt(now))
      .toList();
  final plainActive = active
      .where((d) => !d.isExMemberDebt && !d.isOverdueAt(now))
      .toList();

  switch (filter) {
    case DebtsScreenFilter.all:
      return [
        if (plainActive.isNotEmpty)
          DebtSection(title: DebtsSectionTitles.active, debts: plainActive),
        if (overdue.isNotEmpty)
          DebtSection(title: DebtsSectionTitles.overdue, debts: overdue),
        if (ex.isNotEmpty)
          DebtSection(title: DebtsSectionTitles.exMember, debts: ex),
      ];
    case DebtsScreenFilter.active:
      return [
        if (plainActive.isNotEmpty)
          DebtSection(title: DebtsSectionTitles.active, debts: plainActive),
      ];
    case DebtsScreenFilter.overdue:
      return [
        if (overdue.isNotEmpty)
          DebtSection(title: DebtsSectionTitles.overdue, debts: overdue),
      ];
    case DebtsScreenFilter.resolved:
      return [
        if (closed.isNotEmpty)
          DebtSection(title: DebtsSectionTitles.resolved, debts: closed),
      ];
  }
});

/// Заголовки секций вынесены, чтобы провайдер не импортировал виджеты.
abstract final class DebtsSectionTitles {
  static const String active = 'Активные';
  static const String overdue = 'Просрочено';
  static const String exMember = 'От ex-члена семьи';
  static const String resolved = 'Закрытые';
}

/// Display name контрагента-члена семьи (для склонения в дательный).
final debtCounterpartyNameProvider =
    FutureProvider.family<String?, String>((ref, userId) async {
  final user = await ref.watch(usersDaoProvider).getById(userId);
  return user?.displayName;
});