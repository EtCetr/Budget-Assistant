// lib/features/settings/presentation/screens/settings_screen.dart
// Этап 21 (ТЗ 6.3.38): главный хаб настроек (8 секций).
// D21-16/D21-18/D21-19: пункты без готовых экранов/колонок — disabled + тултип
// с TODO соответствующего под-шага; включаются микро-патчем в своём под-шаге.
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/dashboard/presentation/widgets/app_drawer.dart';
import 'package:budget_assistant/features/settings/presentation/providers/settings_providers.dart';
import 'package:budget_assistant/features/settings/presentation/widgets/settings_dropdown_item.dart';
import 'package:budget_assistant/features/settings/presentation/widgets/settings_navigation_item.dart';
import 'package:budget_assistant/features/settings/presentation/widgets/settings_section.dart';
import 'package:budget_assistant/features/settings/presentation/widgets/settings_switch_item.dart';
import 'package:budget_assistant/features/settings/presentation/widgets/sync_images_warning_dialog.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(appSettingsRowProvider);
    return Scaffold(
      drawer: const AppDrawer(currentRoute: '/settings'),
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceBackground,
        title: const Text('Настройки'),
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
              _securitySection(context, s),
              const SizedBox(height: 16),
              _notificationsSection(context),
              const SizedBox(height: 16),
              _importSection(context, ref, s),
              const SizedBox(height: 16),
              _receiptsSection(context, ref, s),
              const SizedBox(height: 16),
              _familySection(ref, s),
              const SizedBox(height: 16),
              _currencySection(context, ref, s),
              const SizedBox(height: 16),
              _dataSection(context, ref),
              const SizedBox(height: 16),
              _aboutSection(context, ref),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Future<void> _update(WidgetRef ref, AppSettingsCompanion changes) async {
    await ref.read(updateAppSettingsUseCaseProvider).call(
      userId: ref.read(currentUserIdProvider),
      changes: changes,
    );
  }

  static void _noopTap() {}

  // ============ Section 1: Безопасность ============
  Widget _securitySection(BuildContext context, AppSetting s) {
    final pinOn = s.enablePinCode;
    final quickHideCount = (s.enableShakeToHide ? 1 : 0) +
        (s.enableFaceDownHide ? 1 : 0) +
        (s.autoHideTimeoutSeconds > 0 ? 1 : 0);
    return SettingsSection(
      title: '🔒 Безопасность',
      subtitle: 'PIN, скрытие балансов, защита от скриншотов',
      children: [
        SettingsNavigationItem(
          icon: Icons.pin_outlined,
          label: 'PIN-код и биометрия',
          badge: pinOn ? 'вкл' : 'выкл',
          badgeColor:
              pinOn ? AppColors.colorTransfer : AppColors.surfaceElevated,
          onTap: () {
            HapticFeedback.lightImpact();
            context.push('/settings/security');
          },
        ),
        SettingsNavigationItem(
          icon: Icons.visibility_off_outlined,
          label: 'Быстрое скрытие балансов',
          badge: '$quickHideCount',
          onTap: () {
            HapticFeedback.lightImpact();
            context.push('/settings/security?section=quick-hide');
          },
        ),
        SettingsNavigationItem(
          icon: Icons.screenshot_monitor_outlined,
          label: 'Защита от скриншотов (FLAG_SECURE)',
          badge: s.enableScreenCaptureProtection ? 'вкл' : 'выкл',
          badgeColor: s.enableScreenCaptureProtection
              ? AppColors.colorTransfer
              : AppColors.surfaceElevated,
          onTap: () {
            HapticFeedback.lightImpact();
            context.push('/settings/security?section=flag-secure');
          },
        ),
        SettingsNavigationItem(
          icon: Icons.card_giftcard_outlined,
          label: 'Режим секретности (подарки)',
          badge: '${s.secrecyDaysBefore} дн',
          onTap: () {
            HapticFeedback.lightImpact();
            context.push('/settings/security?section=secrecy');
          },
        ),
      ],
    );
  }

  // ============ Section 2: Уведомления ============
  Widget _notificationsSection(BuildContext context) {
    return SettingsSection(
      title: '🔔 Уведомления',
      subtitle: 'Пуши, дайджесты, время тишины',
      children: [
        SettingsNavigationItem(
          icon: Icons.notifications_outlined,
          label: 'Управление пушами (27 типов)',
          onTap: () {
            HapticFeedback.lightImpact();
            context.push('/settings/notifications');
          },
        ),
        SettingsNavigationItem(
          icon: Icons.newspaper_outlined,
          label: 'Дайджесты (день/неделя/месяц)',
          onTap: () {
            HapticFeedback.lightImpact();
            context.push('/settings/digest');
          },
        ),
        // D21-16: колонок night_mode нет; энфорсмент в воркере Этапа 18.
        // TODO(21.10): миграция night_mode_* + проверка в триггерах пушей.
        const SettingsSwitchItem(
          label: 'Время тишины (ночной режим)',
          description: '22:00 – 08:00 все пуши блокируются',
          value: false,
          onChanged: _noopSwitch,
          enabled: false,
          tooltip: 'Появится в под-шаге 21.10',
        ),
      ],
    );
  }

  static void _noopSwitch(bool v) {}

  // ============ Section 3: Импорт данных ============
  Widget _importSection(BuildContext context, WidgetRef ref, AppSetting s) {
    return SettingsSection(
      title: '📥 Импорт данных',
      subtitle: 'Детекция дубликатов, переводов, подарков',
      children: [
        SettingsSwitchItem(
          label: 'Автоматически детектировать дубликаты',
          value: s.enableAutoDetectDuplicates,
          onChanged: (v) async {
            HapticFeedback.selectionClick();
            await _update(
              ref,
              AppSettingsCompanion(enableAutoDetectDuplicates: Value(v)),
            );
          },
        ),
        SettingsSwitchItem(
          label: 'Автоматически детектировать переводы',
          value: s.enableAutoDetectTransfers,
          onChanged: (v) async {
            HapticFeedback.selectionClick();
            await _update(
              ref,
              AppSettingsCompanion(enableAutoDetectTransfers: Value(v)),
            );
          },
        ),
        SettingsSwitchItem(
          label: 'Предлагать секретность для подарков',
          value: s.autoHideGiftsOnImport,
          onChanged: (v) async {
            HapticFeedback.selectionClick();
            await _update(
              ref,
              AppSettingsCompanion(autoHideGiftsOnImport: Value(v)),
            );
          },
        ),
        SettingsSwitchItem(
          label: 'Напоминать об импорте выписок',
          value: s.enableBankStatementReminder,
          onChanged: (v) async {
            HapticFeedback.selectionClick();
            await _update(
              ref,
              AppSettingsCompanion(enableBankStatementReminder: Value(v)),
            );
          },
        ),
        SettingsDropdownItem(
          icon: Icons.date_range_outlined,
          label: 'Окно детекции дубликатов',
          valueLabel: '${s.duplicateDateToleranceDays} дн',
          onTap: () async {
            HapticFeedback.lightImpact();
            final picked = await showSettingsOptionsSheet<int>(
              context,
              title: 'Окно детекции дубликатов',
              current: s.duplicateDateToleranceDays,
              options: const [
                SettingsDropdownOption(label: '1 день', value: 1),
                SettingsDropdownOption(label: '2 дня', value: 2),
                SettingsDropdownOption(label: '3 дня', value: 3),
                SettingsDropdownOption(label: '7 дней', value: 7),
              ],
            );
            if (picked == null || !context.mounted) return;
            await _update(
              ref,
              AppSettingsCompanion(duplicateDateToleranceDays: Value(picked)),
            );
          },
        ),
        SettingsDropdownItem(
          icon: Icons.swap_horiz_outlined,
          label: 'Окно детекции переводов (P2P)',
          valueLabel: '${s.transferTimeToleranceMinutes} мин',
          onTap: () async {
            HapticFeedback.lightImpact();
            final picked = await showSettingsOptionsSheet<int>(
              context,
              title: 'Окно детекции переводов',
              current: s.transferTimeToleranceMinutes,
              options: const [
                SettingsDropdownOption(label: '1 минута', value: 1),
                SettingsDropdownOption(label: '5 минут', value: 5),
                SettingsDropdownOption(label: '15 минут', value: 15),
                SettingsDropdownOption(label: '60 минут', value: 60),
              ],
            );
            if (picked == null || !context.mounted) return;
            await _update(
              ref,
              AppSettingsCompanion(
                transferTimeToleranceMinutes: Value(picked),
              ),
            );
          },
        ),
      ],
    );
  }

  // ============ Section 4: Чеки и OCR ============
  Widget _receiptsSection(BuildContext context, WidgetRef ref, AppSetting s) {
    return SettingsSection(
      title: '🧾 Чеки и OCR',
      subtitle: 'Разделение чеков, именование товаров, облако',
      children: [
        SettingsSwitchItem(
          label: 'Предлагать разделение по категориям',
          value: s.autoOfferReceiptSplit,
          onChanged: (v) async {
            HapticFeedback.selectionClick();
            await _update(
              ref,
              AppSettingsCompanion(autoOfferReceiptSplit: Value(v)),
            );
          },
        ),
        SettingsSwitchItem(
          label: 'Предлагать именование товаров',
          value: s.autoOfferProductNaming,
          onChanged: (v) async {
            HapticFeedback.selectionClick();
            await _update(
              ref,
              AppSettingsCompanion(autoOfferProductNaming: Value(v)),
            );
          },
        ),
        SettingsSwitchItem(
          label: 'Синхронизировать фото чеков в облако',
          value: s.syncImagesToCloud,
          onChanged: (v) async {
            HapticFeedback.selectionClick();
            if (v) {
              final confirmed = await showSyncImagesWarningDialog(context);
              if (!confirmed || !context.mounted) return;
            }
            await _update(
              ref,
              AppSettingsCompanion(syncImagesToCloud: Value(v)),
            );
          },
        ),
        // TODO(21.10): ProductAliasesSettingsScreen (список алиасов).
        const SettingsNavigationItem(
          icon: Icons.label_outline,
          label: 'Управление алиасами товаров',
          enabled: false,
          tooltip: 'Появится в под-шаге 21.10',
          onTap: _noopTap,
        ),
      ],
    );
  }

  // ============ Section 5: Семья и пространства ============
  Widget _familySection(WidgetRef ref, AppSetting s) {
    return SettingsSection(
      title: '👨‍👩‍ Семья и пространства',
      subtitle: 'Multi-group: пространства, цвета, активность',
      children: [
        // TODO(21.5): включить после SpacesManagementScreen.
        const SettingsNavigationItem(
          icon: Icons.home_outlined,
          label: 'Управление пространствами',
          enabled: false,
          tooltip: 'Появится в под-шаге 21.5',
          onTap: _noopTap,
        ),
        // TODO(21.7): включить после FamilyColorsSettingsScreen.
        const SettingsNavigationItem(
          icon: Icons.palette_outlined,
          label: 'Цвета участников',
          enabled: false,
          tooltip: 'Появится в под-шаге 21.7',
          onTap: _noopTap,
        ),
        SettingsSwitchItem(
          label: 'Пуши о действиях в группе',
          value: s.enableGroupActivityAlerts,
          onChanged: (v) async {
            HapticFeedback.selectionClick();
            await _update(
              ref,
              AppSettingsCompanion(enableGroupActivityAlerts: Value(v)),
            );
          },
        ),
      ],
    );
  }

  // ============ Section 6: Валюта и курсы ============
  Widget _currencySection(BuildContext context, WidgetRef ref, AppSetting s) {
    return SettingsSection(
      title: '💱 Валюта и курсы',
      subtitle: 'Базовая валюта и исторические курсы',
      children: [
        SettingsDropdownItem(
          icon: Icons.payments_outlined,
          label: 'Базовая валюта',
          valueLabel: s.baseCurrency,
          onTap: () async {
            HapticFeedback.lightImpact();
            final picked = await showSettingsOptionsSheet<String>(
              context,
              title: 'Базовая валюта',
              current: s.baseCurrency,
              options: const [
                SettingsDropdownOption(label: 'RUB — Рубль', value: 'RUB'),
                SettingsDropdownOption(label: 'USD — Доллар', value: 'USD'),
                SettingsDropdownOption(label: 'EUR — Евро', value: 'EUR'),
                SettingsDropdownOption(label: 'CNY — Юань', value: 'CNY'),
                SettingsDropdownOption(label: 'KZT — Тенге', value: 'KZT'),
                SettingsDropdownOption(label: 'BYN — Бел. рубль', value: 'BYN'),
              ],
            );
            if (picked == null || !context.mounted) return;
            await _update(
              ref,
              AppSettingsCompanion(baseCurrency: Value(picked)),
            );
          },
        ),
        SettingsSwitchItem(
          label: 'Фиксировать курс на дату покупки',
          value: s.useHistoricalExchangeRate,
          onChanged: (v) async {
            HapticFeedback.selectionClick();
            await _update(
              ref,
              AppSettingsCompanion(useHistoricalExchangeRate: Value(v)),
            );
          },
        ),
        // TODO(21.10): ExchangeRatesScreen (график курсов за год).
        const SettingsNavigationItem(
          icon: Icons.show_chart_outlined,
          label: 'История курсов',
          enabled: false,
          tooltip: 'Появится в под-шаге 21.10',
          onTap: _noopTap,
        ),
      ],
    );
  }

  // ============ Section 7: Данные и экспорт ============
  Widget _dataSection(BuildContext context, WidgetRef ref) {
    return SettingsSection(
      title: '📊 Данные и экспорт',
      subtitle: 'Экспорт XLSX, импорт, очистка кэша',
      children: [
        // TODO(21.9): ExportAllDataSheet (XLSX 3 листа + PIN).
        const SettingsNavigationItem(
          icon: Icons.upload_outlined,
          label: 'Экспорт всех данных (XLSX)',
          enabled: false,
          tooltip: 'Появится в под-шаге 21.9',
          onTap: _noopTap,
        ),
        SettingsNavigationItem(
          icon: Icons.download_outlined,
          label: 'Импорт из другого приложения',
          onTap: () {
            HapticFeedback.lightImpact();
            context.push('/import/onboarding');
          },
        ),
        SettingsNavigationItem(
          icon: Icons.cleaning_services_outlined,
          label: 'Очистить локальный кэш',
          subtitle: 'forecast_cache, yearly_aggregates, аналитика товаров',
          onTap: () => _clearCache(context, ref),
        ),
      ],
    );
  }

  Future<void> _clearCache(BuildContext context, WidgetRef ref) async {
    HapticFeedback.lightImpact();
    final messenger = ScaffoldMessenger.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: const Text('🗑️ Очистить локальный кэш?'),
        content: const Text(
          'Удалятся кэши прогнозов, годовых итогов и аналитики товаров. '
          'Транзакции, счета, цели и долги НЕ удаляются. '
          'Данные пересчитаются в фоновом режиме.',
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
    if (confirm != true) return;
    HapticFeedback.mediumImpact();
    try {
      await ref.read(clearLocalCacheUseCaseProvider).call();
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            '✅ Кэш очищен. Данные пересчитаются в фоновом режиме в течение 5 минут',
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('❌ Ошибка очистки кэша: $e')),
      );
    }
  }

  // ============ Section 8: О приложении ============
  Widget _aboutSection(BuildContext context, WidgetRef ref) {
    final version = ref.watch(appVersionProvider).value ?? '…';
    return SettingsSection(
      title: 'ℹ️ О приложении',
      children: [
        SettingsNavigationItem(
          icon: Icons.info_outline,
          label: 'Версия',
          subtitle: version,
          showArrow: false,
          onTap: _noopTap,
        ),
        SettingsNavigationItem(
          icon: Icons.description_outlined,
          label: 'Лицензии open-source',
          onTap: () {
            HapticFeedback.lightImpact();
            showLicensePage(context: context);
          },
        ),
        // D21-18: url_launcher нет в pubspec.
        // TODO(21.10): политика/поддержка/Google Play через url_launcher.
        const SettingsNavigationItem(
          icon: Icons.privacy_tip_outlined,
          label: 'Политика конфиденциальности',
          enabled: false,
          tooltip: 'Появится в под-шаге 21.10',
          onTap: _noopTap,
        ),
        const SettingsNavigationItem(
          icon: Icons.support_agent_outlined,
          label: 'Связаться с поддержкой',
          enabled: false,
          tooltip: 'Появится в под-шаге 21.10',
          onTap: _noopTap,
        ),
        const SettingsNavigationItem(
          icon: Icons.star_outline,
          label: 'Оценить в Google Play',
          enabled: false,
          tooltip: 'Появится в под-шаге 21.10',
          onTap: _noopTap,
        ),
      ],
    );
  }
}