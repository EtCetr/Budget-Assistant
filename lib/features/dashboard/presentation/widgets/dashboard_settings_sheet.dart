import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../features/auth/presentation/providers/current_user_provider.dart';
import '../../domain/entities/dashboard_widget_item.dart';
import '../../domain/entities/dashboard_widget_type.dart';
import '../dashboard_strings.dart';
import '../providers/dashboard_providers.dart';

class DashboardSettingsSheet extends ConsumerStatefulWidget {
  const DashboardSettingsSheet({super.key});

  @override
  ConsumerState<DashboardSettingsSheet> createState() =>
      _DashboardSettingsSheetState();
}

class _DashboardSettingsSheetState extends ConsumerState<DashboardSettingsSheet> {
  List<DashboardWidgetItem>? _local;

  Future<void> _save(List<DashboardWidgetItem> items) async {
    try {
      HapticFeedback.mediumImpact();
      final userId = ref.read(currentUserIdProvider);
      await ref.read(updateDashboardLayoutUseCaseProvider)(
        userId: userId,
        items: items,
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Не удалось сохранить раскладку')),
      );
    }
  }

  void _toggle(DashboardWidgetItem item, bool? value) {
    if (_local == null) return;

    setState(() {
      final index = _local!.indexWhere((e) => e.type == item.type);
      if (index == -1) return;

      _local![index] = item.copyWith(isVisible: value ?? false);
    });

    _save(_local!);
  }

  void _reorder(int oldIndex, int newIndex) {
    if (_local == null) return;

    setState(() {
      if (oldIndex < newIndex) newIndex -= 1;

      final item = _local!.removeAt(oldIndex);
      _local!.insert(newIndex, item);

      for (int i = 0; i < _local!.length; i++) {
        _local![i] = _local![i].copyWith(sortOrder: i);
      }
    });

    HapticFeedback.selectionClick();
    _save(_local!);
  }

  @override
  Widget build(BuildContext context) {
    final layoutAsync = ref.watch(dashboardLayoutProvider);

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return SafeArea(
          child: layoutAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(
              child: Text('Не удалось загрузить раскладку: $error'),
            ),
            data: (items) {
              _local ??= List.of(items)..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

              return Column(
                children: [
                  const SizedBox(height: AppSpacing.spacing12),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spacing12),
                  Text(
                    DashboardStrings.settingsTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.spacing12),
                  Expanded(
                    child: ReorderableListView.builder(
                      buildDefaultDragHandles: false,
                      onReorderItem: _reorder,
                      itemCount: _local!.length,
                      itemBuilder: (context, index) {
                        final item = _local![index];

                        return ReorderableDelayedDragStartListener(
                          key: ValueKey(item.type),
                          index: index,
                          child: ListTile(
                            leading: Checkbox(
                              value: item.isVisible,
                              onChanged: (value) => _toggle(item, value),
                            ),
                            title: Text(item.type.title),
                            trailing: const Icon(Icons.drag_handle),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}