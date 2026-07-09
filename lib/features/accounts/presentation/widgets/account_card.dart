// lib/features/accounts/presentation/widgets/account_card.dart
import 'package:flutter/material.dart';
import '../../domain/entities/account.dart';

class AccountCard extends StatelessWidget {
  final Account account;
  final VoidCallback? onTap;

  const AccountCard({super.key, required this.account, this.onTap});

  String _formatBalance(int kopecks) {
    final rubles = kopecks ~/ 100;
    final kops = kopecks % 100;
    return '${rubles.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]} ')}₽ ${kops.toString().padLeft(2, '0')}коп';
  }

  Color _getGradientStartColor() {
    switch (account.accountType) {
      case 'debit':
        return Colors.blue.shade700;
      case 'credit':
        return Colors.purple.shade700;
      case 'savings':
        return Colors.green.shade700;
      case 'mortgage':
        return Colors.orange.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                _getGradientStartColor(),
                _getGradientStartColor().withValues(alpha: 0.7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                account.accountType.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatBalance(account.currentBalance),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (account.cardNumberMask != null)
                Text(
                  account.cardNumberMask!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    letterSpacing: 2,
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                account.customName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (account.syncStatus == 'pending')
                Align(
                  alignment: Alignment.topRight,
                  child: Icon(
                    Icons.cloud_off,
                    color: Colors.white.withValues(alpha: 0.5),
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
