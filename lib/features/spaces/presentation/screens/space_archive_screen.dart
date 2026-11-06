// lib/features/spaces/presentation/screens/space_archive_screen.dart
// Этап 21 (ТЗ 6.3.52): read-only архив расформированного пространства.
// Никаких действий (редактирование/удаление) недоступно.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import 'package:budget_assistant/features/spaces/presentation/providers/space_archive_providers.dart';
import 'package:budget_assistant/features/spaces/presentation/widgets/space_archive_tabs.dart';
import 'package:budget_assistant/features/spaces/presentation/widgets/space_info_banner.dart';

class SpaceArchiveScreen extends ConsumerStatefulWidget {
  const SpaceArchiveScreen({super.key, required this.spaceId});

  final String spaceId;

  @override
  ConsumerState<SpaceArchiveScreen> createState() =>
      _SpaceArchiveScreenState();
}

class _SpaceArchiveScreenState extends ConsumerState<SpaceArchiveScreen> {
  SpaceArchiveTab _tab = SpaceArchiveTab.accounts;

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final infoAsync = ref.watch(spaceArchiveInfoProvider(widget.spaceId));
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceBackground,
        title: const Text('Архив пространства'),
      ),
      body: infoAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => const Center(
          child: Text(
            'Не удалось загрузить архив',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        data: (info) {
          if (info == null) {
            return const Center(
              child: Text(
                'Пространство не найдено',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              SpaceInfoBanner(info: info, mode: mode, formatter: formatter),
              const SizedBox(height: 16),
              _statsGrid(info.currencyCode),
              const SizedBox(height: 16),
              SpaceArchiveTabs(
                current: _tab,
                onChanged: (t) {
                  HapticFeedback.selectionClick();
                  setState(() => _tab = t);
                },
              ),
              const SizedBox(height: 16),
              _tabContent(formatter, mode),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _statsGrid(String currencyCode) {
    final statsAsync = ref.watch(spaceArchiveStatsProvider(widget.spaceId));
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    return statsAsync.when(
      loading: () => const SizedBox(
        height: 96,
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, st) => const SizedBox.shrink(),
      data: (s) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: AppColors.borderDivider),
        ),
        child: Row(
          children: [
            Expanded(child: _stat('💳', 'Счетов:', '${s.accountsCount}')),
            Expanded(
              child: _stat('📋', 'Транзакций:', '${s.transactionsCount}'),
            ),
            Expanded(child: _stat('🎯', 'Целей:', '${s.goalsCount}')),
            Expanded(
              child: _stat(
                '💰',
                'Баланс:',
                formatter.formatAmount(s.totalBalanceKopecks, currencyCode, mode),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String icon, String label, String value) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _tabContent(PrivacyFormatter formatter, BalanceVisibilityMode mode) {
    final df = DateFormat('dd.MM.yyyy');
    switch (_tab) {
      case SpaceArchiveTab.accounts:
        final async = ref.watch(spaceArchiveAccountsProvider(widget.spaceId));
        return async.when(
          loading: () => const _ArchiveLoading(),
          error: (e, st) => _archiveEmpty('Не удалось загрузить счета'),
          data: (rows) => rows.isEmpty
              ? _archiveEmpty('Счетов в архиве нет')
              : Column(
                  children: [
                    for (final a in rows) _accountRow(a, formatter, mode),
                  ],
                ),
        );
      case SpaceArchiveTab.transactions:
        final async =
            ref.watch(spaceArchiveTransactionsProvider(widget.spaceId));
        return async.when(
          loading: () => const _ArchiveLoading(),
          error: (e, st) => _archiveEmpty('Не удалось загрузить транзакции'),
          data: (rows) => rows.isEmpty
              ? _archiveEmpty('Транзакций в архиве нет')
              : Column(
                  children: [
                    for (final t in rows) _txRow(t, df, formatter, mode),
                  ],
                ),
        );
      case SpaceArchiveTab.goals:
        final async = ref.watch(spaceArchiveGoalsProvider(widget.spaceId));
        return async.when(
          loading: () => const _ArchiveLoading(),
          error: (e, st) => _archiveEmpty('Не удалось загрузить цели'),
          data: (rows) => rows.isEmpty
              ? _archiveEmpty('Целей в архиве нет')
              : Column(
                  children: [
                    for (final g in rows) _goalRow(g, formatter, mode),
                  ],
                ),
        );
      case SpaceArchiveTab.debts:
        final async = ref.watch(spaceArchiveDebtsProvider(widget.spaceId));
        return async.when(
          loading: () => const _ArchiveLoading(),
          error: (e, st) => _archiveEmpty('Не удалось загрузить долги'),
          data: (rows) => rows.isEmpty
              ? _archiveEmpty('Долгов в архиве нет')
              : Column(
                  children: [
                    for (final d in rows) _debtRow(d, formatter, mode),
                  ],
                ),
        );
    }
  }

  Widget _accountRow(
    Account a,
    PrivacyFormatter formatter,
    BalanceVisibilityMode mode,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Row(
        children: [
          const Icon(Icons.credit_card_outlined, color: AppColors.colorTransfer),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  a.customName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  a.bankName,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            formatter.formatAmount(a.currentBalance, a.currency, mode),
            style: const TextStyle(
              color: AppColors.colorIncome,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _txRow(
    TransactionDb t,
    DateFormat df,
    PrivacyFormatter formatter,
    BalanceVisibilityMode mode,
  ) {
    // D21-26: валюта транзакции = original_currency ?? RUB.
    final currency = t.originalCurrency ?? 'RUB';
    final color = switch (t.type) {
      TransactionType.expense => AppColors.colorExpense,
      TransactionType.income => AppColors.colorIncome,
      _ => AppColors.colorTransfer,
    };
    final title = formatter.formatMerchant(t.merchantName, mode);
    final subtitle = formatter.formatComment(t.comment, mode);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.isEmpty ? t.type.name : title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${df.format(t.date.toLocal())}'
                  '${subtitle.isEmpty ? '' : ' · $subtitle'}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            formatter.formatAmount(t.amount, currency, mode),
            style: TextStyle(color: color, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _goalRow(
    SavingsGoalDb g,
    PrivacyFormatter formatter,
    BalanceVisibilityMode mode,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Row(
        children: [
          const Icon(Icons.savings_outlined, color: AppColors.colorFAB),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatter.formatName(g.name, mode),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Накоплено ${formatter.formatAmount(g.currentAmount, g.currency, mode)}'
                  ' из ${formatter.formatAmount(g.targetAmount, g.currency, mode)}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            g.status,
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _debtRow(
    DebtDb d,
    PrivacyFormatter formatter,
    BalanceVisibilityMode mode,
  ) {
    final title = d.description != null
        ? formatter.formatComment(d.description, mode)
        : (d.counterpartyNameDative != null
            ? formatter.formatName(d.counterpartyNameDative, mode)
            : 'Долг');
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Row(
        children: [
          const Icon(Icons.handshake_outlined, color: AppColors.colorWarning),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  d.resolutionStatus,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            formatter.formatAmount(d.amount, d.currency, mode),
            style: const TextStyle(
              color: AppColors.colorExpense,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _archiveEmpty(String text) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 40,
            color: AppColors.textSecondary,
          ),
          const SizedBox(height: 8),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _ArchiveLoading extends StatelessWidget {
  const _ArchiveLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}