import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/providers/security_providers.dart';
import '../../../../core/widgets/pending_sync_indicator.dart';
import '../../../../core/widgets/skeleton_shimmer.dart';
import '../../../../core/errors/result.dart';
import '../../../auth/presentation/providers/current_user_provider.dart';
import '../../../privacy/domain/models/balance_visibility_mode.dart';
import '../../../spaces/domain/entities/user_space.dart';
import '../../../spaces/presentation/providers/space_providers.dart';
import '../../../spaces/presentation/widgets/create_space_dialog.dart';
import '../../domain/entities/transactions_filter_state.dart';
import '../labels/transactions_log_labels.dart';
import '../providers/transactions_log_providers.dart';
import '../widgets/fab_create_menu.dart';
import '../widgets/transactions_empty_state.dart';
import '../widgets/transactions_filter_chip_group.dart';
import '../widgets/transactions_list.dart';
import '../widgets/transactions_segmented_control.dart';

class TransactionsLogScreen extends ConsumerWidget {
  const TransactionsLogScreen({super.key});

  /// Активная группа: текущая, если она валидна, иначе первая из списка.
  UserSpace? _effectiveSpace(List<UserSpace> spaces, String? currentSpaceId) {
    if (spaces.isEmpty) return null;
    for (final space in spaces) {
      if (space.id == currentSpaceId) return space;
    }
    return spaces.first;
  }

