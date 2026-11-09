// lib/features/receipts/presentation/screens/product_aliases_settings_screen.dart
// Этап 21 (ТЗ 6.3.38.6): управление алиасами товаров.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import 'package:budget_assistant/features/receipts/presentation/providers/product_aliases_settings_providers.dart';

class ProductAliasesSettingsScreen extends ConsumerStatefulWidget {
  const ProductAliasesSettingsScreen({super.key});

  @override
  ConsumerState<ProductAliasesSettingsScreen> createState() =>
      _ProductAliasesSettingsScreenState();
}

class _ProductAliasesSettingsScreenState
    extends ConsumerState<ProductAliasesSettingsScreen> {
  String _mode = 'all';

  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final aliasesAsync = ref.watch(productAliasesProvider(_mode));
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceBackground,
        title: const Text('Алиасы товаров'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'all', label: Text('Все')),
                ButtonSegment(value: 'mine', label: Text('Только мои')),
                ButtonSegment(value: 'family', label: Text('Семейные')),
              ],
              selected: {_mode},
              onSelectionChanged: (s) {
                HapticFeedback.selectionClick();
                setState(() => _mode = s.first);
              },
            ),
          ),
          Expanded(
            child: aliasesAsync.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, st) => const Center(
                child: Text(
                  'Не удалось загрузить алиасы',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              data: (rows) {
                if (rows.isEmpty) {
                  return const Center(
                    child: Text(
                      'Алиасов пока нет.\nОни появятся после именования товаров в чеках.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: rows.length,
                  itemBuilder: (context, i) {
                    final a = rows[i];
                    return ListTile(
                      title: Text(
                        formatter.formatProductName(a.normalizedName, mode),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        'Использований: ${a.usageCount}',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _editDialog(a);
                      },
                      onLongPress: () {
                        HapticFeedback.mediumImpact();
                        _deleteDialog(a);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _editDialog(ProductAliasDb alias) async {
    final categories =
        ref.read(aliasCategoriesProvider).value ?? const <Category>[];
    final controller = TextEditingController(text: alias.normalizedName);
    var categoryId = alias.categoryId;
    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setStateDialog) => AlertDialog(
          backgroundColor: AppColors.surfaceCard,
          title: const Text('✏️ Редактировать алиас'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(labelText: 'Название'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: categoryId,
                decoration: const InputDecoration(labelText: 'Категория'),
                items: [
                  for (final c in categories)
                    DropdownMenuItem(value: c.id, child: Text(c.name)),
                ],
                onChanged: (v) => setStateDialog(() => categoryId = v!),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Отмена'),
            ),
            FilledButton(
              onPressed: () async {
                HapticFeedback.mediumImpact();
                try {
                  await ref.read(updateProductAliasUseCaseProvider).call(
                    id: alias.id,
                    normalizedName: controller.text,
                    categoryId: categoryId,
                  );
                  if (ctx.mounted) Navigator.pop(ctx);
                } catch (e) {
                  if (ctx.mounted) {
                    ScaffoldMessenger.of(ctx).showSnackBar(
                      SnackBar(content: Text('❌ Ошибка сохранения: $e')),
                    );
                  }
                }
              },
              child: const Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
    controller.dispose();
  }

  Future<void> _deleteDialog(ProductAliasDb alias) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: const Text('🗑️ Удалить алиас?'),
        content: Text(
          '«${alias.normalizedName}» перестанет связываться с категорией. '
          'История покупок останется.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Отмена'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    HapticFeedback.heavyImpact();
    try {
      await ref.read(deleteProductAliasUseCaseProvider).call(alias.id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('❌ Ошибка удаления: $e')),
        );
      }
    }
  }
}