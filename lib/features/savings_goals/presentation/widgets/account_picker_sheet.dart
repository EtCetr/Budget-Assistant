import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';

/// BottomSheet-пикер счёта с балансами (privacy-aware).
/// Возвращает id выбранного счёта или null.
Future<String?> showAccountPickerSheet(
  BuildContext context, {
  required List<Account> accounts,
  String? selectedId,
  String? title,
}) {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _AccountPickerSheet(
      accounts: accounts,
      selectedId: selectedId,
      title: title,
    ),
  );
}

class _AccountPickerSheet extends ConsumerWidget {
  const _AccountPickerSheet({
    required this.accounts,
    this.selectedId,
    this.title,
  });
  final List<Account> accounts;
  final String? selectedId;
  final String? title;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatter = ref.watch(privacyFormatterProvider);
    final mode = ref.watch(privacyModeProvider);
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(title!,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                for (final account in accounts)
                  ListTile(
                    leading: account.id == selectedId
                        ? const Icon(Icons.check_circle)
                        : const Icon(Icons.account_balance_wallet),
                    title: Text(_label(account)),
                    subtitle: Text(formatter.formatAmount(
                        account.currentBalance, account.currency, mode)),
                    onTap: () => Navigator.of(context).pop(account.id),
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _label(Account account) {
    final buffer = StringBuffer(account.bankName);
    if (account.customName.isNotEmpty) buffer.write(' ${account.customName}');
    final mask = account.cardNumberMask;
    if (mask != null && mask.isNotEmpty) buffer.write(' $mask');
    return buffer.toString();
  }
}