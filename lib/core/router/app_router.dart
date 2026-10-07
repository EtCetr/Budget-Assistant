import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:budget_assistant/features/auth/domain/notifiers/auth_notifier.dart';
import 'package:budget_assistant/features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:budget_assistant/features/onboarding/presentation/widgets/onboarding_wrapper.dart';
import 'package:budget_assistant/features/auth/presentation/screens/auth_wrapper.dart';
import 'package:budget_assistant/features/spaces/presentation/screens/space_selector_screen.dart';
import 'package:budget_assistant/features/security/presentation/screens/app_lock_screen.dart';
import 'package:budget_assistant/features/invites/presentation/screens/accept_invite_screen.dart';
import 'package:budget_assistant/features/security/presentation/screens/pin_onboarding_screen.dart';
import 'package:budget_assistant/features/security/presentation/screens/pin_entry_screen.dart';
import 'package:budget_assistant/features/security/presentation/screens/biometric_onboarding_screen.dart';
import 'package:budget_assistant/core/router/routes.dart';
import 'package:budget_assistant/features/import/domain/entities/import_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:budget_assistant/features/accounts/presentation/screens/accounts_screen.dart';
import 'package:budget_assistant/features/categories/presentation/screens/categories_screen.dart';
import 'package:budget_assistant/core/bootstrap/app_bootstrap_flags.dart';
import 'package:budget_assistant/core/services/secure_storage_service.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/features/transactions/presentation/screens/transactions_log_screen.dart';
import 'package:budget_assistant/features/import/presentation/screens/import_onboarding_screen.dart';
import 'package:budget_assistant/features/import/presentation/screens/post_import_review_screen.dart';
import 'package:budget_assistant/features/import/presentation/screens/import_secrets_screen.dart';
import 'package:budget_assistant/features/import/domain/entities/import_secrecy_handoff.dart';
import 'package:budget_assistant/features/transactions/presentation/screens/create_transaction_screen.dart';
import 'package:budget_assistant/features/transactions/presentation/screens/edit_transaction_screen.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/budget/presentation/screens/budget_limits_screen.dart';
import 'package:budget_assistant/features/profile/presentation/screens/profile_screen.dart';
import 'package:budget_assistant/features/budget/presentation/screens/edit_budget_limit_screen.dart';
import 'package:budget_assistant/features/cashback/presentation/screens/cashback_screen.dart';
import 'package:budget_assistant/features/savings_goals/presentation/providers/savings_goals_screen_providers.dart';
import 'package:budget_assistant/features/savings_goals/presentation/screens/create_savings_goal_screen.dart';
import 'package:budget_assistant/features/savings_goals/presentation/screens/savings_goals_screen.dart';
import 'package:budget_assistant/features/savings_goals/presentation/screens/savings_analytics_screen.dart';
import 'package:budget_assistant/features/debts/presentation/screens/debts_screen.dart';
import 'package:budget_assistant/features/debts/presentation/screens/create_debt_screen.dart';
import 'package:budget_assistant/features/transactions/presentation/screens/split_transaction_screen.dart';
import 'package:budget_assistant/features/reminders/presentation/screens/reminders_screen.dart';
import 'package:budget_assistant/features/reminders/presentation/screens/reminder_details_screen.dart';
import 'package:budget_assistant/features/reminders/presentation/screens/create_reminder_screen.dart';
import 'package:budget_assistant/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:budget_assistant/features/calendar/presentation/screens/day_statistics_screen.dart';
import 'package:budget_assistant/features/calendar/presentation/screens/date_forecast_screen.dart';
import 'package:budget_assistant/features/calendar/presentation/screens/holidays_management_screen.dart';
import 'package:budget_assistant/features/recurring_payments/presentation/screens/recurring_payments_detection_screen.dart';
import 'package:budget_assistant/features/receipts/presentation/screens/scan_receipt_screen.dart';
import 'package:budget_assistant/features/receipts/presentation/screens/receipt_preview_screen.dart';
import 'package:budget_assistant/features/receipts/presentation/screens/split_receipt_screen.dart';
part 'app_router.g.dart';

@riverpod
class AppLock extends _$AppLock {
  @override
  bool build() => false;
  void lock() => state = true;
  void unlock() => state = false;
}

@riverpod
class OnboardingStatus extends _$OnboardingStatus {
  @override
  String build() => AppBootstrapFlags.onboardingStatus;
  void complete() {
    state = 'completed';
    AppBootstrapFlags.onboardingStatus = 'completed';
    _persist();
  }

  void setStatus(String status) {
    state = status;
    AppBootstrapFlags.onboardingStatus = status;
    _persist();
  }

  Future<void> _persist() async {
    try {
      await SecureStorageService().write(
        'onboarding_completed',
        state == 'completed' ? 'true' : 'false',
      );
    } catch (e, st) {
      AppLogger.e('Failed to persist onboarding flag', e, st);
    }
  }
}

