import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import '../providers/import_onboarding_notifier.dart';

class Step1FileUploadWidget extends ConsumerWidget {
  const Step1FileUploadWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(importOnboardingProvider);
    final notifier = ref.read(importOnboardingProvider.notifier);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.upload_file,
              size: 80,
              color: AppColors.colorFAB,
            ),
            const SizedBox(height: 24),
            const Text(
              'Загрузите выписку',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Поддерживаются форматы CSV, XLSX, PDF',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),
            if (state.filePath != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderDivider),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.description, color: AppColors.colorFAB),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            state.fileName ?? '',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${((state.fileSizeBytes ?? 0) / 1024).toStringAsFixed(0)} КБ · ${state.fileFormat?.toUpperCase() ?? ''}',
                            style: const TextStyle(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: notifier.pickFile,
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),
              )
            else
              FilledButton.icon(
                onPressed: notifier.pickFile,
                icon: const Icon(Icons.file_open),
                label: const Text('Выбрать файл'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.colorFAB,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}