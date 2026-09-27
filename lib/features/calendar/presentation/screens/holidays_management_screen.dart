import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import 'package:budget_assistant/core/widgets/offline_error_card.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/holiday.dart';
import '../../domain/repositories/holidays_repository.dart';
import '../calendar_strings.dart';
import '../providers/holidays_screen_providers.dart';
import '../widgets/holiday_form_sheet.dart';

/// Экран управления праздниками (ТЗ 6.3.8): пресеты РФ read-only +
/// CRUD личных/семейных, тумблер активности, свайп-удаление.
class HolidaysManagementScreen extends ConsumerWidget {
  const HolidaysManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final presetsAsync = ref.watch(presetHolidaysProvider);
    final personalAsync = ref.watch(personalHolidaysProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(CalendarStrings.holidaysTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          MotionTokens.light();
          showHolidayFormSheet(context, ref);
        },
        backgroundColor: AppColors.colorFAB,
        child: const Icon(Icons.add),
      ),
      body: presetsAsync.when(
        loading: () => ListView(
          padding: const EdgeInsets.all(16),
          children: const [
            SkeletonShimmer(height: 60),
            SizedBox(height: 12),
            SkeletonShimmer(height: 60),
          ],
        ),
        error: (e, _) => Center(
          child: OfflineErrorCard(
            message: CalendarStrings.loadingError,
            retryLabel: CalendarStrings.retry,
            onRetry: () => ref.invalidate(presetHolidaysProvider),
          ),
        ),
        data: (presets) => personalAsync.when(
          loading: () => const Center(child: SkeletonShimmer(height: 60)),
          error: (e, _) => Center(
            child: OfflineErrorCard(
              message: CalendarStrings.loadingError,
              retryLabel: CalendarStrings.retry,
              onRetry: () => ref.invalidate(personalHolidaysProvider),
            ),
          ),
          data: (personal) => ListView(
            padding: const EdgeInsets.all(AppSpacing.spacing16),
            children: [
              Text(CalendarStrings.presetsSection,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.spacing8),
              for (final h in presets) _PresetTile(holiday: h),
              const SizedBox(height: AppSpacing.spacing24),
              Text(CalendarStrings.personalSection,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: AppSpacing.spacing8),
              const _ScopeChips(),
              const SizedBox(height: AppSpacing.spacing8),
              if (personal.isEmpty)
                const EmptyStateWidget(
                  icon: Icons.celebration_outlined,
                  title: CalendarStrings.emptyPersonal,
                  subtitle: CalendarStrings.emptyPersonalSubtitle,
                )
              else
                for (final h in personal) _PersonalTile(holiday: h),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScopeChips extends ConsumerWidget {
  const _ScopeChips();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = ref.watch(holidaysScopeProvider);
    const items = <(HolidaysScope, String)>[
      (HolidaysScope.all, CalendarStrings.scopeAll),
      (HolidaysScope.personal, CalendarStrings.scopePersonal),
      (HolidaysScope.family, CalendarStrings.scopeFamily),
    ];
    return Wrap(
      spacing: AppSpacing.spacing8,
      children: [
        for (final (value, label) in items)
          FilterChip(
            label: Text(label),
            selected: scope == value,
            onSelected: (_) {
              MotionTokens.selection();
              ref.read(holidaysScopeProvider.notifier).set(value);
            },
          ),
      ],
    );
  }
}

class _PresetTile extends ConsumerWidget {
  const _PresetTile({required this.holiday});
  final Holiday holiday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Text(holiday.iconEmoji ?? '🎉',
          style: const TextStyle(fontSize: 24)),
      title: Text(formatter.formatName(holiday.name, mode)),
      subtitle: Text(
        '${DateFormat('d MMMM', 'ru').format(holiday.date.toLocal())}'
        '${holiday.isAnnuallyRecurring ? ' · ${CalendarStrings.annually}' : ''}',
      ),
      trailing: const Icon(Icons.lock_outline, size: 16),
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(CalendarStrings.presetReadonly)),
        );
      },
    );
  }
}

class _PersonalTile extends ConsumerWidget {
  const _PersonalTile({required this.holiday});
  final Holiday holiday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final color = holiday.colorHex == null
        ? AppColors.colorWarning
        : Color(int.parse(holiday.colorHex!.substring(1), radix: 16) +
            0xFF000000);
    return Dismissible(
      key: ValueKey('holiday_${holiday.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        color: AppColors.colorExpense,
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      onDismissed: (_) async {
        MotionTokens.medium();
        await ref.read(deleteHolidayUseCaseProvider)(holiday.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text(CalendarStrings.deleted)),
          );
        }
      },
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.25),
          child: Text(holiday.iconEmoji ?? '🎉'),
        ),
        title: Text(
          formatter.formatName(holiday.name, mode),
          style: TextStyle(
            color: holiday.isEnabled ? null : AppColors.textSecondary,
            decoration:
                holiday.isEnabled ? null : TextDecoration.lineThrough,
          ),
        ),
        subtitle: Text(
          '${DateFormat('d MMMM yyyy', 'ru').format(holiday.date.toLocal())}'
          '${holiday.isAnnuallyRecurring ? ' · ${CalendarStrings.annually}' : ''}',
        ),
        trailing: Switch(
          value: holiday.isEnabled,
          onChanged: (v) {
            MotionTokens.selection();
            ref.read(toggleHolidayUseCaseProvider)(holiday.id, v);
          },
        ),
        onTap: () {
          MotionTokens.light();
          showHolidayFormSheet(context, ref, existing: holiday);
        },
      ),
    );
  }
}