@riverpod
class CurrentSpaceId extends _$CurrentSpaceId {
  @override
  String? build() => null;
  void setSpaceId(String? id) => state = id;
  void clear() => state = null;
}

@riverpod
class PendingInviteToken extends _$PendingInviteToken {
  @override
  String? build() => null;
  void setToken(String? token) => state = token;
  void clear() => state = null;
}

class _AuthRefreshNotifier extends ChangeNotifier {
  late final ProviderSubscription _sub;
  _AuthRefreshNotifier(Ref ref) {
    _sub = ref.listen(authProvider, (_, __) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}

@riverpod
GoRouter appRouter(Ref ref) {
  final authStatus = ref.watch(authProvider);
  final refreshNotifier = _AuthRefreshNotifier(ref);
  ref.onDispose(() {
    refreshNotifier.dispose();
  });
  return GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    refreshListenable: refreshNotifier,
    routes: [
      GoRoute(
        path: '/debts',
        name: 'debts',
        builder: (context, state) => const DebtsScreen(),
      ),
      GoRoute(
        path: '/debts/create',
        name: 'create-debt',
        builder: (context, state) {
          final q = state.uri.queryParameters;
          return CreateDebtScreen(
            debtId: q['id'],
            transactionId: q['transaction_id'],
            splitId: q['split_id'],
          );
        },
      ),
      GoRoute(
        path: '/transactions/split/:id',
        name: 'split-transaction',
        builder: (context, state) => SplitTransactionScreen(
          transactionId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingWrapper(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        name: 'auth',
        builder: (context, state) => const AuthWrapper(),
      ),
      GoRoute(
        path: AppRoutes.spaceSelector,
        name: 'space_selector',
        builder: (context, state) => const SpaceSelectorScreen(),
      ),
      GoRoute(
        path: AppRoutes.lock,
        name: 'lock',
        builder: (context, state) => const AppLockScreen(),
      ),
      GoRoute(
        path: '${AppRoutes.invite}/accept',
        name: 'accept_invite',
        builder: (context, state) {
          final token = state.uri.queryParameters['token'];
          return AcceptInviteScreen(token: token);
        },
      ),
      GoRoute(
        path: '/security/pin-onboarding',
        name: 'pin_onboarding',
        builder: (context, state) => const PinOnboardingScreen(),
      ),
      GoRoute(
        path: '/security/pin-entry',
        name: 'pin_entry',
        builder: (context, state) => const PinEntryScreen(),
      ),
      GoRoute(
        path: '/security/biometric-onboarding',
        name: 'biometric_onboarding',
        builder: (context, state) => const BiometricOnboardingScreen(),
      ),
      GoRoute(
        path: '/accounts',
        name: 'accounts',
        builder: (context, state) => AccountsScreen(
          userId: Supabase.instance.client.auth.currentUser?.id ?? '',
        ),
      ),
      GoRoute(
        path: '/categories',
        name: 'categories',
        builder: (context, state) => CategoriesScreen(
          userId: Supabase.instance.client.auth.currentUser?.id ?? '',
        ),
      ),
      GoRoute(
        path: '/transactions',
        builder: (context, state) => const TransactionsLogScreen(),
      ),
      GoRoute(
        path: '/import/onboarding',
        name: 'import-onboarding',
        builder: (context, state) => const ImportOnboardingScreen(),
    ),
    GoRoute(
      path: '/import/review',
      name: 'import-review',
      builder: (context, state) => PostImportReviewScreen(result: state.extra is ImportResult ? state.extra as ImportResult : null),
    ),
    GoRoute(
      path: '/import/secrets',
      name: 'import-secrets',
      builder: (context, state) => ImportSecretsScreen(handoff: state.extra is ImportSecrecyHandoff ? state.extra as ImportSecrecyHandoff : null),
      ),
      GoRoute(
        path: '/transactions/create',
        name: 'create-transaction',
        builder: (context, state) {
          final q = state.uri.queryParameters;
          final typeStr = q['type'] ?? 'expense';
          final type = TransactionType.values.firstWhere(
            (t) => t.name == typeStr,
            orElse: () => TransactionType.expense,
          );
          // Этап 14 (ТЗ 6.3.11.7): предзаполнение из напоминания +
          // авто-завершение напоминания после сохранения транзакции.
          return CreateTransactionScreen(
            type: type,
            reminderId: q['reminder_id'],
            dateIso: q['date'],
          );
        },
      ),
      GoRoute(
        path: '/transactions/edit/:id',
        name: 'edit-transaction',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          if (id == null || id.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('ID транзакции не указан')),
            );
          }
          return EditTransactionScreen(transactionId: id);
        },
      ),
      GoRoute(
        path: '/budget',
        name: 'budget',
        builder: (context, state) => const BudgetLimitsScreen(),
      ),
      GoRoute(
        path: '/budget/create',
        name: 'create-budget-limit',
        builder: (context, state) => const EditBudgetLimitScreen(),
      ),
      GoRoute(
        path: '/budget/edit/:id',
        name: 'edit-budget-limit',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          if (id == null || id.isEmpty) {
            return const Scaffold(
              body: Center(child: Text('ID лимита не указан')),
            );
          }
          return EditBudgetLimitScreen(limitId: id);
        },
      ),
      GoRoute(
        path: '/cashback',
        name: 'cashback',
        builder: (context, state) => const CashbackScreen(),
      ),
      GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    // Этап 12: цели накопления
      GoRoute(
        path: '/savings-goals',
        name: 'savings-goals',
        builder: (context, state) => const SavingsGoalsScreen(),
      ),
      GoRoute(
        path: '/savings-goals/archive',
        name: 'savings-goals-archive',
        builder: (context, state) => const SavingsGoalsScreen(
          initialTab: SavingsGoalsTab.archive,
        ),
      ),
      GoRoute(
        path: '/savings-goals/create',
        name: 'create-savings-goal',
        builder: (context, state) {
          final goalId = state.uri.queryParameters['id'];
          return CreateSavingsGoalScreen(goalId: goalId);
        },
      ),
      GoRoute(
        path: '/savings-analytics',
        name: 'savings-analytics',
        builder: (context, state) => const SavingsAnalyticsScreen(),
      ),
      // Этап 14: напоминания
      GoRoute(
        path: '/reminders',
        name: 'reminders',
        builder: (context, state) => const RemindersScreen(),
      ),
      GoRoute(
        path: '/reminders/create',
        name: 'create-reminder',
        builder: (context, state) {
          final q = state.uri.queryParameters;
          return CreateReminderScreen(
            editReminderId: q['id'],
            type: q['type'],
            dateIso: q['date'],
            copyFromReminderId: q['reminder_id'],
          );
        },
      ),
      GoRoute(
        path: '/reminders/:id',
        name: 'reminder-details',
        builder: (context, state) => ReminderDetailsScreen(
          reminderId: state.pathParameters['id']!,
        ),
      ),
      // Этап 14: календарная группа
      GoRoute(
        path: '/calendar',
        name: 'calendar',
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: '/calendar/day',
        name: 'calendar-day',
        builder: (context, state) => DayStatisticsScreen(
          dateIso: state.uri.queryParameters['date'] ??
              DateTime.now().toIso8601String(),
        ),
      ),
      GoRoute(
        path: '/calendar/forecast',
        name: 'calendar-forecast',
        builder: (context, state) => DateForecastScreen(
          initialDateIso: state.uri.queryParameters['date'],
        ),
      ),
      GoRoute(
        path: '/calendar/holidays',
        name: 'calendar-holidays',
        builder: (context, state) => const HolidaysManagementScreen(),
      ),
      // Этап 14: детекция регулярных платежей
      GoRoute(
        path: '/recurring-payments-detection',
        name: 'recurring-detection',
        builder: (context, state) =>
            const RecurringPaymentsDetectionScreen(),
      ),
GoRoute(
path: '/receipts/scan',
name: 'receipts-scan',
builder: (context, state) {
final q = state.uri.queryParameters;
return ScanReceiptScreen(transactionId: q['transaction_id']);
},
),
GoRoute(
path: '/receipts/:id/preview',
name: 'receipt-preview',
builder: (context, state) => ReceiptPreviewScreen(
receiptId: state.pathParameters['id']!,
transactionId: state.uri.queryParameters['transaction_id'],
),
),
GoRoute(
path: '/receipts/:id/split',
name: 'receipt-split',
builder: (context, state) =>
SplitReceiptScreen(receiptId: state.pathParameters['id']!),
),
    ],
    redirect: (context, state) {
      final location = state.uri.toString();
      final isAppLocked = ref.read(appLockProvider);
      final onboardingCompleted =
          ref.read(onboardingStatusProvider) == 'completed';
      if (isAppLocked && location != AppRoutes.lock) {
        return AppRoutes.lock;
      }
      if (authStatus == AuthStatus.unauthenticated) {
        if (!location.startsWith(AppRoutes.auth) &&
            !location.startsWith(AppRoutes.invite)) {
          return AppRoutes.auth;
        }
        return null;
      }
      if (authStatus == AuthStatus.authenticated) {
        if (!onboardingCompleted &&
            !location.startsWith(AppRoutes.onboarding) &&
            !location.startsWith('/security/')) {
          return AppRoutes.onboarding;
        }
        if (onboardingCompleted && location.startsWith(AppRoutes.auth)) {
          return AppRoutes.home;
        }
      }
      return null;
    },
  );
}