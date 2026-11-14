import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:budget_assistant/core/bootstrap/app_bootstrap_flags.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/core/services/deep_link_bus.dart';
import 'package:budget_assistant/core/theme/app_theme.dart';
import 'package:budget_assistant/features/year_in_review/presentation/providers/year_in_review_providers.dart';
import 'package:budget_assistant/features/security/presentation/services/shake_detector.dart';
import 'package:budget_assistant/features/security/presentation/services/face_down_detector.dart';
import 'package:budget_assistant/features/security/presentation/services/user_activity_observer.dart';
import 'package:budget_assistant/features/settings/presentation/providers/settings_providers.dart';

class BudgetAssistantApp extends ConsumerStatefulWidget {
  const BudgetAssistantApp({super.key});

  @override
  ConsumerState<BudgetAssistantApp> createState() => _BudgetAssistantAppState();
}

class _BudgetAssistantAppState extends ConsumerState<BudgetAssistantApp> {
  /// Этап 24 (D24-10): подписка на deep-link создаётся ОДИН раз в initState.
  /// Раньше она вешалась в build() — каждый rebuild добавлял новую подписку,
  /// старые не отменялись (утечка + повторная навигация).
  StreamSubscription<dynamic>? _deepLinkSub;

  /// Стартовые задачи (deep-link холодного старта, авто-оверлей статистики)
  /// выполняются один раз за жизнь виджета, а не на каждый rebuild.
  bool _startupScheduled = false;

  @override
  void initState() {
    super.initState();
    _deepLinkSub = DeepLinkBus.instance.stream.listen((route) {
      if (!mounted) return;
      try {
        ref.read(appRouterProvider).go(route);
      } catch (e, st) {
        AppLogger.e('Deep link navigation failed', e, st);
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSecurityServices();
      _scheduleStartupTasks();
    });
  }

  @override
  void dispose() {
    _deepLinkSub?.cancel();
    ShakeDetector.instance.stop();
    FaceDownDetector.instance.stop();
    UserActivityObserver.instance.stop();
    super.dispose();
  }

  Future<void> _startSecurityServices() async {
    try {
      final s = await ref.read(appSettingsRowProvider.future);
      if (!mounted) return;
      if (s?.enableShakeToHide ?? false) {
        ShakeDetector.instance.start(ref);
      }
      if (s?.enableFaceDownHide ?? false) {
        FaceDownDetector.instance.start(ref);
      }
      UserActivityObserver.instance.start(ref);
    } catch (e, st) {
      AppLogger.e('Failed to start security services', e, st);
    }
  }

  void _scheduleStartupTasks() {
    if (_startupScheduled) return;
    _startupScheduled = true;
    try {
      final router = ref.read(appRouterProvider);
      final link = AppBootstrapFlags.pendingDeepLink;
      if (link != null && link.isNotEmpty) {
        AppBootstrapFlags.pendingDeepLink = null;
        router.go(link);
        return;
      }
      // Этап 19 (6.3.37.12): авто-оверлей статистики после 27 декабря.
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        _maybeShowYearInReview(ref, router);
      });
    } catch (e, st) {
      AppLogger.e('Startup tasks failed', e, st);
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        UserActivityObserver.instance.onUserActivity(
            ref.read(appSettingsRowProvider).value?.autoHideTimeoutSeconds ?? 0);
      },
      onPanDown: (_) {
        UserActivityObserver.instance.onUserActivity(
            ref.read(appSettingsRowProvider).value?.autoHideTimeoutSeconds ?? 0);
      },
      child: MaterialApp.router(
        title: 'Budget Assistant',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        routerConfig: router,
        builder: (context, child) {
          // Этап 22 (ТЗ 6.10.7): масштабирование текста до 2.0.
          final mq = MediaQuery.of(context);
          final scale = mq.textScaler.scale(1.0).clamp(1.0, 2.0);
          return MediaQuery(
            data: mq.copyWith(textScaler: TextScaler.linear(scale)),
            child: child!,
          );
        },
      ),
    );
  }

  Future<void> _maybeShowYearInReview(WidgetRef ref, GoRouter router) async {
    try {
      final uid = Supabase.instance.client.auth.currentUser?.id;
      if (uid == null) return;
      final year = await ref
          .read(checkYearInReviewAvailabilityUseCaseProvider)
          .call(uid);
      if (year != null) {
        router.push('/year-in-review/$year');
      }
    } catch (e, st) {
      AppLogger.e('Year in Review auto-show failed', e, st);
    }
  }
}