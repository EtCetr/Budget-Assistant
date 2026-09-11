import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../labels/transactions_log_labels.dart';

class FabCreateMenu extends ConsumerWidget {
  const FabCreateMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FloatingActionButton(
      backgroundColor: AppColors.colorFAB,
      onPressed: () {
        HapticFeedback.heavyImpact();
        showFabCreateMenu(context);
      },
      child: const Icon(Icons.add, color: Colors.white),
    );
  }
}

Future<void> showFabCreateMenu(BuildContext context) async {
  await showModalBottomSheet(
    context: context,
    builder: (sheetContext) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.arrow_downward,
                color: AppColors.colorExpense,
              ),
              title: const Text(TransactionsLogLabels.createExpense),
              onTap: () {
                Navigator.of(sheetContext).pop();
                context.push('/transactions/create?type=expense');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.arrow_upward,
                color: AppColors.colorIncome,
              ),
              title: const Text(TransactionsLogLabels.createIncome),
              onTap: () {
                Navigator.of(sheetContext).pop();
                context.push('/transactions/create?type=income');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.swap_horiz,
                color: AppColors.colorTransfer,
              ),
              title: const Text(TransactionsLogLabels.createTransfer),
              onTap: () {
                Navigator.of(sheetContext).pop();
                context.push('/transactions/create?type=transfer');
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_upload_outlined),
              title: const Text(TransactionsLogLabels.importFile),
              onTap: () {
                Navigator.of(sheetContext).pop();
                context.push('/import/onboarding');
              },
            ),
            const SizedBox(height: 12),
          ],
        ),
      );
    },
  );
}
