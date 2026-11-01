import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';

/// Верхняя панель сторис (ТЗ 6.3.37.4): закрыть + поделиться.
/// В режиме hidden кнопка шеринга отключена (Privacy Matrix).
class YearReviewTopBar extends StatelessWidget {
  const YearReviewTopBar({
    super.key,
    required this.canShare,
    required this.onClose,
    required this.onShare,
  });

  final bool canShare;
  final VoidCallback onClose;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.close, color: Colors.white),
          ),
          const Spacer(),
          IconButton(
            onPressed: canShare ? onShare : null,
            icon: Icon(
              Icons.share,
              color: canShare ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}