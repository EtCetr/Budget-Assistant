import 'package:flutter/material.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import 'package:budget_assistant/features/import/domain/entities/import_result.dart';

// TODO(Этап 15.4): заменить на полный PostImportReviewScreen (4 таба).
class PostImportReviewStubScreen extends StatelessWidget {
  const PostImportReviewStubScreen({super.key, this.result});

  final ImportResult? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        title: const Text('Проверка импорта'),
        backgroundColor: AppColors.surfaceBackground,
      ),
      body: EmptyStateWidget(
        icon: Icons.fact_check_outlined,
        title: 'Экран проверки импорта',
        subtitle: result == null
            ? 'Нет данных импорта'
            : 'Готово к проверке: ${result!.rows.length} транзакций, '
                '${result!.duplicates.length} дублей. Появится в Этапе 15.4',
      ),
    );
  }
}