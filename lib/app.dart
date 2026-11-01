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

class BudgetAssistantApp extends ConsumerWidget {
  const BudgetAssistantApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final link = AppBootstrapFlags.pendingDeepLink;
      if (link != null && link.isNotEmpty) {
        AppBootstrapFlags.pendingDeepLink = null;
        router.go(link);
        return;
      }
      // Этап 19 (6.3.37.12): авто-оверлей статистики после 27 декабря.
      Future.delayed(const Duration(seconds: 2), () {
        _maybeShowYearInReview(ref, router);
      });
    });

    // Тёплый deep-link: мгновенный переход при тапе на пуш (D18-9).
    DeepLinkBus.instance.stream.listen((route) {
      router.go(route);
    });

    return MaterialApp.router(
      title: 'Budget Assistant',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      // Тёмное оформление по умолчанию (токены дизайн-системы — тёмные).
      themeMode: ThemeMode.dark,
      routerConfig: router,
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