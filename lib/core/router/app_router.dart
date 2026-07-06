import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:budget_assistant/features/auth/domain/notifiers/auth_notifier.dart'; // <--- КРИТИЧНЫЙ ИМПОРТ
import 'package:budget_assistant/features/home/presentation/screens/home_screen.dart';
import 'package:budget_assistant/features/onboarding/presentation/widgets/onboarding_wrapper.dart';
import 'package:budget_assistant/features/auth/presentation/screens/auth_wrapper.dart';
import 'package:budget_assistant/features/spaces/presentation/screens/space_selector_screen.dart';
import 'package:budget_assistant/features/security/presentation/screens/app_lock_screen.dart';
import 'package:budget_assistant/features/invites/presentation/screens/accept_invite_screen.dart';
import 'package:budget_assistant/core/router/routes.dart';
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
  String build() => 'not_started';

  void complete() => state = 'completed';
  void setStatus(String status) => state = status;
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
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
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
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final isAppLocked = ref.read(appLockProvider);
      final location = state.uri.path;

      if (isAppLocked && location != AppRoutes.lock) {
        return AppRoutes.lock;
      }

      if (authStatus == AuthStatus.unauthenticated) {
        if (!location.startsWith(AppRoutes.auth) &&
            !location.startsWith(AppRoutes.invite)) {
          return AppRoutes.auth;
        }
      }

      if (authStatus == AuthStatus.authenticated) {
        if (location.startsWith(AppRoutes.auth)) {
          final onboardingCompleted =
              ref.read(onboardingStatusProvider) == 'completed';
          if (!onboardingCompleted) {
            return AppRoutes.onboarding;
          }
          return AppRoutes.home;
        }
      }

      return null;
    },
  );
}
