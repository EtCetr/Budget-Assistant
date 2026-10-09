import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:budget_assistant/core/providers/transfer_profile_provider.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/admin/presentation/providers/admin_providers.dart';
import 'package:budget_assistant/features/auth/domain/notifiers/auth_notifier.dart';
import 'package:budget_assistant/features/dashboard/presentation/widgets/app_drawer.dart';
import 'package:budget_assistant/features/import/domain/entities/transfer_profile.dart';
import 'package:budget_assistant/features/spaces/presentation/providers/space_providers.dart';
import 'package:budget_assistant/features/spaces/presentation/widgets/create_space_dialog.dart';

/// Профиль (минимум, Этап 15; полный по ТЗ 6.3.39 — в Этапе 21).
/// Внутри цветных карточек НЕ используем ListTile/SwitchListTile (фикс ассерта).
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

  Future<void> _signOut() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Выйти из аккаунта?'),
        content: const Text('Локальные данные останутся на устройстве.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Выйти')),
        ],
      ),
    );
    if (confirm != true || !mounted) {
      return;
    }
    await ref.read(authProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context) {
    final email = Supabase.instance.client.auth.currentUser?.email ?? '—';
    final spaces = ref.watch(userSpacesProvider).value ?? const [];
    final profile = ref.watch(transferProfileProvider);
    // Этап 17: видимость кнопки админки (только активный админ текущего пространства).
    final scope = ref.watch(adminScopeProvider);
    final isAdmin = scope == null
        ? false
        : (ref.watch(adminAccessProvider(scope)).value ?? false);
    return Scaffold(
      drawer: const AppDrawer(currentRoute: '/profile'),
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceBackground,
        title: const Text('Профиль'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Выйти',
            onPressed: _signOut,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
_card('Аккаунт', [
            Text(email, style: const TextStyle(color: AppColors.textSecondary)),
          ]),
          const SizedBox(height: 16),
          _card('Семейные пространства', [
            if (spaces.isEmpty)
              const Text('Нет пространств',
                  style: TextStyle(color: AppColors.textSecondary))
            else
              for (final s in spaces)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text((s as dynamic).name?.toString() ?? 'Пространство',
                      style: const TextStyle(color: AppColors.textPrimary)),
                ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () async {
                await CreateSpaceDialog.show(context);
                if (mounted) {
                  ref.invalidate(userSpacesProvider);
                }
              },
              icon: const Icon(Icons.group_add),
              label: const Text('Создать семейную группу'),
            ),
          ]),
          if (isAdmin) ...[
            const SizedBox(height: 16),
            _card('Администрирование', [
              TextButton.icon(
                onPressed: () => context.push('/admin'),
                icon: const Icon(Icons.admin_panel_settings,
                    color: AppColors.colorFAB),
                label: const Text('Управление участниками и настройками',
                    style: TextStyle(color: AppColors.textPrimary)),
              ),
            ]),
          ],
          const SizedBox(height: 16),
          _card('Детекция переводов', [
            const Text(
              'Телефоны и ФИО используются только для автоматической пометки переводов между вашими счетами при импорте выписок. Можно не указывать.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
            ),
            const SizedBox(height: 12),
            const Text('Мои телефоны',
                style: TextStyle(
                    color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
            for (final p in profile.myPhones)
              _row(p, () => _save(TransferProfile(
                  myPhones: [for (final x in profile.myPhones) if (x != p) x],
                  myNames: profile.myNames,
                  familyAsTransfers: profile.familyAsTransfers,
                  families: profile.families))),
            _addRow(_phoneController, 'Телефон', TextInputType.phone,
                () => _save(TransferProfile(
                    myPhones: [...profile.myPhones, _phoneController.text.trim()],
                    myNames: profile.myNames,
                    familyAsTransfers: profile.familyAsTransfers,
                    families: profile.families))),
            const SizedBox(height: 12),
            const Text('Мои ФИО',
                style: TextStyle(
                    color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
            for (final n in profile.myNames)
              _row(n, () => _save(TransferProfile(
                  myPhones: profile.myPhones,
                  myNames: [for (final x in profile.myNames) if (x != n) x],
                  familyAsTransfers: profile.familyAsTransfers,
                  families: profile.families))),
            _addRow(_nameController, 'Фамилия Имя Отчество', TextInputType.text,
                () => _save(TransferProfile(
                    myPhones: profile.myPhones,
                    myNames: [...profile.myNames, _nameController.text.trim()],
                    familyAsTransfers: profile.familyAsTransfers,
                    families: profile.families))),
            const SizedBox(height: 12),
            Row(
              children: [
                const Expanded(
                  child: Text('Считать переводы внутри семьи переводами',
                      style: TextStyle(fontSize: 14)),
                ),
                Switch(
                  value: profile.familyAsTransfers,
                  onChanged: (v) => _save(TransferProfile(
                      myPhones: profile.myPhones,
                      myNames: profile.myNames,
                      familyAsTransfers: v,
                      families: profile.families)),
                ),
              ],
            ),
            if (profile.familyAsTransfers) ...[
              const SizedBox(height: 8),
              for (final f in profile.families)
                _familyCard(f, profile),
            ],
          ]),
        ],
      ),
    );
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
                child: Text('Семья: ${f.name}',
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600))),
            IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                onPressed: () => _save(TransferProfile(
                    myPhones: profile.myPhones,
                    myNames: profile.myNames,
                    familyAsTransfers: profile.familyAsTransfers,
                    families: [
                      for (final x in profile.families)
                        if (x.name != f.name) x
                    ]))),
          ]),
          for (final m in f.members)
            Row(children: [
              Expanded(
                  child: Text(
                      '${m.name}${m.phones.isEmpty ? '' : ' · ${m.phones.join(', ')}'}',
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 13))),
              IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => _save(TransferProfile(
                      myPhones: profile.myPhones,
                      myNames: profile.myNames,
                      familyAsTransfers: profile.familyAsTransfers,
                      families: [
                        for (final x in profile.families)
                          if (x.name == f.name)
                            FamilyGroup(name: f.name, members: [
                              for (final mm in f.members)
                                if (mm.name != m.name) mm
                            ])
                          else
                            x
                      ]))),
            ]),
        ],
      ),
    );
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
          Text(title,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  Widget _row(String text, VoidCallback onDelete) {
    return Row(children: [
      Expanded(
          child: Text(text,
              style: const TextStyle(color: AppColors.textPrimary))),
      IconButton(
          icon: const Icon(Icons.delete_outline, size: 20),
          onPressed: onDelete),
    ]);
  }

  Widget _addRow(TextEditingController c, String hint, TextInputType type,
      VoidCallback onAdd) {
    return Row(children: [
      Expanded(
          child: TextField(
              controller: c,
              keyboardType: type,
              decoration: InputDecoration(labelText: hint))),
      IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            onAdd();
            c.clear();
          }),
    ]);
  }
}
