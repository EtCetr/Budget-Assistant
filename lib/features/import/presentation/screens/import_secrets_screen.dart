import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import 'package:budget_assistant/features/import/domain/entities/import_secrecy_handoff.dart';
import '../providers/import_secrets_providers.dart';
import '../widgets/secrecy_calendar_widget.dart';
import '../widgets/secrecy_candidate_card.dart';

/// Экран режима секретности после импорта (ТЗ 6.3.27).
class ImportSecretsScreen extends ConsumerStatefulWidget {
  const ImportSecretsScreen({super.key, this.handoff});

  final ImportSecrecyHandoff? handoff;

  @override
  ConsumerState<ImportSecretsScreen> createState() =>
      _ImportSecretsScreenState();
}

class _ImportSecretsScreenState extends ConsumerState<ImportSecretsScreen> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.handoff != null && widget.handoff!.candidates.isNotEmpty) {
      _initialized = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(importSecretsProvider.notifier).init(widget.handoff!);
      });
    }
  }

  Future<void> _apply() async {
    final ok = await ref.read(importSecretsProvider.notifier).apply();
    if (!mounted) return;
    if (ok) {
      MotionTokens.heavy();
      context.go('/transactions');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Подарки скрыты до даты праздника')));
    } else {
      MotionTokens.error();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Не удалось применить режим секретности')));
    }
  }

  void _skip() {
    MotionTokens.light();
    context.go('/transactions');
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(importSecretsProvider);
    final candidates = state.handoff?.candidates ?? const [];

    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceBackground,
        title: const Text('Режим секретности'),
      ),
      body: !_initialized
          ? EmptyStateWidget(
              icon: Icons.card_giftcard_outlined,
              title: 'Кандидатов в подарки нет',
              subtitle: 'Транзакции не попали в периоды секретности',
              primaryAction: EmptyStateAction(
                  label: 'К транзакциям', onPressed: _skip),
            )
          : ListView(
              padding: const EdgeInsets.only(bottom: 16),
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Text(
                      'Импорт попал в период секретности. '
                      'Скрыть подарки от общих отчётов?',
                      style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                ),
                const SecrecyCalendarWidget(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Кандидаты (${candidates.length})',
                      style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700)),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      for (final c in candidates)
                        SecrecyCandidateCard(candidate: c),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _initialized
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    OutlinedButton(onPressed: _skip, child: const Text('Пропустить')),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            backgroundColor: AppColors.colorFAB),
                        onPressed: state.isApplying ? null : _apply,
                        child: Text(
                            'Скрыть выбранные (${state.selectedIds.length})'),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }
}