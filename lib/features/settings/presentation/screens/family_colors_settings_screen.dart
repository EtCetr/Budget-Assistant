// lib/features/settings/presentation/screens/family_colors_settings_screen.dart
// Этап 21 (ТЗ 6.3.46): цвета участников семьи (override в member_colors).
// Базовый цвет детерминирован (21.1b); здесь — кастомные override [E2E] (Этап 25).
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/core/providers/member_color_providers.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/member_color_palette.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/settings/presentation/providers/settings_providers.dart';
import 'package:budget_assistant/features/settings/presentation/providers/spaces_management_providers.dart';
import 'package:budget_assistant/features/settings/presentation/widgets/settings_section.dart';
import 'package:budget_assistant/features/settings/presentation/widgets/settings_switch_item.dart';

class FamilyColorsSettingsScreen extends ConsumerWidget {
  const FamilyColorsSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final scope = ref.watch(memberColorSpaceScopeProvider);
    final settingsAsync = ref.watch(appSettingsRowProvider);
    final membersAsync = ref.watch(familyMembersProvider);
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceBackground,
        title: const Text('Цвета участников'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          settingsAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (e, st) => const SizedBox.shrink(),
            data: (s) {
              if (s == null) return const SizedBox.shrink();
              return SettingsSection(
                title: '🎨 Отображение цветов',
                children: [
                  SettingsSwitchItem(
                    label: 'Цвета в списке транзакций',
                    value: s.showFamilyColorsInTransactions,
                    onChanged: (v) async {
                      HapticFeedback.selectionClick();
                      await ref.read(updateAppSettingsUseCaseProvider).call(
                        userId: ref.read(currentUserIdProvider),
                        changes: AppSettingsCompanion(
                          showFamilyColorsInTransactions: Value(v),
                        ),
                      );
                    },
                  ),
                  SettingsSwitchItem(
                    label: 'Цвета в графиках активности',
                    value: s.showFamilyColorsInCharts,
                    onChanged: (v) async {
                      HapticFeedback.selectionClick();
                      await ref.read(updateAppSettingsUseCaseProvider).call(
                        userId: ref.read(currentUserIdProvider),
                        changes: AppSettingsCompanion(
                          showFamilyColorsInCharts: Value(v),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
          // member_activity_card, top_active_members_section) и
          // transaction_row (D21-27).
          const SizedBox(height: 16),
          SettingsSection(
            title: scope.isEmpty ? '👤 Личное пространство' : '👨‍👩‍ Семья',
            subtitle: 'Нажмите на участника, чтобы изменить его цвет',
            children: membersAsync.when(
              loading: () => const [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
              ],
              error: (e, st) => const [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Не удалось загрузить участников',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ],
              data: (members) => [
                for (final m in members)
                  _memberRow(context, ref, m, scope, mode, formatter),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _memberRow(
    BuildContext context,
    WidgetRef ref,
    FamilyMemberInfo m,
    String scope,
    BalanceVisibilityMode mode,
    PrivacyFormatter formatter,
  ) {
    final color = ref.watch(
      memberColorForProvider((userId: m.userId, spaceScope: scope)),
    );
    final initials = m.displayName.isEmpty ? '?' : m.displayName[0].toUpperCase();
    return InkWell(
      onTap: () {
        HapticFeedback.lightImpact();
        _showPicker(context, ref, m, scope);
      },
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: AppColors.borderDivider),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                initials,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formatter.formatName(m.displayName, mode),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    m.role == 'admin' ? '👑 Админ' : '👤 Участник',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.all(Radius.circular(6)),
                border: Border.all(color: AppColors.borderDivider),
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPicker(
    BuildContext context,
    WidgetRef ref,
    FamilyMemberInfo m,
    String scope,
  ) async {
    final controller = TextEditingController();
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surfaceCard,
      builder: (ctx) => Consumer(
        builder: (ctx, ref, _) {
          final overrides =
              ref.watch(memberColorOverridesProvider(scope)).value ??
                  const <MemberColor>[];
          String? currentHex;
          for (final o in overrides) {
            if (o.userId == m.userId) currentHex = o.customColorHex;
          }
          final currentColor = parseMemberColorHex(currentHex);
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Цвет: ${m.displayName}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 6,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: [
                      for (final c in kMemberColorPalette)
                        InkWell(
                          onTap: () async {
                            await _save(ref, m, scope, _hexOf(c));
                            if (ctx.mounted) Navigator.pop(ctx);
                          },
                          borderRadius:
                              const BorderRadius.all(Radius.circular(8)),
                          child: Container(
                            decoration: BoxDecoration(
                              color: c,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                            ),
                            alignment: Alignment.center,
                            child: currentColor == c
                                ? const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 20,
                                  )
                                : null,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      labelText: 'Свой цвет (#RRGGBB)',
                      isDense: true,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          HapticFeedback.selectionClick();
                          await ref
                              .read(appDatabaseProvider)
                              .memberColorsDao
                              .deleteOverride(m.userId, scope);
                          if (ctx.mounted) Navigator.pop(ctx);
                        },
                        child: const Text('Сбросить'),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () async {
                          final hex =
                              controller.text.trim().toUpperCase();
                          final parsed = parseMemberColorHex(hex);
                          if (parsed == null) {
                            ScaffoldMessenger.of(ctx).showSnackBar(
                              const SnackBar(
                                content: Text('❌ Формат: #RRGGBB'),
                              ),
                            );
                            return;
                          }
                          await _save(ref, m, scope, hex);
                          if (ctx.mounted) Navigator.pop(ctx);
                        },
                        child: const Text('Применить'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    controller.dispose();
  }

  String _hexOf(Color c) =>
      '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

  Future<void> _save(
    WidgetRef ref,
    FamilyMemberInfo m,
    String scope,
    String hex,
  ) async {
    HapticFeedback.selectionClick();
    await ref.read(appDatabaseProvider).memberColorsDao.upsertOverride(
          MemberColorsCompanion.insert(
            id: const Uuid().v4(),
            userId: m.userId,
            customColorHex: hex,
            spaceId: Value(scope),
          ),
        );
  }
}
