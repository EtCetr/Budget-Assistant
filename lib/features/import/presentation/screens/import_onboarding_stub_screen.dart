import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:budget_assistant/core/theme/app_spacing.dart';

/// TODO(Этап 15): заменить на полный ImportOnboardingScreen (мастер 4 шага).
class ImportOnboardingStubScreen extends StatelessWidget {
  const ImportOnboardingStubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Импорт выписки')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spacing32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.file_upload_outlined, size: 72),
              const SizedBox(height: 16),
              Text(
                'Импорт CSV/XLSX/PDF появится на Этапе 15',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'А пока можно добавлять транзакции вручную через FAB',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Назад'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
