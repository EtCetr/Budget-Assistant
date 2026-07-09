// lib/features/accounts/presentation/screens/accounts_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to create account screen
            },
          ),
        ],
      ),
      body: accountsAsync.when(
        data: (accounts) => _buildAccountsList(context, accounts),
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
                onPressed: () => ref.refresh(accountsListProvider(userId)),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountsList(BuildContext context, List<Account> accounts) {
    // Group accounts by type
    final groupedAccounts = <String, List<Account>>{};

    for (final account in accounts) {
      groupedAccounts.putIfAbsent(account.accountType, () => []).add(account);
    }

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
              onPressed: () {
                // Navigate to create account screen
              },
              child: const Text('Add your first account'),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Group by account type
        if (groupedAccounts.containsKey('debit'))
          ExpansionTileGroup(
            title: 'Debit Cards',
            icon: Icons.credit_card,
            accounts: groupedAccounts['debit'] ?? [],
          ),
        if (groupedAccounts.containsKey('credit'))
          ExpansionTileGroup(
            title: 'Credit Cards',
            icon: Icons.credit_card,
            accounts: groupedAccounts['credit'] ?? [],
          ),
        if (groupedAccounts.containsKey('savings'))
          ExpansionTileGroup(
            title: 'Savings',
            icon: Icons.savings,
            accounts: groupedAccounts['savings'] ?? [],
          ),
        if (groupedAccounts.containsKey('mortgage'))
          ExpansionTileGroup(
            title: 'Mortgages',
            icon: Icons.home,
            accounts: groupedAccounts['mortgage'] ?? [],
          ),
      ],
    );
  }
}
