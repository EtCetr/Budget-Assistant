import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/features/accounts/presentation/providers/account_providers.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/categories/presentation/providers/category_providers.dart';
import '../../../recurring_payments/domain/entities/recurring_transaction.dart';
import '../../../recurring_payments/presentation/providers/recurring_repository_providers.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/usecases/get_day_context_usecase.dart';
import 'reminders_repository_providers.dart';
import 'reminders_screen_providers.dart';

final reminderByIdProvider =
    StreamProvider.family<Reminder?, String>((ref, id) {
  return ref.watch(remindersRepositoryProvider).watchById(id);
});

/// Редактировать/удалять: создатель ИЛИ админ пространства (ТЗ 6.3.11.12.9).
final canEditReminderProvider =
    FutureProvider.family<bool, Reminder>((ref, reminder) async {
  final me = ref.watch(currentUserIdProvider);
  if (reminder.userId == me) return true;
  final spaceId = reminder.spaceId;
  if (spaceId == null) return false;
  return ref.watch(membershipsDaoRemindersProvider).isAdmin(me, spaceId);
});

final linkedCategoryNameProvider =
    FutureProvider.family<String?, String>((ref, categoryId) async {
  final userId = ref.watch(currentUserIdProvider);
  final list = await ref.watch(categoriesListProvider(userId).future);
  for (final c in list) {
    if (c.id == categoryId) return c.name;
  }
  return null;
});

final linkedAccountNameProvider =
    FutureProvider.family<String?, String>((ref, accountId) async {
  final userId = ref.watch(currentUserIdProvider);
  final list = await ref.watch(accountsListProvider(userId).future);
  for (final a in list) {
    if (a.id == accountId) return a.customName;
  }
  return null;
});

final linkedRecurringProvider = FutureProvider.family<RecurringTransaction?,
    String>((ref, recurringId) async {
  return ref
      .watch(recurringTransactionsRepositoryProvider)
      .getById(recurringId);
});

final dayContextProvider =
    FutureProvider.family<DayContext, String>((ref, dateIso) async {
  final day = DateTime.tryParse(dateIso);
  if (day == null) return const DayContext();
  return ref.watch(getDayContextUseCaseProvider)(
    day: day,
    userId: ref.watch(currentUserIdProvider),
    spaceId: ref.watch(currentSpaceIdProvider),
  );
});