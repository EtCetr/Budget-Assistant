// lib/features/accounts/presentation/screens/accounts_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/account_providers.dart';
import '../widgets/expansion_tile_group.dart';
import '../widgets/account_type_ui.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/account_types.dart';
import 'package:budget_assistant/core/utils/result.dart';

class AccountsScreen extends ConsumerWidget {
  final String userId;

  const AccountsScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accountsAsync = ref.watch(accountsListProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accounts'),
        leading: IconButton(
          icon: const Icon(Icons.home),
          tooltip: 'Home',
          onPressed: () => context.go('/'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.category),
            tooltip: 'Categories',
            onPressed: () => context.go('/categories'),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create account',
            onPressed: () => _showAccountDialog(context, ref),
          ),
        ],
      ),
      body: accountsAsync.when(
        data: (accounts) => _buildAccountsList(context, ref, accounts),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading accounts: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(accountsListProvider(userId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountsList(
    BuildContext context,
    WidgetRef ref,
    List<Account> accounts,
  ) {
    if (accounts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_balance_wallet, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('No accounts yet'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showAccountDialog(context, ref),
              child: const Text('Add your first account'),
            ),
          ],
        ),
      );
    }

    final grouped = <String, List<Account>>{};
    for (final account in accounts) {
      grouped.putIfAbsent(account.accountType, () => []).add(account);
    }

    // Сначала известные типы в порядке ТЗ, затем прочие
    final orderedTypes = [
      ...AccountTypes.all.where(grouped.containsKey),
      ...grouped.keys.where((t) => !AccountTypes.all.contains(t)),
    ];

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final type in orderedTypes)
          ExpansionTileGroup(
            title: accountTypeMeta(type).label,
            icon: accountTypeMeta(type).icon,
            accounts: grouped[type]!,
            onTap: (account) =>
                _showAccountDialog(context, ref, account: account),
            onLongPress: (account) => _showDeleteDialog(context, ref, account),
          ),
      ],
    );
  }

  void _showDeleteDialog(BuildContext context, WidgetRef ref, Account account) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete account?'),
        content: Text('Delete "${account.customName}"? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(dialogContext).pop();
              final useCase = ref.read(deleteAccountUseCaseProvider);
              final result = await useCase.execute(account.id);
              if (!context.mounted) return;
              result.when(
                success: (_) {
                  ref.invalidate(accountsListProvider(userId));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Account "${account.customName}" deleted')),
                  );
                },
                failure: (failure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${failure.message}')),
                  );
                },
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAccountDialog(BuildContext context, WidgetRef ref, {Account? account}) {
    showDialog(
      context: context,
      builder: (context) => _AccountDialog(userId: userId, account: account),
    );
  }
}

/// Диалог создания И редактирования счёта
class _AccountDialog extends ConsumerStatefulWidget {
  final String userId;
  final Account? account;

  const _AccountDialog({required this.userId, this.account});

  @override
  ConsumerState<_AccountDialog> createState() => _AccountDialogState();
}

class _AccountDialogState extends ConsumerState<_AccountDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _bankController;
  late final TextEditingController _balanceController;
  late String _selectedType;
  bool _isLoading = false;

  bool get _isEdit => widget.account != null;

  @override
  void initState() {
    super.initState();
    final a = widget.account;
    _nameController = TextEditingController(text: a?.customName ?? '');
    _bankController = TextEditingController(text: a?.bankName ?? '');
    _balanceController = TextEditingController(
      text: a == null ? '' : (a.currentBalance / 100).toStringAsFixed(2),
    );
    _selectedType = a?.accountType ?? AccountTypes.debit;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bankController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEdit ? 'Edit Account' : 'Create Account'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Account Name',
              hintText: 'e.g., My Card',
            ),
            autofocus: !_isEdit,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _bankController,
            decoration: const InputDecoration(
              labelText: 'Bank / Source',
              hintText: 'e.g., T-Bank, Cash box',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _balanceController,
            decoration: const InputDecoration(
              labelText: 'Balance (₽)',
              hintText: '0.00',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedType,
            decoration: const InputDecoration(labelText: 'Type'),
            items: [
              for (final type in AccountTypes.all)
                DropdownMenuItem(
                  value: type,
                  child: Text(accountTypeMeta(type).label),
                ),
            ],
            onChanged: (value) {
              setState(() {
                _selectedType = value ?? AccountTypes.debit;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _save,
          child: _isLoading
              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
              : Text(_isEdit ? 'Save' : 'Create'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account name is required')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Деньги ТОЛЬКО в копейках: double — лишь для парсинга ввода
      final balanceKopecks =
          ((double.tryParse(_balanceController.text.replaceAll(',', '.')) ?? 0.0) * 100)
              .round();
      final bank = _bankController.text.trim().isEmpty
          ? 'Manual'
          : _bankController.text.trim();

      final Result<void> result;
      if (_isEdit) {
        final a = widget.account!;
        result = await ref.read(updateAccountUseCaseProvider).execute(
              accountId: a.id,
              bankName: bank,
              customName: name,
              accountType: _selectedType,
              currency: a.currency,
              currentBalance: balanceKopecks,
              cardNumberMask: a.cardNumberMask,
              creditLimit: a.creditLimit,
            );
      } else {
        result = await ref.read(createAccountUseCaseProvider).execute(
              userId: widget.userId,
              bankName: bank,
              customName: name,
              accountType: _selectedType,
              currency: 'RUB',
              currentBalance: balanceKopecks,
            );
      }

      result.when(
        success: (_) {
          if (!mounted) return;
          Navigator.of(context).pop();
          ref.invalidate(accountsListProvider(widget.userId));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account "$name" ${_isEdit ? 'updated' : 'created'}')),
          );
        },
        failure: (failure) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${failure.message}')),
          );
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid amount: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}