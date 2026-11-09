// lib/features/profile/presentation/screens/profile_screen.dart
// Этап 21 (ТЗ 6.3.39): полный профиль пользователя.
// Внутри цветных карточек НЕ используем ListTile/SwitchListTile (фикс ассерта);
// DebtsSection — отдельной плиткой (D21-33).
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:budget_assistant/core/providers/transfer_profile_provider.dart';
import 'package:budget_assistant/core/router/app_router.dart' as router;
import 'package:budget_assistant/core/providers/security_providers.dart' as security;
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/admin/presentation/providers/admin_providers.dart';
import 'package:budget_assistant/features/auth/domain/notifiers/auth_notifier.dart';
import 'package:budget_assistant/features/dashboard/presentation/widgets/app_drawer.dart';
import 'package:budget_assistant/features/debts/presentation/widgets/debts_section.dart';
import 'package:budget_assistant/features/import/domain/entities/transfer_profile.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import 'package:budget_assistant/features/profile/presentation/providers/profile_providers.dart';
import 'package:budget_assistant/features/profile/presentation/widgets/edit_profile_sheet.dart';
import 'package:budget_assistant/features/settings/presentation/providers/settings_providers.dart';
import 'package:budget_assistant/features/settings/presentation/providers/spaces_management_providers.dart';
import 'package:budget_assistant/features/settings/presentation/widgets/join_space_dialog.dart';
import 'package:budget_assistant/features/settings/presentation/widgets/leave_space_dialogs.dart';
import 'package:budget_assistant/features/spaces/domain/entities/space_membership_info.dart';
import 'package:budget_assistant/features/spaces/presentation/widgets/create_space_dialog.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transferProfileProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _save(TransferProfile p) =>
      ref.read(transferProfileProvider.notifier).save(p);

  void _snack(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    final first = parts.first[0];
    final second = parts.length > 1 && parts[1].isNotEmpty
        ? parts[1][0]
        : '';
    return (first + second).toUpperCase();
  }

  Future<void> _signOut() async {
    HapticFeedback.lightImpact();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: const Text('🚪 Выйти из аккаунта?'),
        content: const Text(
          'Вы выйдете из аккаунта на этом устройстве. '
          'Все локальные данные останутся и будут доступны после повторного входа.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Выйти'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    HapticFeedback.mediumImpact();
    // D21-31: SecureStorage НЕ чистим (PIN и ключи нужны при повторном входе).
    await ref.read(authProvider.notifier).signOut();
  }

  Future<void> _deleteAccount() async {
    HapticFeedback.lightImpact();
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: const Text('🔴 Удалить аккаунт?'),
        content: const Text(
          'Это действие НЕОБРАТИМО. Будут удалены:\n'
          '• Все ваши транзакции, счета, цели, долги\n'
          '• Все ваши пространства (если вы единственный участник)\n'
          '• Все ваши напоминания, чеки, алиасы товаров\n'
          '• Ваш профиль и аватар\n'
          'Данные других членов семьи останутся нетронутыми.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Продолжить'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    HapticFeedback.mediumImpact();
    final pinOn =
        ref.read(appSettingsRowProvider).value?.enablePinCode ?? false;
    if (pinOn) {
      final pinOk = await context.push('/security/pin-entry?mode=verify');
      if (pinOk != true || !mounted) return;
    }
    final wordController = TextEditingController();
    final proceed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: const Text('🔐 Подтвердите удаление аккаунта'),
        content: TextField(
          controller: wordController,
          decoration: const InputDecoration(
            labelText: 'Для подтверждения введите слово: УДАЛИТЬ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Удалить навсегда'),
          ),
        ],
      ),
    );
    final word = wordController.text.trim().toUpperCase();
    wordController.dispose();
    if (proceed != true || !mounted) return;
    if (word != 'УДАЛИТЬ') {
      _snack('❌ Слово введено неверно');
      return;
    }
    HapticFeedback.heavyImpact();
    try {
      await ref.read(deleteAccountUseCaseProvider).call();
      await ref.read(authProvider.notifier).signOut();
    } catch (e) {
      if (mounted) _snack('❌ Ошибка удаления: $e');
    }
  }

  Future<void> _changePassword() async {
    HapticFeedback.lightImpact();
    final controller = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: const Text('🔑 Сменить пароль'),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'Новый пароль'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Сохранить'),
          ),
        ],
      ),
    );
    final pw = controller.text;
    controller.dispose();
    if (ok != true || !mounted) return;
    if (pw.length < 8) {
      _snack('❌ Минимум 8 символов');
      return;
    }
    try {
      await supabase.Supabase.instance.client.auth.updateUser(
        supabase.UserAttributes(password: pw),
      );
      if (!mounted) return;
      _snack('✅ Пароль обновлён');
    } catch (e) {
      if (mounted) _snack('❌ Ошибка смены пароля: $e');
    }
  }

  void _switchSpace(String spaceId) {
    HapticFeedback.lightImpact();
    ref.read(router.currentSpaceIdProvider.notifier).setSpaceId(spaceId);
    ref.read(security.currentSpaceIdProvider.notifier).set(spaceId);
    context.go('/');
  }

  Future<void> _spaceMenu(SpaceMembershipInfo info) async {
    HapticFeedback.mediumImpact();
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceCard,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (info.isAdmin)
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('⚙️ Настройки пространства'),
                onTap: () {
                  Navigator.pop(ctx);
                  _switchSpace(info.spaceId);
                  context.push('/admin/space-settings');
                },
              ),
            if (info.isAdmin)
              ListTile(
                leading: const Icon(Icons.group_outlined),
                title: const Text('👥 Управление участниками'),
                onTap: () {
                  Navigator.pop(ctx);
                  _switchSpace(info.spaceId);
                  context.push('/admin/members');
                },
              ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                color: AppColors.colorWarning,
              ),
              title: const Text('🚪 Выйти из пространства'),
              onTap: () {
                Navigator.pop(ctx);
                showLeaveSpaceFlow(context, ref, info);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final userAsync = ref.watch(userProfileProvider);
    return Scaffold(
      drawer: const AppDrawer(currentRoute: '/profile'),
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceBackground,
        title: const Text('Профиль'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Настройки',
            onPressed: () {
              HapticFeedback.lightImpact();
              context.push('/settings');
            },
          ),
        ],
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Не удалось загрузить профиль',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(userProfileProvider),
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
        data: (user) {
          if (user == null) {
            return const Center(
              child: Text(
                'Профиль не найден',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _header(user, mode, formatter),
              const SizedBox(height: 16),
              _statsGrid(),
              const SizedBox(height: 16),
              _spacesSection(mode, formatter),
              const SizedBox(height: 16),
              _myStatsSection(),
              const SizedBox(height: 8),
              // Долг Этапа 13 закрыт: секция долгов встроена (D21-33: плиткой).
              const DebtsSection(),
              const SizedBox(height: 8),
              _card('🔔 Уведомления', [
                TextButton.icon(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    context.push('/settings/notifications');
                  },
                  icon: const Icon(
                    Icons.notifications_outlined,
                    color: AppColors.colorTransfer,
                  ),
                  label: const Text(
                    'Настройки уведомлений и дайджестов',
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                ),
              ]),
              if (_isAdmin()) ...[
                const SizedBox(height: 16),
                _card('🛡 Администрирование', [
                  TextButton.icon(
                    onPressed: () => context.push('/admin'),
                    icon: const Icon(
                      Icons.admin_panel_settings,
                      color: AppColors.colorFAB,
                    ),
                    label: const Text(
                      'Управление участниками и настройками',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                  ),
                ]),
              ],
              const SizedBox(height: 16),
              _transferSection(),
              const SizedBox(height: 16),
              _dangerZone(),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  bool _isAdmin() {
    final scope = ref.watch(adminScopeProvider);
    if (scope == null) return false;
    return ref.watch(adminAccessProvider(scope)).value ?? false;
  }

  Widget _header(
    User user,
    BalanceVisibilityMode mode,
    PrivacyFormatter formatter,
  ) {
    final avatarFile = user.avatarPath == null ? null : File(user.avatarPath!);
    final hasAvatar = avatarFile != null && avatarFile.existsSync();
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.colorTransfer,
                backgroundImage: hasAvatar ? FileImage(avatarFile) : null,
                child: hasAvatar
                    ? null
                    : Text(
                        _initials(user.displayName),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
              ),
              Positioned(
                bottom: 0,
                right: -4,
                child: InkWell(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    EditProfileSheet.show(context, user);
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppColors.colorFAB,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            formatter.formatName(user.displayName, mode),
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          TextButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              EditProfileSheet.show(context, user);
            },
            child: const Text(
              '✏️ Изменить имя',
              style: TextStyle(color: AppColors.colorTransfer),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'В дательном падеже: ${formatter.formatName(user.displayNameDative, mode)}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  EditProfileSheet.show(context, user);
                },
                child: const Text(
                  '✏️ Изменить',
                  style: TextStyle(color: AppColors.colorTransfer),
                ),
              ),
            ],
          ),
          const Text(
            '💡 Используется в пушах о долгах',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.email_outlined,
                size: 16,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  formatter.formatEmail(user.email, mode),
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: _changePassword,
            child: const Text(
              'Сменить пароль',
              style: TextStyle(color: AppColors.colorTransfer),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statsGrid() {
    final stats = ref.watch(profileStatsProvider);
    return stats.when(
      loading: () => const SizedBox(
        height: 120,
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
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: _stat('🏠', 'Пространств:', '${s.spacesCount}', AppColors.colorTransfer),
                ),
                Expanded(
                  child: _stat('💳', 'Счетов:', '${s.accountsCount}', AppColors.colorIncome),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _stat('📋', 'Транзакций:', '${s.transactionsCount}', AppColors.textSecondary),
                ),
                Expanded(
                  child: _stat('🎯', 'Целей:', '${s.goalsCount}', AppColors.colorFAB),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String icon, String label, String value, Color color) {
    return Column(
      children: [
        Text(icon, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _spacesSection(
    BalanceVisibilityMode mode,
    PrivacyFormatter formatter,
  ) {
    final spacesAsync = ref.watch(spacesManagementProvider);
    final baseCurrency =
        ref.watch(appSettingsRowProvider).value?.baseCurrency ?? 'RUB';
    return _card('🏠 Мои пространства', [
      spacesAsync.when(
        loading: () => const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
        error: (e, st) => const Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Не удалось загрузить пространства',
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ),
        data: (all) {
          final active = all.where((s) => !s.isDissolved).toList();
          final dissolved = all.where((s) => s.isDissolved).toList();
          return Column(
            children: [
              if (active.isEmpty && dissolved.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'У вас пока нет пространств',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              for (final info in active)
                _spaceCard(info, mode, formatter, baseCurrency),
              for (final info in dissolved)
                _dissolvedCard(info, mode, formatter),
            ],
          );
        },
      ),
      const SizedBox(height: 8),
      OutlinedButton.icon(
        onPressed: () {
          HapticFeedback.lightImpact();
          CreateSpaceDialog.show(context);
        },
        icon: const Icon(Icons.add, color: AppColors.colorIncome),
        label: const Text('Создать новое пространство'),
      ),
      const SizedBox(height: 8),
      OutlinedButton.icon(
        onPressed: () {
          HapticFeedback.lightImpact();
          JoinSpaceDialog.show(context);
        },
        icon: const Icon(Icons.mail_outline, color: AppColors.colorTransfer),
        label: const Text('Присоединиться по приглашению'),
      ),
    ]);
  }

  Widget _spaceCard(
    SpaceMembershipInfo info,
    BalanceVisibilityMode mode,
    PrivacyFormatter formatter,
    String baseCurrency,
  ) {
    final balance = ref.watch(spaceBalanceProvider(info.spaceId)).value;
    return InkWell(
      onTap: () => _switchSpace(info.spaceId),
      onLongPress: () => _spaceMenu(info),
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: AppColors.borderDivider),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(info.iconEmoji ?? '🏠', style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    formatter.formatSpaceName(info.spaceName, mode),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: info.isAdmin
                        ? AppColors.colorWarning.withValues(alpha: 0.2)
                        : AppColors.colorTransfer.withValues(alpha: 0.2),
                    borderRadius: const BorderRadius.all(Radius.circular(6)),
                  ),
                  child: Text(
                    info.isAdmin ? '👑 Админ' : '👤 Участник',
                    style: TextStyle(
                      color: info.isAdmin
                          ? AppColors.colorWarning
                          : AppColors.colorTransfer,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '${info.memberCount} участников'
              '${info.isAdmin && balance != null ? ' · Общий баланс: ${formatter.formatAmount(balance, baseCurrency, mode)}' : ''}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Тап — открыть, long-press — действия',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dissolvedCard(
    SpaceMembershipInfo info,
    BalanceVisibilityMode mode,
    PrivacyFormatter formatter,
  ) {
    return Opacity(
      opacity: 0.5,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: AppColors.borderDivider),
        ),
        child: Row(
          children: [
            const Text('🗑', style: TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                formatter.formatSpaceName(info.spaceName, mode),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            OutlinedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                context.push('/spaces/${info.spaceId}/archive');
              },
              child: const Text('📊 Архив'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _myStatsSection() {
    final badgeYear = ref.watch(yearReviewBadgeYearProvider).value;
    return _card('📊 Моя статистика', [
      Row(
        children: [
          Expanded(
            child: TextButton.icon(
              onPressed: () async {
                HapticFeedback.lightImpact();
                await context.push('/year-in-review');
                ref.invalidate(yearReviewBadgeYearProvider);
              },
              icon: const Icon(
                Icons.assessment_outlined,
                color: AppColors.colorFAB,
              ),
              label: const Text(
                'Моя статистика за год',
                style: TextStyle(color: AppColors.textPrimary),
              ),
            ),
          ),
          if (badgeYear != null)
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: const BoxDecoration(
                color: AppColors.colorIncome,
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              child: const Text(
                '🆕 Новое',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
        ],
      ),
      const Text(
        '💡 Годовые итоги в стиле Spotify Wrapped',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
      const SizedBox(height: 8),
      TextButton.icon(
        onPressed: () {
          HapticFeedback.lightImpact();
          context.push('/product-analytics');
        },
        icon: const Icon(
          Icons.shopping_cart_outlined,
          color: AppColors.colorIncome,
        ),
        label: const Text(
          'Аналитика товаров',
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      const Text(
        '💡 Топ товаров и категорий за год',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
    ]);
  }

  Widget _transferSection() {
    final profile = ref.watch(transferProfileProvider);
    return _card('📡 Детекция переводов', [
      const Text(
        'Телефоны и ФИО используются только для автоматической пометки переводов между вашими счетами при импорте выписок. Можно не указывать.',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
      const SizedBox(height: 12),
      const Text(
        'Мои телефоны',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      for (final p in profile.myPhones)
        _row(p, () => _save(TransferProfile(
          myPhones: [for (final x in profile.myPhones) if (x != p) x],
          myNames: profile.myNames,
          familyAsTransfers: profile.familyAsTransfers,
          families: profile.families,
        ))),
      _addRow(_phoneController, 'Телефон', TextInputType.phone,
          () => _save(TransferProfile(
                myPhones: [...profile.myPhones, _phoneController.text.trim()],
                myNames: profile.myNames,
                familyAsTransfers: profile.familyAsTransfers,
                families: profile.families,
              ))),
      const SizedBox(height: 12),
      const Text(
        'Мои ФИО',
        style: TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      for (final n in profile.myNames)
        _row(n, () => _save(TransferProfile(
          myPhones: profile.myPhones,
          myNames: [for (final x in profile.myNames) if (x != n) x],
          familyAsTransfers: profile.familyAsTransfers,
          families: profile.families,
        ))),
      _addRow(_nameController, 'Фамилия Имя Отчество', TextInputType.text,
          () => _save(TransferProfile(
                myPhones: profile.myPhones,
                myNames: [...profile.myNames, _nameController.text.trim()],
                familyAsTransfers: profile.familyAsTransfers,
                families: profile.families,
              ))),
      const SizedBox(height: 12),
      Row(
        children: [
          const Expanded(
            child: Text(
              'Считать переводы внутри семьи переводами',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Switch(
            value: profile.familyAsTransfers,
            onChanged: (v) => _save(TransferProfile(
              myPhones: profile.myPhones,
              myNames: profile.myNames,
              familyAsTransfers: v,
              families: profile.families,
            )),
          ),
        ],
      ),
      if (profile.familyAsTransfers) ...[
        const SizedBox(height: 8),
        for (final f in profile.families) _familyCard(f, profile),
      ],
    ]);
  }

  Widget _familyCard(FamilyGroup f, TransferProfile profile) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Text(
                'Семья: ${f.name}',
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: () => _save(TransferProfile(
                myPhones: profile.myPhones,
                myNames: profile.myNames,
                familyAsTransfers: profile.familyAsTransfers,
                families: [
                  for (final x in profile.families)
                    if (x.name != f.name) x
                ],
              )),
            ),
          ]),
          for (final m in f.members)
            Row(children: [
              Expanded(
                child: Text(
                  '${m.name}${m.phones.isEmpty ? '' : ' · ${m.phones.join(', ')}'}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => _save(TransferProfile(
                  myPhones: profile.myPhones,
                  myNames: profile.myNames,
                  familyAsTransfers: profile.familyAsTransfers,
                  families: [
                    for (final x in profile.families)
                      if (x.name == f.name)
                        FamilyGroup(
                          name: f.name,
                          members: [
                            for (final mm in f.members)
                              if (mm.name != m.name) mm
                          ],
                        )
                      else
                        x
                  ],
                )),
              ),
            ]),
        ],
      ),
    );
  }

  Widget _dangerZone() {
    return _card('⚠️ Опасная зона', [
      TextButton.icon(
        onPressed: _signOut,
        icon: const Icon(Icons.logout, color: AppColors.colorWarning),
        label: const Text(
          '🚪 Выйти из аккаунта',
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),
      const Text(
        '💡 Выйти на этом устройстве',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
      const SizedBox(height: 12),
      TextButton.icon(
        onPressed: _deleteAccount,
        icon: const Icon(
          Icons.delete_forever_outlined,
          color: AppColors.colorExpense,
        ),
        label: const Text(
          '🗑️ Удалить аккаунт',
          style: TextStyle(color: AppColors.colorExpense),
        ),
      ),
      const Text(
        '💡 Необратимое действие. Все данные удалятся',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
      ),
    ]);
  }

  Widget _card(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: AppColors.borderDivider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _row(String text, VoidCallback onDelete) {
    return Row(children: [
      Expanded(
        child: Text(
          text,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.delete_outline, size: 20),
        onPressed: onDelete,
      ),
    ]);
  }

  Widget _addRow(
    TextEditingController c,
    String hint,
    TextInputType type,
    VoidCallback onAdd,
  ) {
    return Row(children: [
      Expanded(
        child: TextField(
          controller: c,
          keyboardType: type,
          decoration: InputDecoration(labelText: hint),
        ),
      ),
      IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          onAdd();
          c.clear();
        },
      ),
    ]);
  }
}