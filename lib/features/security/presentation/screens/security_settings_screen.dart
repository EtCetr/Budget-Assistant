// lib/features/security/presentation/screens/security_settings_screen.dart
// Этап 21 (ТЗ 6.3.28): хаб настроек безопасности.
// Privacy: экран УПРАВЛЯЕТ приватностью, поэтому не маскируется в hidden.
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/security/presentation/providers/security_settings_providers.dart';
import 'package:budget_assistant/features/security/presentation/services/face_down_detector.dart';
import 'package:budget_assistant/features/security/presentation/services/shake_detector.dart';
import 'package:budget_assistant/features/security/presentation/widgets/security_dialogs.dart';
import 'package:budget_assistant/features/security/presentation/widgets/security_status_banner.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/settings/presentation/providers/settings_providers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:budget_assistant/core/export/presentation/widgets/export_destination_dialog.dart';
import 'package:budget_assistant/features/auth/domain/notifiers/auth_notifier.dart';
import 'package:budget_assistant/features/profile/presentation/providers/profile_providers.dart';

class SecuritySettingsScreen extends ConsumerStatefulWidget {
  const SecuritySettingsScreen({super.key, this.section});

  /// Якорь автопрокрутки: quick-hide | flag-secure | secrecy | auth.
  final String? section;

