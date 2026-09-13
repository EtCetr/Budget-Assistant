import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/categories/presentation/providers/category_providers.dart';
import '../../domain/entities/cashback_entry.dart';
import '../providers/cashback_providers.dart';
import '../widgets/cashback_entry_card.dart';
import '../widgets/add_cashback_entry_dialog.dart';
import '../widgets/exchange_rates_dialog.dart';

/// Экран кэшбэка (Этап 10): выбор карты, категории кэшбэка, расчёт выгоды,
/// управление курсами валют.
class CashbackScreen extends ConsumerStatefulWidget {
  const CashbackScreen({super.key});

  @override
  ConsumerState<CashbackScreen> createState() => _CashbackScreenState();
}

class _CashbackScreenState extends ConsumerState<CashbackScreen> {
  String? _selectedAccountId;

  DateTime _nextReset(String lifetimeType) {
    final now = DateTime.now().toLocal();
    if (lifetimeType == 'weekly') {
      final daysToNextMonday = DateTime.daysPerWeek - now.weekday + 1;
      return DateTime(now.year, now.month, now.day + daysToNextMonday).toUtc();
    }
    return DateTime(now.year, now.month + 1, 1).toUtc();
  }

  Future<void> _addEntry(String accountId) async {
    final userId = ref.read(currentUserIdProvider);
    final categories =
        await ref.read(categoryRepositoryProvider).getCategoriesByUserId(userId);
    final expenseCategories =
        categories.where((c) => c.type == 'expense').toList();
    if (!mounted) return;
    final result = await AddCashbackEntryDialog.show(context, expenseCategories);
    if (result == null) return;
    final now = DateTime.now().toUtc();
    final entry = CashbackEntry(
      id: const Uuid().v4(),
      accountId: accountId,
      categoryId: result.categoryId,
      categoryName: result.categoryName,
      percentBps: result.percentBps,
      status: 'potential',
      lifetimeType: result.lifetimeType,
      expiresAt: _nextReset(result.lifetimeType),
      createdAt: now,
      updatedAt: now,
      syncStatus: SyncStatus.pending,
    );
    try {
      await ref.read(cashbackRepositoryProvider).createEntry(entry);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось добавить категорию кэшбэка')),
        );
      }
    }
  }

  Future<void> _deleteEntry(String entryId) async {
    try {
      await ref.read(cashbackRepositoryProvider).deleteEntry(entryId);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Не удалось удалить')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final accountsAsync = ref.watch(cashbackAccountsProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Кэшбэк'),
        actions: [
          IconButton(
            tooltip: 'Курсы валют',
            icon: const Icon(Icons.currency_exchange),
            onPressed: () => ExchangeRatesDialog.show(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectedAccountId == null
            ? null
            : () => _addEntry(_selectedAccountId!),
        child: const Icon(Icons.add),
      ),
      body: accountsAsync.when(
        data: (accounts) {
          if (accounts.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text('Нет доступных карт. Добавьте счёт, чтобы настроить кэшбэк.'),
              ),
            );
          }
          final effectiveId = _selectedAccountId ?? accounts.first.id;
          final selected = accounts.firstWhere(
            (a) => a.id == effectiveId,
            orElse: () => accounts.first,
          );
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: selected.id,
                  items: accounts
                      .map((a) => DropdownMenuItem(
                            value: a.id,
                            child: Text(
                              '${a.customName.isNotEmpty ? a.customName : a.bankName} (${a.currency})',
                            ),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => _selectedAccountId = v),
                ),
              ),
              Expanded(
                child: ref.watch(cashbackSummariesProvider(selected.id)).when(
                      data: (summaries) {
                        if (summaries.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(24),
                              child: Text(
                                'Категории кэшбэка не настроены.\nНажмите + чтобы добавить.',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: summaries.length,
                          itemBuilder: (context, i) {
                            final s = summaries[i];
                            return CashbackEntryCard(
                              summary: s,
                              onDelete: () => _deleteEntry(s.entryId),
                            );
                          },
                        );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) =>
                          Center(child: Text('Ошибка расчёта: $e')),
                    ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Ошибка загрузки счетов: $e')),
      ),
    );
  }
}