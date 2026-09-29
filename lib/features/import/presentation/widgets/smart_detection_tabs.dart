import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import '../providers/post_import_review_notifier.dart';

/// 4 таба Smart Detection со счётчиками (ТЗ 6.3.26.4).
class SmartDetectionTabs extends ConsumerWidget {
  const SmartDetectionTabs({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postImportReviewProvider);
    final notifier = ref.read(postImportReviewProvider.notifier);
    final tabs = [
      ('Дубли', state.duplicates.length, AppColors.colorWarning),
      ('Переводы', state.transfers.length, AppColors.colorTransfer),
      ('Hold', state.holds.length, AppColors.colorWarning),
      ('Категории', notifier.uncategorizedCount, AppColors.colorFAB),
    ];
    return Row(
      children: List.generate(tabs.length, (i) {
        final (label, count, color) = tabs[i];
        final active = state.activeTab == i;
        final muted = count == 0;
        return Expanded(
          child: InkWell(
            onTap: () => notifier.setTab(i),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: active ? color : Colors.transparent,
                    width: 2,
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label,
                      style: TextStyle(
                        color: muted
                            ? AppColors.textSecondary
                            : (active ? color : AppColors.textPrimary),
                        fontWeight:
                            active ? FontWeight.w700 : FontWeight.w400,
                      )),
                  if (!muted) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text('$count',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 11)),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}