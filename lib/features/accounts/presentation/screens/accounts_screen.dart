// lib/features/accounts/presentation/screens/accounts_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/account_providers.dart';
import '../widgets/expansion_tile_group.dart';
import '../../domain/entities/account.dart';

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
            onPressed: () => _showCreateAccountDialog(context, ref),
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
            const Icon(
              Icons.account_balance_wallet,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text('No accounts yet'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showCreateAccountDialog(context, ref),
              child: const Text('Add your first account'),
            ),
          ],
        ),
      );
    }

    final groupedAccounts = <String, List<Account>>{};
    for (final account in accounts) {
      groupedAccounts.putIfAbsent(account.accountType, () => []).add(account);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (groupedAccounts.containsKey('debit'))
          ExpansionTileGroup(
            title: 'Debit Cards',
            icon: Icons.credit_card,
            accounts: groupedAccounts['debit']!,
            onLongPress: (account) => _showDeleteDialog(context, ref, account),
          ),
        if (groupedAccounts.containsKey('credit'))
          ExpansionTileGroup(
            title: 'Credit Cards',
            icon: Icons.credit_card,
            accounts: groupedAccounts['credit']!,
            onLongPress: (account) => _showDeleteDialog(context, ref, account),
          ),
        if (groupedAccounts.containsKey('savings'))
          ExpansionTileGroup(
            title: 'Savings',
            icon: Icons.savings,
            accounts: groupedAccounts['savings']!,
            onLongPress: (account) => _showDeleteDialog(context, ref, account),
          ),
        if (groupedAccounts.containsKey('mortgage'))
          ExpansionTileGroup(
            title: 'Mortgages',
            icon: Icons.home,
            accounts: groupedAccounts['mortgage']!,
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
                    SnackBar(
                      content: Text('Account "${account.customName}" deleted'),
                    ),
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

  void _showCreateAccountDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => _CreateAccountDialog(userId: userId),
    );
  }
}

class _CreateAccountDialog extends ConsumerStatefulWidget {
  final String userId;

  const _CreateAccountDialog({required this.userId});

  @override
  ConsumerState<_CreateAccountDialog> createState() =>
      _CreateAccountDialogState();
}

class _CreateAccountDialogState extends ConsumerState<_CreateAccountDialog> {
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  String _selectedType = 'debit';
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Account'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Account Name',
              hintText: 'e.g., My Card',
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _balanceController,
            decoration: const InputDecoration(
              labelText: 'Initial Balance (₽)',
              hintText: '0.00',
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedType,
            decoration: const InputDecoration(labelText: 'Type'),
            items: const [
              DropdownMenuItem(value: 'debit', child: Text('Debit Card')),
              DropdownMenuItem(value: 'credit', child: Text('Credit Card')),
              DropdownMenuItem(value: 'savings', child: Text('Savings')),
            ],
            onChanged: (value) {
              setState(() {
                _selectedType = value ?? 'debit';
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
          onPressed: _isLoading ? null : _createAccount,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Create'),
        ),
      ],
    );
  }

  Future<void> _createAccount() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Account name is required')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Деньги ТОЛЬКО в копейках: double используется лишь для парсинга ввода
      final balanceKopecks =
          ((double.tryParse(_balanceController.text.replaceAll(',', '.')) ??
                      0.0) *
                  100)
              .round();

      final useCase = ref.read(createAccountUseCaseProvider);
      final result = await useCase.execute(
        userId: widget.userId,
        bankName: 'Manual',
        customName: name,
        accountType: _selectedType,
        currency: 'RUB',
        currentBalance: balanceKopecks,
      );

      result.when(
        success: (account) {
          if (!mounted) return;
          Navigator.of(context).pop();
          ref.invalidate(accountsListProvider(widget.userId));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Account "${account.customName}" created')),
          );
        },
        failure: (failure) {
          if (!mounted) return;
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${failure.message}')));
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Invalid amount: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
