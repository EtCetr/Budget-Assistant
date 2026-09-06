// lib/features/accounts/presentation/widgets/expansion_tile_group.dart
import 'package:flutter/material.dart';
import '../../domain/entities/account.dart';
import 'account_card.dart';

class ExpansionTileGroup extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Account> accounts;
  final void Function(Account account)? onLongPress;

  const ExpansionTileGroup({
    super.key,
    required this.title,
    required this.icon,
    required this.accounts,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (accounts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ExpansionTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '(${accounts.length})',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.expand_more),
          ],
        ),
        initiallyExpanded: true,
        children: accounts.map((account) {
          final card = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: AccountCard(account: account),
          );
          if (onLongPress == null) return card;
          return GestureDetector(
            onLongPress: () => onLongPress!(account),
            child: card,
          );
        }).toList(),
      ),
    );
  }
}
