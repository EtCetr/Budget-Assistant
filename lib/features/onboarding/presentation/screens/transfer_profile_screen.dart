import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/providers/transfer_profile_provider.dart';
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/core/router/routes.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/import/domain/entities/transfer_profile.dart';
import 'package:budget_assistant/features/onboarding/domain/notifiers/onboarding_notifier.dart';

/// Шаг онбординга: телефоны и ФИО для детекции переводов себе при импорте.
/// Необязательно: можно пропустить и заполнить позже в Профиле.
/// Хранится только локально (не синхронизируется).
class TransferProfileScreen extends ConsumerStatefulWidget {
  const TransferProfileScreen({super.key});
  @override
  ConsumerState<TransferProfileScreen> createState() =>
      _TransferProfileScreenState();
}

class _TransferProfileScreenState extends ConsumerState<TransferProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final List<String> _phones = [];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _finish({required bool save}) async {
    if (save) {
      final name = _nameController.text.trim();
      final phone = _phoneController.text.trim();
      final phones = [..._phones];
      if (phone.isNotEmpty) {
        phones.add(phone);
      }
      await ref.read(transferProfileProvider.notifier).save(TransferProfile(
            myPhones: phones,
            myNames: name.isEmpty ? const [] : [name],
            familyAsTransfers: false,
            families: const [],
          ));
    }
    if (!mounted) return;
    ref.read(onboardingStatusProvider.notifier).complete();
    ref.read(onboardingProvider.notifier).completeOnboarding();
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Данные для детекции переводов')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const Text(
              'Чтобы при импорте банковских выписок переводы между вашими '
              'счетами распознавались автоматически, укажите телефоны ваших '
              'карт и полное ФИО. Это необязательно: можно пропустить сейчас '
              'и заполнить позже в Профиле. Данные хранятся только на устройстве.',
              style: TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Фамилия Имя Отчество',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Телефон карты',
                      prefixIcon: Icon(Icons.phone_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    final p = _phoneController.text.trim();
                    if (p.isEmpty) return;
                    setState(() {
                      _phones.add(p);
                      _phoneController.clear();
                    });
                  },
                ),
              ],
            ),
            for (final p in _phones)
              Row(
                children: [
                  Expanded(
                    child: Text(p,
                        style: const TextStyle(color: AppColors.textPrimary)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => setState(() => _phones.remove(p)),
                  ),
                ],
              ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => _finish(save: false),
              child: const Text('Пропустить'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => _finish(save: true),
              child: const Text('Сохранить и продолжить'),
            ),
          ],
        ),
      ),
    );
  }
}