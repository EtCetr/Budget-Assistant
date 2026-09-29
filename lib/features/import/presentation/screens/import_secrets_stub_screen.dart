import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import 'package:budget_assistant/features/import/domain/entities/import_secrecy_handoff.dart';

// TODO(Этап 15.5): заменить на полный ImportSecretsScreen (календарь + кандидаты).
class ImportSecretsStubScreen extends StatelessWidget {
  const ImportSecretsStubScreen({super.key, this.handoff});

  final ImportSecrecyHandoff? handoff;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        title: const Text('Режим секретности'),
        backgroundColor: AppColors.surfaceBackground,
      ),
      body: EmptyStateWidget(
        icon: Icons.card_giftcard_outlined,
        title: 'Найдены кандидаты в подарки',
        subtitle: handoff == null
            ? 'Нет данных'
            : '${handoff!.candidates.length} транзакций в период секретности. '
                'Экран управления появится в Этапе 15.5',
        primaryAction: EmptyStateAction(
          label: 'Перейти к транзакциям',
          onPressed: () => context.go('/transactions'),
        ),
      ),
    );
  }
}