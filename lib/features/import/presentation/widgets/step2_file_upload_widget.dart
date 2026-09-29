import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import '../providers/import_onboarding_notifier.dart';

class Step2FileUploadWidget extends ConsumerWidget {
  const Step2FileUploadWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(importOnboardingProvider);
    final notifier = ref.read(importOnboardingProvider.notifier);
    final config = state.selectedConfig;
    final file = state.parsedFile;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (config != null) ...[
          Text('Как выгрузить выписку из ${config.bankName}',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          ...notifier.currentInstructions().asMap().entries.map((e) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${e.key + 1}. ',
                        style: const TextStyle(
                            color: AppColors.textSecondary)),
                    Expanded(
                      child: Text(e.value,
                          style: const TextStyle(
                              color: AppColors.textPrimary)),
                    ),
                  ],
                ),
              )),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: config.supportedFormats.map((f) {
              final selected = state.format == f;
              return ChoiceChip(
                label: Text(f.toUpperCase()),
                selected: selected,
                onSelected: (_) => notifier.setFormat(f),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
        ],
        if (file == null)
          OutlinedButton.icon(
            onPressed: notifier.pickFile,
            icon: const Icon(Icons.upload_file),
            label: const Text('Выбрать файл'),
          )
        else
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderDivider),
            ),
            child: Row(
              children: [
                const Icon(Icons.description_outlined,
                    color: AppColors.colorFAB),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(file.fileName,
                          style: const TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600)),
                      Text(
                        '${(file.fileSizeBytes / 1024).toStringAsFixed(0)} КБ · '
                        'строк: ${file.parseResult.totalRows}',
                        style: const TextStyle(
                            color: AppColors.textSecondary),
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
          ),
      ],
    );
  }
}