  @override
  ConsumerState<SecuritySettingsScreen> createState() =>
      _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends ConsumerState<SecuritySettingsScreen> {
  final Map<String, GlobalKey> _sectionKeys = {
    'quick-hide': GlobalKey(),
    'flag-secure': GlobalKey(),
    'auth': GlobalKey(),
    'secrecy': GlobalKey(),
  };
  bool _shakeInfoShown = false;
  bool _secrecyInfoShown = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToSection());
  }

  void _scrollToSection() {
    final key = _sectionKeys[widget.section];
    final ctx = key?.currentContext;
    if (ctx == null) return;
    Scrollable.ensureVisible(
      ctx,
      duration: const Duration(milliseconds: 400),
      alignment: 0.1,
    );
  }

  Future<void> _update(AppSettingsCompanion changes) async {
    await ref.read(updateAppSettingsUseCaseProvider).call(
      userId: ref.read(currentUserIdProvider),
      changes: changes,
    );
  }

  Future<bool> _verifyPin() async {
    final res = await context.push('/security/pin-entry?mode=verify');
    return res == true;
  }

  Future<void> _enablePinFlow() async {
    final res = await context.push('/security/pin-onboarding');
    if (res != true || !mounted) return;
    await _update(const AppSettingsCompanion(enablePinCode: Value(true)));
    ref.invalidate(pinCodeStoredProvider);
    if (!mounted) return;
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('✅ PIN-код установлен')));
  }

  Future<void> _disablePinFlow() async {
    if (!await _verifyPin() || !mounted) return;
    await ref.read(pinCodeRepositoryProvider).deletePin();
    await _update(
      const AppSettingsCompanion(
        enablePinCode: Value(false),
        enableBiometricLogin: Value(false),
      ),
    );
    ref.invalidate(pinCodeStoredProvider);
    if (!mounted) return;
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('🔓 PIN-код отключён')));
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<int>(securityLevelProvider, (prev, next) {
      if (next == 100 && prev != 100) HapticFeedback.mediumImpact();
    });
    final settingsAsync = ref.watch(appSettingsRowProvider);
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceBackground,
        title: const Text('Безопасность'),
      ),
      body: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Не удалось загрузить настройки',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref.invalidate(appSettingsRowProvider),
                child: const Text('Повторить'),
              ),
            ],
          ),
        ),
        data: (s) {
          if (s == null) {
            return const Center(
              child: Text(
                'Настройки недоступны',
                style: TextStyle(color: AppColors.textSecondary),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (!s.securityOnboardingShown) _onboardingBanner(),
              SecurityStatusBanner(
                score: ref.watch(securityLevelProvider),
                recommendation: ref.watch(securityRecommendationProvider),
              ),
              const SizedBox(height: 16),
              _buildQuickHideSection(s),
              const SizedBox(height: 16),
              _buildDataProtectionSection(s),
              const SizedBox(height: 16),
              _buildAuthenticationSection(s),
              const SizedBox(height: 16),
              _buildSecrecySection(s),
              const SizedBox(height: 16),
              _buildAdvancedSection(s),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _onboardingBanner() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: AppColors.colorTransfer.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.celebration_outlined,
                  color: AppColors.colorTransfer, size: 28),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Добро пожаловать в настройки безопасности!',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: () => _update(
                  const AppSettingsCompanion(
                    securityOnboardingShown: Value(true),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Настройте защиту под свои потребности. Рекомендуем включить хотя бы '
            'FLAG_SECURE и встряхивание.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () async {
              HapticFeedback.lightImpact();
              await _update(
                const AppSettingsCompanion(
                  enableShakeToHide: Value(true),
                  enableFaceDownHide: Value(true),
                  enableScreenCaptureProtection: Value(true),
                  enableSecrecyMode: Value(true),
                  securityOnboardingShown: Value(true),
                ),
              );
              if (!mounted) return;
              ShakeDetector.instance.start(ref);
              FaceDownDetector.instance.start(ref);
            },
            icon: const Icon(Icons.shield_outlined),
            label: const Text('Включить рекомендуемые настройки'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickHideSection(AppSetting s) {
    return Container(
      key: _sectionKeys['quick-hide'],
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🙈 Быстрое скрытие',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Мгновенно скрывайте балансы жестами',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 8),
          _switchRow(
            label: 'Встряхнуть телефон',
            description: 'Быстро скройте все балансы встряхиванием',
            value: s.enableShakeToHide,
            onChanged: (v) async {
              HapticFeedback.selectionClick();
              if (v && !_shakeInfoShown) {
                _shakeInfoShown = true;
                await showShakeInfoDialog(context);
                if (!mounted) return;
              }
              await _update(AppSettingsCompanion(enableShakeToHide: Value(v)));
              if (!mounted) return;
              if (v) {
                ShakeDetector.instance.start(ref);
              } else {
                ShakeDetector.instance.stop();
              }
            },
          ),
          _switchRow(
            label: 'Перевернуть экран вниз',
            description: 'Скройте данные, положив телефон экраном вниз',
            value: s.enableFaceDownHide,
            onChanged: (v) async {
              HapticFeedback.selectionClick();
              await _update(
                AppSettingsCompanion(enableFaceDownHide: Value(v)),
              );
              if (!mounted) return;
              if (v) {
                FaceDownDetector.instance.start(ref);
              } else {
                FaceDownDetector.instance.stop();
              }
            },
          ),
          _valueRow(
            icon: Icons.timer_outlined,
            label: 'Автоматически скрывать через',
            value: s.autoHideTimeoutSeconds == 0
                ? 'Выключено'
                : '${s.autoHideTimeoutSeconds} сек',
            onTap: () async {
              HapticFeedback.lightImpact();
              final picked = await showAutoHideTimeoutSheet(
                context,
                s.autoHideTimeoutSeconds,
              );
              if (picked == null || !mounted) return;
              HapticFeedback.selectionClick();
              await _update(
                AppSettingsCompanion(autoHideTimeoutSeconds: Value(picked)),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              '💡 Автоматическое скрытие защищает от случайных взглядов, когда '
              'вы оставили телефон без присмотра.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataProtectionSection(AppSetting s) {
    return Container(
      key: _sectionKeys['flag-secure'],
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔒 Защита данных',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Предотвращайте утечку через скриншоты',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 8),
          _switchRow(
            label: 'Блокировать скриншоты (FLAG_SECURE)',
            description: 'Скриншоты и запись экрана запрещены',
            value: s.enableScreenCaptureProtection,
            onChanged: (v) async {
              HapticFeedback.selectionClick();
              if (!v) {
                final confirmed = await showFlagSecureOffWarning(context);
                if (!confirmed || !mounted) return;
              }
              // D21-10: нативно FLAG_SECURE управляется Kotlin-каналом
              // (D19-7/D20-7); глобальное отключение — TODO(25).
              await _update(
                AppSettingsCompanion(enableScreenCaptureProtection: Value(v)),
              );
            },
          ),
          _switchRow(
            label: 'Показывать балансы на Lock screen',
            description: 'Виджеты и уведомления с суммами на заблокированном экране',
            value: s.showBalancesOnLockScreen,
            onChanged: (v) async {
              HapticFeedback.selectionClick();
              if (v) {
                final confirmed = await showLockScreenOnWarning(context);
                if (!confirmed || !mounted) return;
              }
              await _update(
                AppSettingsCompanion(showBalancesOnLockScreen: Value(v)),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Text(
              '⚠️ Для показа скидочных карт кассирам FLAG_SECURE временно '
              'отключается (5 секунд). Защита возвращается автоматически.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAuthenticationSection(AppSetting s) {
    final bioAvailable = ref.watch(biometricAvailableProvider).value ?? false;
    final bioLoading = ref.watch(biometricAvailableProvider).isLoading;
    final pinStored = ref.watch(pinCodeStoredProvider).value ?? false;
    final pinOn = s.enablePinCode && pinStored;
    return Container(
      key: _sectionKeys['auth'],
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔐 Аутентификация',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Защитите вход в приложение',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 8),
          _switchRow(
            label: 'PIN-код',
            description: '4-значный код для входа в приложение',
            value: pinOn,
            onChanged: (v) async {
              HapticFeedback.selectionClick();
              if (v) {
                await _enablePinFlow();
              } else {
                await _disablePinFlow();
              }
            },
          ),
          if (!pinStored)
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: () async {
                  HapticFeedback.lightImpact();
                  await _enablePinFlow();
                },
                icon: const Icon(Icons.pin_outlined, size: 18),
                label: const Text('Установить PIN'),
              ),
            ),
          _switchRow(
            label: 'Биометрия (отпечаток / Face ID)',
            description: bioLoading
                ? 'Проверяем доступность...'
                : 'Вход по отпечатку пальца или Face ID',
            value: s.enableBiometricLogin,
            enabled: bioAvailable && pinOn,
            warning: pinOn ? null : '⚠️ Сначала установите PIN-код',
            onChanged: (v) async {
              HapticFeedback.selectionClick();
              if (v) {
                final res = await context.push('/security/biometric-onboarding');
                if (res == true && mounted) {
                  HapticFeedback.mediumImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ Биометрия включена')),
                  );
                }
              } else {
                if (!await _verifyPin() || !mounted) return;
                await _update(
                  const AppSettingsCompanion(enableBiometricLogin: Value(false)),
                );
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('🔓 Биометрия отключена')),
                );
              }
            },
          ),
          _switchRow(
            label: 'Требовать PIN для секретных операций',
            description: 'Раскрытие секретных транзакций, экспорт данных',
            value: s.requirePinForSensitive,
            enabled: pinOn,
            onChanged: (v) async {
              HapticFeedback.selectionClick();
              await _update(
                AppSettingsCompanion(requirePinForSensitive: Value(v)),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSecrecySection(AppSetting s) {
    final holidaysCount = ref.watch(upcomingHolidaysCountProvider).value ?? 0;
    final secretCount = ref.watch(secretTransactionsCountProvider).value ?? 0;
    return Container(
      key: _sectionKeys['secrecy'],
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🎁 Режим секретности',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Автоматически скрывайте подарки перед праздниками',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 8),
          _switchRow(
            label: 'Включить режим',
            value: s.enableSecrecyMode,
            onChanged: (v) async {
              HapticFeedback.selectionClick();
              if (v && !_secrecyInfoShown) {
                _secrecyInfoShown = true;
                await showSecrecyInfoDialog(context);
                if (!mounted) return;
              }
              await _update(AppSettingsCompanion(enableSecrecyMode: Value(v)));
            },
          ),
          _valueRow(
            icon: Icons.calendar_month_outlined,
            label: 'Дней до праздника',
            value: '${s.secrecyDaysBefore}',
            onTap: () async {
              HapticFeedback.lightImpact();
              final picked = await showSecrecyDaysSheet(
                context,
                s.secrecyDaysBefore,
              );
              if (picked == null || !mounted) return;
              HapticFeedback.selectionClick();
              await _update(
                AppSettingsCompanion(secrecyDaysBefore: Value(picked)),
              );
            },
          ),
          _navRow(
            icon: Icons.event_outlined,
            label: 'Управление праздниками',
            subtitle: 'Добавить, редактировать, удалить праздники',
            badge: holidaysCount > 0 ? holidaysCount : null,
            onTap: () {
              HapticFeedback.lightImpact();
              context.push('/calendar/holidays');
            },
          ),
          _navRow(
            icon: Icons.search,
            label: 'Проверить секретные транзакции',
            subtitle: 'Просмотреть все скрытые операции',
            badge: secretCount > 0 ? secretCount : null,
            onTap: () {
              HapticFeedback.lightImpact();
              // TODO(21.10): автофильтр is_hidden_by_calendar через query.
              context.push('/transactions');
            },
          ),
        ],
      ),
    );
  }

  Future<void> _exportKeys() async {
    HapticFeedback.lightImpact();
    final messenger = ScaffoldMessenger.of(context);
    final s = ref.read(appSettingsRowProvider).value;
    if (s != null && s.requirePinForSensitive && s.enablePinCode) {
      final ok = await context.push('/security/pin-entry?mode=verify');
      if (ok != true || !mounted) return;
    }
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: const Text('⚠️ Экспорт ключей шифрования'),
        content: const Text(
          'Ключи используются для защиты ваших данных (E2E, AES-256-GCM). '
          'ВНИМАНИЕ: любой, кто получит файл и пароль, сможет расшифровать '
          'все ваши данные. Файл будет зашифрован паролем.',
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
    final password = await _passwordSheet();
    if (password == null || !mounted) return;
    HapticFeedback.mediumImpact();
    try {
      final path =
          await ref.read(exportEncryptionKeysUseCaseProvider).call(password);
      if (!mounted) return;
      await showExportDestinationDialog(
        context,
        path: path,
        shareText: '🔑 Ключи шифрования Budget Assistant (зашифрованы)',
        mime: 'application/octet-stream',
      );
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            '⚠️ Храните файл в безопасном месте. Удалите после восстановления',
          ),
        ),
      );
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('❌ Ошибка экспорта ключей: $e')),
        );
      }
    }
  }

  Future<String?> _passwordSheet() async {
    final controller = TextEditingController();
    final confirmController = TextEditingController();
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.surfaceCard,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🔑 Пароль для файла ключей',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Минимум 8 символов. Без пароля файл бесполезен.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Пароль'),
            ),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Повторите пароль'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                final pw = controller.text;
                if (pw.length < 8 || pw != confirmController.text) return;
                Navigator.pop(ctx, pw);
              },
              child: const Text('Продолжить'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
    confirmController.dispose();
    return result;
  }

  Future<void> _clearAppData() async {
    HapticFeedback.lightImpact();
    final messenger = ScaffoldMessenger.of(context);
    final s = ref.read(appSettingsRowProvider).value;
    if (s != null && s.requirePinForSensitive && s.enablePinCode) {
      final ok = await context.push('/security/pin-entry?mode=verify');
      if (ok != true || !mounted) return;
    }
    final c1 = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: const Text('⚠️ Очистить данные приложения?'),
        content: const Text(
          'Будут удалены: все локальные транзакции, счета, цели, '
          'PIN-код и ключи шифрования. Данные в Supabase останутся, '
          'но без ключей расшифровка при входе невозможна. '
          'Рекомендуется сначала экспортировать ключи.',
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
    if (c1 != true || !mounted) return;
    HapticFeedback.mediumImpact();
    final controller = TextEditingController();
    final c2 = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: const Text('🔴 Вы уверены?'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Введите слово: ОЧИСТИТЬ',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Очистить'),
          ),
        ],
      ),
    );
    final word = controller.text.trim().toUpperCase();
    controller.dispose();
    if (c2 != true || !mounted) return;
    if (word != 'ОЧИСТИТЬ') {
      messenger.showSnackBar(
        const SnackBar(content: Text('❌ Слово введено неверно')),
      );
      return;
    }
    HapticFeedback.heavyImpact();
    try {
      // D21-36: локально та же механика, что и удаление аккаунта (21.8).
      await ref.read(deleteAccountUseCaseProvider).call();
      try {
        final cache = await getTemporaryDirectory();
        if (cache.existsSync()) cache.deleteSync(recursive: true);
      } catch (_) {}
      await ref.read(authProvider.notifier).signOut();
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('❌ Ошибка очистки: $e')),
        );
      }
    }
  }

  Widget _buildAdvancedSection(AppSetting s) {
    final pinStored = ref.watch(pinCodeStoredProvider).value ?? false;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⚙️ Продвинутые',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          if (pinStored)
            _navRow(
              icon: Icons.key_outlined,
              label: 'Сменить PIN-код',
              onTap: () async {
                HapticFeedback.lightImpact();
                // D21-12: verify текущего PIN, затем установка нового.
                if (!await _verifyPin() || !mounted) return;
                final res = await context.push('/security/pin-onboarding');
                if (res == true && mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('✅ PIN-код изменён')),
                  );
                }
              },
            ),
          _navRow(
            icon: Icons.upload_outlined,
            label: 'Экспорт ключей шифрования',
            subtitle: '⚠️ Только для резервного копирования',
            iconColor: AppColors.colorWarning,
            onTap: _exportKeys,
          ),
          _navRow(
            icon: Icons.delete_forever_outlined,
            label: 'Очистить данные приложения',
            subtitle: '⚠️ Удалить все локальные данные и выйти из аккаунта',
            iconColor: AppColors.colorExpense,
            onTap: _clearAppData,
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: AppColors.surfaceCard,
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      border: Border.all(color: AppColors.borderDivider),
    );
  }

  Widget _switchRow({
    required String label,
    String? description,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool enabled = true,
    String? warning,
  }) {
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                    ),
                  ),
                ),
                Switch(value: value, onChanged: enabled ? onChanged : null),
              ],
            ),
            if (description != null)
              Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 4),
                child: Text(
                  description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ),
            if (warning != null)
              Padding(
                padding: const EdgeInsets.only(right: 8, bottom: 4),
                child: Text(
                  warning,
                  style: const TextStyle(
                    color: AppColors.colorWarning,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _valueRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textPrimary, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                ),
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: AppColors.colorTransfer,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_forward_ios,
                size: 14, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }

  Widget _navRow({
    required IconData icon,
    required String label,
    String? subtitle,
    int? badge,
    bool enabled = true,
    String? tooltip,
    Color iconColor = AppColors.textPrimary,
    required VoidCallback onTap,
  }) {
    final row = InkWell(
      onTap: enabled ? onTap : null,
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: enabled
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            if (badge != null)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: const BoxDecoration(
                  color: AppColors.colorWarning,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$badge',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            const Icon(Icons.arrow_forward_ios,
                size: 14, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
    return Opacity(
      opacity: enabled ? 1 : 0.5,
      child: tooltip == null
          ? row
          : Tooltip(message: tooltip, child: row),
    );
  }
}