import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/formatting/money_input_parser.dart';
import 'package:budget_assistant/core/formatting/money_text_input_formatter.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/providers/database_providers.dart';
import 'package:budget_assistant/core/providers/security_providers.dart' as sec;
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/admin/presentation/providers/admin_providers.dart';
import 'package:budget_assistant/features/admin/presentation/providers/space_settings_providers.dart';
import 'package:budget_assistant/features/admin/presentation/widgets/dissolve_word_dialog.dart';
import 'package:budget_assistant/features/admin/presentation/widgets/edit_space_identity_sheet.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import 'package:budget_assistant/features/spaces/presentation/providers/space_providers.dart';

/// Настройки пространства (ТЗ 6.3.36): identity, статистика 2x2,
/// семейный лимит, опасная зона (экспорт XLSX + расформирование).
class SpaceSettingsScreen extends ConsumerWidget {
  const SpaceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = ref.watch(adminScopeProvider);
    if (scope == null) {
      return const Scaffold(body: Center(child: Text('Нет активного пространства')));
    }
    final access = ref.watch(adminAccessProvider(scope));
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(title: const Text('Настройки пространства')),
      body: access.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text('Ошибка доступа: $e',
              style: const TextStyle(color: AppColors.textPrimary)),
        ),
        data: (isAdmin) => isAdmin
            ? _content(context, ref, scope)
            : const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.spacing16),
                  child: Text(
                    'Раздел доступен только администраторам пространства',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                ),
              ),
      ),
    );
  }

  Widget _content(BuildContext context, WidgetRef ref, AdminScope scope) {
    final row = ref.watch(spaceSettingsRowProvider);
    final stats = ref.watch(spaceStatsRowProvider);
    final mode = ref.watch(privacyModeProvider);
    final hidden = mode == BalanceVisibilityMode.hidden;
    final pf = ref.watch(privacyFormatterProvider);
    return row.when(
      loading: () => ListView(
        padding: const EdgeInsets.all(AppSpacing.spacing16),
        children: List.generate(
          3,
          (_) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.spacing12),
            child: SkeletonShimmer.card(),
          ),
        ),
      ),
      error: (e, _) => Center(
        child: Text('Ошибка: $e', style: const TextStyle(color: AppColors.textPrimary)),
      ),
      data: (space) {
        if (space == null) {
          return const Center(
            child: Text('Пространство не найдено',
                style: TextStyle(color: AppColors.textPrimary)),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          children: [
            _identityCard(context, ref, scope, space, pf, mode),
            const SizedBox(height: AppSpacing.spacing16),
            const Text('📊 Статистика (read-only)',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: AppSpacing.spacing8),
            stats.when(
              loading: () => SkeletonShimmer.card(),
              error: (e, _) => Text('Ошибка: $e',
                  style: const TextStyle(color: AppColors.textPrimary)),
              data: (st) => _statsGrid(st, pf, mode, ref.watch(membersStreamProvider(scope.spaceId)).value?.length ?? 0),
            ),
            const SizedBox(height: AppSpacing.spacing16),
            _budgetSection(context, ref, scope, space),
            const SizedBox(height: AppSpacing.spacing16),
            _dangerZone(context, ref, scope, space, hidden),
          ],
        );
      },
    );
  }

  Widget _identityCard(
    BuildContext context,
    WidgetRef ref,
    AdminScope scope,
    dynamic space,
    dynamic pf,
    BalanceVisibilityMode mode,
  ) {
    final emoji = (space.iconEmoji as String?) ?? '👨‍👩‍👧';
    final colorHex = (space.iconColor as String?) ?? '#FFF97316';
    final color = _parseColor(colorHex);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing24),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.radiusLg)),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: color,
                child: Text(emoji, style: const TextStyle(fontSize: 48)),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _openIdentity(context, ref, scope, space);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: AppColors.colorFAB,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.edit, size: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacing12),
          Text(
            pf.formatSpaceName(space.name as String?, mode),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              _openIdentity(context, ref, scope, space);
            },
            child: const Text('✏️ Изменить',
                style: TextStyle(color: AppColors.colorTransfer)),
          ),
          Text(
            'Создано: ${DateFormat('dd.MM.yyyy').format((space.createdAt as DateTime).toLocal())} · '
            'ID: ${(space.id as String).length > 8 ? (space.id as String).substring(0, 8) : space.id}…',
            style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String hex) {
    try {
      final v = int.parse(hex.replaceAll('#', ''), radix: 16);
      return Color(v);
    } catch (_) {
      return AppColors.colorFAB;
    }
  }

  Future<void> _openIdentity(
    BuildContext context,
    WidgetRef ref,
    AdminScope scope,
    dynamic space,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    await showEditSpaceIdentitySheet(
      context,
      initialName: space.name as String,
      initialEmoji: (space.iconEmoji as String?) ?? '👨‍👩‍👧',
      initialColor: (space.iconColor as String?) ?? '#FFF97316',
      onSave: (name, emoji, color) => ref
          .read(updateSpaceIdentityUseCaseProvider)
          .call(
            spaceId: scope.spaceId,
            actorId: scope.userId,
            newName: name,
            newIconEmoji: emoji,
            newIconColor: color,
            oldName: space.name as String,
          ),
    );
    messenger.showSnackBar(
      const SnackBar(content: Text('✅ Настройки пространства сохранены')),
    );
  }

  Widget _statsGrid(dynamic st, dynamic pf, BalanceVisibilityMode mode, int membersCount) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.6,
      mainAxisSpacing: AppSpacing.spacing12,
      crossAxisSpacing: AppSpacing.spacing12,
      children: [
        _statCard('👥', 'Участников', '$membersCount', AppColors.colorTransfer),
        _statCard('💳', 'Счетов', '${st.accountsCount}', AppColors.colorIncome),
        _statCard('📋', 'Транзакций', '${st.transactionsCount}', AppColors.textSecondary),
        _statCard(
          '💰',
          'Общий баланс',
          pf.formatAmount(st.familyBalanceKopecks, 'RUB', mode),
          AppColors.colorIncome,
        ),
      ],
    );
  }

  Widget _statCard(String icon, String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('$icon $title',
              style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _budgetSection(
    BuildContext context,
    WidgetRef ref,
    AdminScope scope,
    dynamic space,
  ) {
    return _SpaceBudgetSection(
      initialLimit: space.monthlyBudgetLimit as int?,
      onSave: (limit) => ref.read(updateSpaceBudgetLimitUseCaseProvider).call(
            spaceId: scope.spaceId,
            actorId: scope.userId,
            limitKopecks: limit,
            oldLimitKopecks: space.monthlyBudgetLimit as int?,
          ),
    );
  }

  Widget _dangerZone(
    BuildContext context,
    WidgetRef ref,
    AdminScope scope,
    dynamic space,
    bool hidden,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('⚠️ Опасная зона',
            style: TextStyle(
                color: AppColors.colorExpense,
                fontSize: 16,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        const Text('💡 Эти действия необратимы',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        const SizedBox(height: AppSpacing.spacing8),
        Opacity(
          opacity: hidden ? 0.5 : 1,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius:
                  const BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
              border: Border.all(
                  color: AppColors.colorTransfer.withValues(alpha: 0.3)),
            ),
            child: ListTile(
              leading: const Icon(Icons.upload_outlined,
                  color: AppColors.colorTransfer),
              title: const Text('Экспорт всех данных пространства',
                  style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600)),
              subtitle: const Text('XLSX со всеми транзакциями, счетами, целями, долгами',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              onTap: hidden
                  ? null
                  : () => _exportFlow(context, ref, scope, space),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.spacing12),
        Opacity(
          opacity: hidden ? 0.5 : 1,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surfaceElevated,
              borderRadius:
                  const BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
              border: Border.all(
                  color: AppColors.colorExpense.withValues(alpha: 0.3)),
            ),
            child: ListTile(
              leading:
                  const Icon(Icons.delete_forever, color: AppColors.colorExpense),
              title: const Text('Расформировать пространство',
                  style: TextStyle(
                      color: AppColors.colorExpense,
                      fontWeight: FontWeight.w600)),
              subtitle: const Text('Необратимое действие. Все участники потеряют доступ',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              onTap: hidden ? null : () => _dissolveFlow(context, ref, scope),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _exportFlow(
    BuildContext context,
    WidgetRef ref,
    AdminScope scope,
    dynamic space,
  ) async {
    HapticFeedback.lightImpact();
    final messenger = ScaffoldMessenger.of(context);
    try {
      final settings =
          await ref.read(appSettingsDaoProvider).getForUser(scope.userId);
      if (!context.mounted) return;
      if (settings.enablePinCode) {
        final ok = await context.push<bool>('/security/pin-entry?mode=verify');
        if (!context.mounted) return;
        if (ok != true) return;
      }
      final confirm = await showDialog<bool>(
        context: context,
        builder: (d) => AlertDialog(
          backgroundColor: AppColors.surfaceCard,
          title: const Text('⚠️ Экспортировать все данные?',
              style: TextStyle(color: AppColors.textPrimary)),
          content: const Text(
            'Будут экспортированы: все транзакции, счета, цели и долги. '
            'Файл содержит персональные данные всех членов семьи. '
            'Отправляйте его только доверенным лицам.',
            style: TextStyle(color: AppColors.textSecondary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(d).pop(false),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(d).pop(true),
              child: const Text('Экспортировать'),
            ),
          ],
        ),
      );
      if (confirm != true || !context.mounted) return;
      final path = await ref.read(exportSpaceDataUseCaseProvider).call(
            spaceId: scope.spaceId,
            actorId: scope.userId,
            spaceName: space.name as String,
          );
      if (!context.mounted) return;
      final choice = await showDialog<String>(
        context: context,
        builder: (d) => AlertDialog(
          backgroundColor: AppColors.surfaceCard,
          title: const Text('Экспорт готов',
              style: TextStyle(color: AppColors.textPrimary)),
          content: const Text('Куда сохранить файл пространства?',
              style: TextStyle(color: AppColors.textSecondary)),
          actions: [
            FilledButton.icon(
              icon: const Icon(Icons.save_outlined),
              label: const Text('Сохранить'),
              onPressed: () => Navigator.of(d).pop('save'),
            ),
            FilledButton.icon(
              icon: const Icon(Icons.share),
              label: const Text('Поделиться'),
              onPressed: () => Navigator.of(d).pop('share'),
            ),
            TextButton(
              onPressed: () => Navigator.of(d).pop(),
              child: const Text('Отмена'),
            ),
          ],
        ),
      );
      if (choice == 'save') {
        final file = File(path);
        final bytes = await file.readAsBytes();
        const channel = MethodChannel('budget_assistant/clock');
        final uri = await channel.invokeMethod<String>(
          'saveToDownloads',
          {
            'fileName': file.uri.pathSegments.last,
            'bytes': bytes,
            'mime': 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
          },
        );
        messenger.showSnackBar(
          SnackBar(content: Text('✅ Сохранено: ${uri ?? 'Downloads/BudgetAssistant'}')),
        );
      } else if (choice == 'share') {
        await SharePlus.instance.share(
          ShareParams(files: [XFile(path)], text: '📊 Экспорт данных пространства'),
        );
        messenger.showSnackBar(
          const SnackBar(content: Text('✅ Экспорт отправлен')),
        );
      }
      if (choice != null) HapticFeedback.mediumImpact();
    } catch (e, st) {
      AppLogger.e('Space export flow failed', e, st);
      HapticFeedback.vibrate();
      messenger.showSnackBar(
        const SnackBar(content: Text('❌ Не удалось экспортировать данные')),
      );
    }
  }

  Future<void> _dissolveFlow(
    BuildContext context,
    WidgetRef ref,
    AdminScope scope,
  ) async {
    HapticFeedback.lightImpact();
    final messenger = ScaffoldMessenger.of(context);
    final ok1 = await showDialog<bool>(
      context: context,
      builder: (d) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: const Text('🔴 Расформировать пространство?',
            style: TextStyle(color: AppColors.textPrimary)),
        content: const Text(
          'Это действие НЕОБРАТИМО. Что произойдёт:\n'
          '• Пространство будет удалено\n'
          '• Все участники потеряют доступ к общим данным\n'
          '• Общие транзакции, цели и долги останутся в истории каждого участника\n'
          '• Семейный бюджет будет отменён\n'
          '• Приглашения будут отозваны\n\n'
          'Личные данные каждого участника останутся нетронутыми.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(d).pop(false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.colorExpense),
            onPressed: () => Navigator.of(d).pop(true),
            child: const Text('Продолжить'),
          ),
        ],
      ),
    );
    if (ok1 != true || !context.mounted) return;
    HapticFeedback.mediumImpact();
    final settings =
        await ref.read(appSettingsDaoProvider).getForUser(scope.userId);
    if (!context.mounted) return;
    if (settings.enablePinCode) {
      final pinOk = await context.push<bool>('/security/pin-entry?mode=verify');
      if (!context.mounted) return;
      if (pinOk != true) return;
    }
    final ok2 = await showDialog<bool>(
      context: context,
      builder: (_) => const DissolveWordDialog(),
    );
    if (ok2 != true || !context.mounted) return;
    try {
      await ref.read(dissolveSpaceUseCaseProvider).call(
            spaceId: scope.spaceId,
            actorId: scope.userId,
          );
      ref.read(currentSpaceIdProvider.notifier).setSpaceId(null);
      ref.read(sec.currentSpaceIdProvider.notifier).set(null);
      ref.invalidate(userSpacesProvider);
      HapticFeedback.heavyImpact();
      if (!context.mounted) return;
      context.go('/');
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Пространство расформировано'),
          duration: Duration(seconds: 5),
        ),
      );
    } catch (e, st) {
      AppLogger.e('Dissolve flow failed', e, st);
      HapticFeedback.vibrate();
      messenger.showSnackBar(
        SnackBar(content: Text('❌ Ошибка расформирования: $e')),
      );
    }
  }
}

/// Секция семейного лимита (6.3.36.5/6): тумблер + поле суммы с валидацией.
class _SpaceBudgetSection extends StatefulWidget {
  const _SpaceBudgetSection({required this.initialLimit, required this.onSave});
  final int? initialLimit;
  final Future<void> Function(int? limitKopecks) onSave;
  @override
  State<_SpaceBudgetSection> createState() => _SpaceBudgetSectionState();
}

class _SpaceBudgetSectionState extends State<_SpaceBudgetSection> {
  late bool _enabled = widget.initialLimit != null;
  late final TextEditingController _controller = TextEditingController(
    text: widget.initialLimit == null
        ? ''
        : MoneyTextInputFormatter.formatKopecks(widget.initialLimit!),
  );
  bool _busy = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _toggle(bool value) async {
    HapticFeedback.selectionClick();
    setState(() => _enabled = value);
    if (!value) {
      await _save(null);
    }
  }

  Future<void> _save(int? limit) async {
    setState(() => _busy = true);
    try {
      await widget.onSave(limit);
      if (mounted) {
        HapticFeedback.mediumImpact();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Семейный бюджет сохранён')),
        );
      }
    } catch (e) {
      if (mounted) {
        HapticFeedback.vibrate();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _saveFromField() async {
    final kopecks = MoneyInputParser.parseKopecks(_controller.text);
    if (kopecks == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Введите сумму лимита')),
      );
      return;
    }
    await _save(kopecks);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(AppRadius.radiusLg)),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💰 Семейный бюджет',
              style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text('💡 Общий лимит расходов на месяц для всех участников',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: _enabled,
            onChanged: _busy ? null : _toggle,
            title: const Text('Месячный лимит',
                style: TextStyle(color: AppColors.textPrimary)),
          ),
          if (_enabled) ...[
            TextField(
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [MoneyTextInputFormatter()],
              decoration: const InputDecoration(
                hintText: 'Например, 150 000',
                filled: true,
                fillColor: AppColors.surfaceElevated,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.spacing8),
            const Text(
              '💡 При достижении 80% лимита участники получат пуш. При 100% — пуш «Семейный бюджет исчерпан»',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
            ),
            const SizedBox(height: AppSpacing.spacing8),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: _busy ? null : _saveFromField,
                child: const Text('Сохранить лимит'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}