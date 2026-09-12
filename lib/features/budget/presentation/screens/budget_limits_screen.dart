import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../providers/budget_providers.dart';
import '../widgets/monthly_pnl_summary_card.dart';
import '../widgets/budget_limit_card.dart';

class BudgetLimitsScreen extends ConsumerWidget {
  const BudgetLimitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final limitsAsync = ref.watch(budgetLimitsForCurrentMonthProvider);
    final pnlAsync = ref.watch(monthlyPnlForCurrentMonthProvider);
    final privacyMode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Бюджет и лимиты'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(budgetLimitsForCurrentMonthProvider);
          ref.invalidate(monthlyPnlForCurrentMonthProvider);
        },
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: pnlAsync.when(
                data: (pnl) => MonthlyPnlSummaryCard(
                  pnl: pnl,
                  privacyMode: privacyMode,
                  formatter: formatter,
                ),
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('Ошибка загрузки: $e'),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Лимиты по категориям',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            limitsAsync.when(
              data: (limits) {
                if (limits.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Нет установленных лимитов',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Нажмите + чтобы создать лимит',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final limit = limits[index];
                      return BudgetLimitCard(
                        limit: limit,
                        privacyMode: privacyMode,
                        formatter: formatter,
                        onTap: () {
                          context.push('/budget/edit/${limit.id}');
                        },
                      );
                    },
                    childCount: limits.length,
                  ),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverFillRemaining(
                child: Center(child: Text('Ошибка: $e')),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push('/budget/create');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}