import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/providers/security_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/categories/presentation/providers/category_providers.dart';
import '../../domain/entities/cashback_account_ref.dart';
import '../../domain/entities/cashback_entry.dart';
import '../providers/cashback_providers.dart';
import '../widgets/cashback_entry_card.dart';
import '../widgets/cashback_matrix_table.dart';
import '../widgets/add_cashback_entry_dialog.dart';
import '../widgets/exchange_rates_dialog.dart';

/// Экран кэшбэка (Этап 10): режимы «По картам» и «Матрица выгоды»,
/// источник счетов «Мои карты / Карты семьи», статусы potential/approved,
/// удаление только через диалог подтверждения.
class CashbackScreen extends ConsumerStatefulWidget {
  const CashbackScreen({super.key});

  @override
  ConsumerState<CashbackScreen> createState() => _CashbackScreenState();
}

class _CashbackScreenState extends ConsumerState<CashbackScreen> {
  String? _selectedAccountId;
  bool _matrixMode = false;

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

  /// Защита от случайного нажатия: удаление только после подтверждения.
  Future<void> _confirmDeleteEntry(String entryId, String categoryName) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Удалить категорию кэшбэка?'),
        content: Text(
          'Категория «$categoryName» и её расчёты будут удалены с экрана '
          'кэшбэка и матрицы выгоды. Действие нельзя отменить.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await _deleteEntry(entryId);
  }

  Future<String?> _pickAccount() async {
    final source = ref.read(cashbackAccountsSourceProvider);
    final accounts = source == CashbackAccountsSource.mine
        ? await ref.read(cashbackAccountsProvider.future)
        : await ref.read(cashbackFamilyAccountsProvider.future);
    if (!mounted || accounts.isEmpty) return null;
    if (accounts.length == 1) return accounts.first.id;
    return showModalBottomSheet<String>(
      context: context,
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text('К какой карте добавить категорию?'),
            ),
            for (final a in accounts)
              ListTile(
                title: Text('${a.name} (${a.currency})'),
                onTap: () => Navigator.of(sheetContext).pop(a.id),
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final source = ref.watch(cashbackAccountsSourceProvider);
    final currentSpaceId = ref.watch(currentSpaceIdProvider);
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
        onPressed: () async {
          final accountId = _selectedAccountId ?? await _pickAccount();
          if (accountId != null && mounted) {
            await _addEntry(accountId);
          }
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: false,
                  label: Text('По картам'),
                  icon: Icon(Icons.credit_card),
                ),
                ButtonSegment(
                  value: true,
                  label: Text('Матрица выгоды'),
                  icon: Icon(Icons.grid_on),
                ),
              ],
              selected: {_matrixMode},
              onSelectionChanged: (s) => setState(() => _matrixMode = s.first),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: SegmentedButton<CashbackAccountsSource>(
              segments: const [
                ButtonSegment(
                  value: CashbackAccountsSource.mine,
                  label: Text('Мои карты'),
                ),
                ButtonSegment(
                  value: CashbackAccountsSource.family,
                  label: Text('Карты семьи'),
                ),
              ],
              selected: {source},
              onSelectionChanged: (s) {
                ref.read(cashbackAccountsSourceProvider.notifier).set(s.first);
                setState(() => _selectedAccountId = null);
              },
            ),
          ),
          Expanded(child: _buildContent(source, currentSpaceId)),
        ],
      ),
    );
  }

  Widget _buildContent(CashbackAccountsSource source, String? currentSpaceId) {
    if (source == CashbackAccountsSource.family) {
      if (currentSpaceId == null) {
        return const _CenteredMessage(
          icon: Icons.group_off,
          text: 'Нет активной группы.\n'
              'Создайте группу в экране транзакций («Создать группу») '
              'или переключитесь на «Мои карты».',
        );
      }
      return ref.watch(cashbackFamilyAccountsProvider).when(
            data: (accounts) {
              if (accounts.isEmpty) {
                return const _CenteredMessage(
                  icon: Icons.account_balance_wallet_outlined,
                  text: 'В группе пока нет счетов, доступных на этом '
                      'устройстве.\nСчета других участников появятся, когда '
                      'заработает синхронизация с Supabase (Этап 25).',
                );
              }
              return _buildForAccounts(accounts);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Ошибка загрузки счетов семьи: $e')),
          );
    }
    return ref.watch(cashbackAccountsProvider).when(
          data: (accounts) {
            if (accounts.isEmpty) {
              return const _CenteredMessage(
                icon: Icons.account_balance_wallet_outlined,
                text: 'Нет доступных карт.\nДобавьте счёт, чтобы настроить кэшбэк.',
              );
            }
            return _buildForAccounts(accounts);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Ошибка загрузки счетов: $e')),
        );
  }

  Widget _buildForAccounts(List<CashbackAccountRef> accounts) {
    if (_matrixMode) {
      return ref.watch(cashbackMatrixProvider).when(
            data: (rows) => CashbackMatrixTable(rows: rows, accounts: accounts),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Ошибка матрицы: $e')),
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
                      child: Text('${a.name} (${a.currency})'),
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
                          'Категории кэшбэка не настроены или в текущем цикле '
                          'нет операций.\nНажмите + чтобы добавить.',
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
                        onDelete: () =>
                            _confirmDeleteEntry(s.entryId, s.categoryName),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Ошибка расчёта: $e')),
              ),
        ),
      ],
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  const _CenteredMessage({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}