  String _spaceName(List<UserSpace> spaces, String spaceId) {
    for (final space in spaces) {
      if (space.id == spaceId) return space.name;
    }
    return '';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final logState = ref.watch(transactionsLogProvider);
    final filter = ref.watch(transactionsFilterProvider);
    final hasPendingAsync = ref.watch(hasPendingSyncProvider);
    final hasPending = hasPendingAsync.value ?? false;
    final privacyMode = ref.watch(privacyModeProvider);
    final spaces = ref.watch(userSpacesProvider).value ?? const <UserSpace>[];
    final currentSpaceId = ref.watch(currentSpaceIdProvider);
    final effectiveSpace = _effectiveSpace(spaces, currentSpaceId);
    final familyLabel =
        effectiveSpace?.name ?? TransactionsLogLabels.scopeFamily;

    // Авто-выбор активной группы при входе в семейный контекст:
    // currentSpaceId может быть null или указывать на расформированную группу.
    if (effectiveSpace != null && effectiveSpace.id != currentSpaceId) {
      Future.microtask(
        () => ref.read(currentSpaceIdProvider.notifier).set(effectiveSpace.id),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(TransactionsLogLabels.title),
        actions: [
          if (hasPending)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Center(child: PendingSyncIndicator()),
            ),
          IconButton(
            tooltip: 'Search',
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchSheet(context, ref),
          ),
          GestureDetector(
            onTap: () => _togglePrivacyQuick(ref, privacyMode),
            onLongPress: () => _showPrivacySheet(context, ref),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Icon(
                privacyMode == BalanceVisibilityMode.hidden
                    ? Icons.visibility_off
                    : Icons.visibility,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (spaces.length > 1)
            _buildSpaceSelector(ref, spaces, effectiveSpace),
          TransactionsSegmentedControl(
            scope: filter.scope,
            familyLabel: familyLabel,
            onChanged: (scope) {
              HapticFeedback.selectionClick();
              ref.read(transactionsFilterProvider.notifier).setScope(scope);
            },
          ),
          TransactionsFilterChipGroup(filter: filter),
          Expanded(child: _buildBody(context, ref, logState, filter)),
        ],
      ),
      floatingActionButton: const FabCreateMenu(),
    );
  }

  /// Селектор группы сверху — только если пользователь состоит в 2+ группах.
  Widget _buildSpaceSelector(
    WidgetRef ref,
    List<UserSpace> spaces,
    UserSpace? effectiveSpace,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: DropdownButtonFormField<String>(
        initialValue: effectiveSpace?.id,
        decoration: const InputDecoration(
          labelText: 'Группа',
          border: OutlineInputBorder(),
        ),
        items: [
          for (final space in spaces)
            DropdownMenuItem(value: space.id, child: Text(space.name)),
        ],
        onChanged: (value) {
          if (value != null) {
            HapticFeedback.selectionClick();
            ref.read(currentSpaceIdProvider.notifier).set(value);
          }
        },
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    TransactionsLogState state,
    TransactionsFilterState filter,
  ) {
    return RefreshIndicator(
      color: AppColors.colorFAB,
      backgroundColor: AppColors.surfaceCard,
      onRefresh: () => _onRefresh(context, ref),
      child: state.groups.when(
        loading: () => const TransactionsLogSkeleton(),
        error: (error, stack) {
          return TransactionsEmptyState.error(
            onRetry: () => ref.invalidate(transactionsLogProvider),
          );
        },
        data: (groups) {
          if (groups.isEmpty) {
            final spaces =
                ref.watch(userSpacesProvider).value ?? const <UserSpace>[];
            final currentSpaceId = ref.watch(currentSpaceIdProvider);
            // Групп нет вообще — предлагаем создать.
            if (filter.scope == TransactionsScope.family && spaces.isEmpty) {
              return TransactionsEmptyState.noFamilyGroup(
                onCreateGroup: () => CreateSpaceDialog.show(context),
              );
            }
            // Группа есть, но семейных операций нет — предлагаем
            // подключить личные транзакции (вариант A).
            if (filter.scope == TransactionsScope.family &&
                spaces.isNotEmpty &&
                currentSpaceId != null &&
                !filter.hasActiveFilters) {
              return TransactionsEmptyState.noFamilyTransactions(
                onAttach: () => _confirmAttachPersonal(
                  context,
                  ref,
                  currentSpaceId,
                  _spaceName(spaces, currentSpaceId),
                ),
              );
            }
            if (filter.hasActiveFilters) {
              return TransactionsEmptyState.filtered(
                onReset: () {
                  HapticFeedback.mediumImpact();
                  ref.read(transactionsFilterProvider.notifier).reset();
                },
              );
            }
            return TransactionsEmptyState.noData(
              onAdd: () => showFabCreateMenu(context),
              onImport: () => context.push('/import/onboarding'),
            );
          }
          return TransactionsList(
            groups: groups,
            hasMore: state.hasMore,
            isLoadingMore: state.isLoadingMore,
            onLoadMore: () =>
                ref.read(transactionsLogProvider.notifier).loadMore(),
          );
        },
      ),
    );
  }

  /// Диалог подтверждения подключения личных транзакций к группе.
  Future<void> _confirmAttachPersonal(
    BuildContext context,
    WidgetRef ref,
    String spaceId,
    String spaceName,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Подключить личные транзакции?'),
        content: Text(
          'Все ваши личные транзакции будут привязаны к группе '
          '${spaceName.isEmpty ? '' : '«$spaceName» '}и станут видны её '
          'участникам. Новые операции будут создаваться сразу в группе.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('Подключить'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      final userId = ref.read(currentUserIdProvider);
      final result = await ref.read(attachPersonalTransactionsUseCaseProvider)(
        userId: userId,
        spaceId: spaceId,
      );
      if (!context.mounted) return;
      switch (result) {
        case Success(:final value):
          HapticFeedback.mediumImpact();
          ref.invalidate(transactionsLogProvider);
          ref.invalidate(hasPendingSyncProvider);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Подключено транзакций: $value')),
          );
        case Error(:final failure):
          HapticFeedback.vibrate();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ошибка: ${failure.message}')),
          );
      }
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось подключить транзакции')),
      );
    }
  }

  Future<void> _onRefresh(BuildContext context, WidgetRef ref) async {
    HapticFeedback.lightImpact();
    try {
      final syncedCount = await ref.read(syncServiceProvider).forceSyncNow();
      ref.invalidate(transactionsLogProvider);
      ref.invalidate(hasPendingSyncProvider);
      if (!context.mounted) return;
      HapticFeedback.mediumImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${TransactionsLogLabels.syncSuccess}: $syncedCount'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      HapticFeedback.vibrate();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(TransactionsLogLabels.syncError)),
      );
    }
  }

  void _togglePrivacyQuick(WidgetRef ref, BalanceVisibilityMode current) {
    HapticFeedback.lightImpact();
    final next = current == BalanceVisibilityMode.visible
        ? BalanceVisibilityMode.partial
        : BalanceVisibilityMode.visible;
    ref.read(privacyModeProvider.notifier).setMode(next);
  }

  void _showSearchSheet(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController(
      text: ref.read(transactionsFilterProvider).search,
    );
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: TransactionsLogLabels.searchHint,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(sheetContext).pop(),
                      child: const Text(TransactionsLogLabels.cancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        HapticFeedback.selectionClick();
                        ref
                            .read(transactionsFilterProvider.notifier)
                            .setSearch(controller.text);
                        Navigator.of(sheetContext).pop();
                      },
                      child: const Text(TransactionsLogLabels.apply),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showPrivacySheet(BuildContext context, WidgetRef ref) {
    final current = ref.read(privacyModeProvider);
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                selected: current == BalanceVisibilityMode.visible,
                leading: const Icon(Icons.visibility),
                title: const Text(TransactionsLogLabels.visible),
                onTap: () {
                  ref
                      .read(privacyModeProvider.notifier)
                      .setMode(BalanceVisibilityMode.visible);
                  Navigator.of(sheetContext).pop();
                },
              ),
              ListTile(
                selected: current == BalanceVisibilityMode.partial,
                leading: const Icon(Icons.visibility_outlined),
                title: const Text(TransactionsLogLabels.partial),
                onTap: () {
                  ref
                      .read(privacyModeProvider.notifier)
                      .setMode(BalanceVisibilityMode.partial);
                  Navigator.of(sheetContext).pop();
                },
              ),
              ListTile(
                selected: current == BalanceVisibilityMode.hidden,
                leading: const Icon(Icons.visibility_off),
                title: const Text(TransactionsLogLabels.hidden),
                onTap: () {
                  ref
                      .read(privacyModeProvider.notifier)
                      .setMode(BalanceVisibilityMode.hidden);
                  Navigator.of(sheetContext).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}