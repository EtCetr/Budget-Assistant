import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import 'package:budget_assistant/core/widgets/offline_error_card.dart';
import 'package:budget_assistant/core/widgets/skeleton_shimmer.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import 'package:budget_assistant/features/security/presentation/screens/pin_entry_screen.dart';
import '../../domain/models/year_in_review_data.dart';
import '../providers/year_in_review_providers.dart';
import '../widgets/year_review_progress_bar.dart';
import '../widgets/year_review_top_bar.dart';
import '../widgets/year_review_slides/slide_01_welcome.dart';
import '../widgets/year_review_slides/slide_02_income.dart';
import '../widgets/year_review_slides/slide_03_expense.dart';
import '../widgets/year_review_slides/slide_04_top_categories.dart';
import '../widgets/year_review_slides/slide_05_most_generous_day.dart';
import '../widgets/year_review_slides/slide_06_investments.dart';
import '../widgets/year_review_slides/slide_07_savings.dart';
import '../widgets/year_review_slides/slide_08_cashback.dart';
import '../widgets/year_review_slides/slide_09_family_budget.dart';
import '../widgets/year_review_slides/slide_10_subscriptions.dart';
import '../widgets/year_review_slides/slide_11_savings_rate.dart';
import '../widgets/year_review_slides/slide_12_finale.dart';
import '../widgets/year_review_slides/slide_little_data.dart';
import '../year_review_strings.dart';

/// Экран «Итоги года» (ТЗ 6.3.37): полноэкранные сторис.
/// Автопроигрывание 7 секунд, тапы по половинам экрана, пауза по
/// долгому нажатию, шеринг текущего слайда (6.9).
class YearInReviewScreen extends ConsumerStatefulWidget {
  const YearInReviewScreen({super.key, required this.year});

  final int year;

  @override
  ConsumerState<YearInReviewScreen> createState() =>
      _YearInReviewScreenState();
}

class _YearInReviewScreenState extends ConsumerState<YearInReviewScreen>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  final GlobalKey _shareBoundaryKey = GlobalKey();
  Timer? _autoPlayTimer;
  late final AnimationController _progressController;
  bool _isPaused = false;
  int _currentIndex = 0;
  int _slidesCount = 1;

  static const Duration _slideDuration = Duration(seconds: 7);

  @override
  void initState() {
    super.initState();
    _enableImmersive();
    _progressController =
        AnimationController(vsync: this, duration: _slideDuration);
    _progressController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MotionTokens.heavy();
      _startAutoPlay();
    });
  }

  Future<void> _enableImmersive() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp]);
  }

  Future<void> _disableImmersive() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  @override
  void dispose() {
    _autoPlayTimer?.cancel();
    _progressController.dispose();
    _pageController.dispose();
    _disableImmersive();
    super.dispose();
  }

  YearReviewQuery _query(String? spaceId) =>
      YearReviewQuery(year: widget.year, spaceId: spaceId);

  void _startAutoPlay() {
    _autoPlayTimer?.cancel();
    _progressController.forward(from: 0);
    _autoPlayTimer = Timer(_slideDuration, _autoTick);
  }

  void _autoTick() {
    if (_currentIndex >= _slidesCount - 1) {
      _stopAutoPlay();
      return;
    }
    MotionTokens.light();
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _stopAutoPlay() {
    _autoPlayTimer?.cancel();
    _autoPlayTimer = null;
    _progressController.stop();
  }

  void _pause() {
    _isPaused = true;
    _autoPlayTimer?.cancel();
    _progressController.stop();
  }

  void _resume(List<YearReviewSlideType> slides) {
    _isPaused = false;
    if (_currentIndex < slides.length - 1) {
      _startAutoPlay();
    }
  }

  void _next(List<YearReviewSlideType> slides) {
    if (_currentIndex >= slides.length - 1) {
      _stopAutoPlay();
      return;
    }
    MotionTokens.light();
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _prev() {
    if (_currentIndex <= 0) return;
    MotionTokens.light();
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _markViewed() async {
    try {
      final uid = ref.read(currentUserIdProvider);
      final spaceId = ref.read(yearReviewSpaceProvider);
      await ref.read(markYearInReviewAsViewedUseCaseProvider)(
        userId: uid,
        year: widget.year,
        spaceId: spaceId,
      );
    } catch (_) {
      // Не критично: оверлей просто покажется ещё раз.
    }
  }

  Future<void> _closeToProfile() async {
    MotionTokens.light();
    await _markViewed();
    if (!mounted) return;
    context.go('/profile');
  }
  Future<void> _goHome() async {
    MotionTokens.light();
    await _markViewed();
    if (!mounted) return;
    context.go('/');
  }

  /// Шеринг текущего слайда (ТЗ 6.9.9.2): privacy -> PIN -> FLAG_SECURE ->
  /// PNG -> Share Sheet -> аудит-лог (внутри UseCase).
  Future<void> _share() async {
    MotionTokens.medium();
    final mode = ref.read(privacyModeProvider);
    final messenger = ScaffoldMessenger.of(context);
    if (mode == BalanceVisibilityMode.hidden) {
      messenger.showSnackBar(const SnackBar(
          content: Text(YearReviewStrings.shareBlockedHidden)));
      return;
    }
    try {
      final settings = await ref.read(yearReviewSettingsProvider.future);
      if (!mounted) return;
      if (settings != null &&
          settings.requirePinForSensitive &&
          settings.enablePinCode) {
        final ok = await Navigator.of(context).push<bool>(
          MaterialPageRoute(
              builder: (_) => const PinEntryScreen(mode: 'verify')),
        );
        if (ok != true) {
          messenger.showSnackBar(const SnackBar(
              content: Text(YearReviewStrings.shareCancelledPin)));
          return;
        }
      }
      final secureFlagOn = settings?.enableScreenCaptureProtection ?? false;
      if (secureFlagOn && mounted) {
        messenger.showSnackBar(const SnackBar(
            content: Text(YearReviewStrings.secureFlagNotice)));
      }
      final spaceId = ref.read(yearReviewSpaceProvider);
      final uid = ref.read(currentUserIdProvider);
      await ref.read(shareYearInReviewSlideUseCaseProvider)(
        year: widget.year,
        slideIndex: _currentIndex,
        spaceId: spaceId,
        actorId: uid,
        boundaryKey: _shareBoundaryKey,
        screenCaptureProtection: secureFlagOn,
      );
      MotionTokens.heavy();
    } catch (e) {
      MotionTokens.error();
      messenger.showSnackBar(SnackBar(
          content: Text('${YearReviewStrings.shareError}: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final spaceId = ref.watch(yearReviewSpaceProvider);
    final query = _query(spaceId);
    final dataAsync = ref.watch(yearInReviewDataProvider(query));
    final slides = ref.watch(yearReviewSlidesProvider(query));
    final mode = ref.watch(privacyModeProvider);
    final pf = ref.watch(privacyFormatterProvider);
    final canShare = ref.watch(yearReviewCanShareProvider);

    // Данные досчитались на лету — перезапускаем автоплей.
    ref.listen(yearInReviewDataProvider(query), (prev, next) {
      if (next.hasValue && !_isPaused) {
        _startAutoPlay();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      body: dataAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SkeletonShimmer(width: 200, height: 200),
              SizedBox(height: 24),
              Text(YearReviewStrings.calculating,
                  style: TextStyle(color: AppColors.textSecondary)),
            ],
          ),
        ),
        error: (e, _) => Center(
          child: OfflineErrorCard(
            message: YearReviewStrings.loadingError,
            retryLabel: YearReviewStrings.retry,
            onRetry: () =>
                ref.invalidate(yearInReviewDataProvider(query)),
          ),
        ),
        data: (data) {
          if (data == null || data.transactionCount == 0) {
            return _buildNoData();
          }
          _slidesCount = slides.length;
          return _buildStory(slides, data, pf, mode, canShare);
        },
      ),
    );
  }

  /// Empty State 2: нет данных вообще.
  Widget _buildNoData() {
    return Stack(
      children: [
        EmptyStateWidget(
          icon: Icons.auto_awesome_outlined,
          title: YearReviewStrings.noDataTitle,
          subtitle: YearReviewStrings.noDataSubtitle,
          primaryAction: EmptyStateAction(
            label: YearReviewStrings.addFirstTx,
            onPressed: () => context.go('/transactions'),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: YearReviewTopBar(
            canShare: false,
            onClose: () async {
              await _markViewed();
              if (mounted) context.go('/profile');
            },
            onShare: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildStory(
    List<YearReviewSlideType> slides,
    YearInReviewData data,
    dynamic pf,
    BalanceVisibilityMode mode,
    bool canShare,
  ) {
    return Stack(
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: (details) {
            final width = MediaQuery.of(context).size.width;
            if (details.localPosition.dx > width / 2) {
              _next(slides);
            } else {
              _prev();
            }
          },
          onLongPressStart: (_) => _pause(),
          onLongPressEnd: (_) => _resume(slides),
          child: PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            onPageChanged: (i) {
              setState(() => _currentIndex = i);
              MotionTokens.selection();
              if (i >= slides.length - 1) {
                _stopAutoPlay();
              } else if (!_isPaused) {
                _startAutoPlay();
              }
            },
            itemBuilder: (context, index) {
              final slide = _buildSlide(slides[index], data, pf, mode, slides);
              return RepaintBoundary(
                // Ключ шеринга — только на текущем слайде.
                key: index == _currentIndex
                    ? _shareBoundaryKey
                    : ValueKey('year_review_slide_$index'),
                child: slide,
              );
            },
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 8),
                  child: YearReviewProgressBar(
                    total: slides.length,
                    current: _currentIndex,
                    progress: _progressController.value,
                  ),
                ),
                YearReviewTopBar(
                  canShare: canShare,
                  onClose: _closeToProfile,
                  onShare: _share,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlide(
    YearReviewSlideType type,
    YearInReviewData data,
    dynamic pf,
    BalanceVisibilityMode mode,
    List<YearReviewSlideType> slides,
  ) {
    switch (type) {
      case YearReviewSlideType.welcome:
        return SlideWelcome(year: widget.year, onNext: () => _next(slides));
      case YearReviewSlideType.income:
        return SlideIncome(data: data, pf: pf, mode: mode);
      case YearReviewSlideType.expense:
        return SlideExpense(data: data, pf: pf, mode: mode);
      case YearReviewSlideType.topCategories:
        return SlideTopCategories(data: data, pf: pf, mode: mode);
      case YearReviewSlideType.generousDay:
        return SlideGenerousDay(data: data, pf: pf, mode: mode);
      case YearReviewSlideType.investments:
        return SlideInvestments(data: data, pf: pf, mode: mode);
      case YearReviewSlideType.savings:
        return SlideSavings(data: data, pf: pf, mode: mode);
      case YearReviewSlideType.cashback:
        return SlideCashback(data: data, pf: pf, mode: mode);
      case YearReviewSlideType.family:
        return SlideFamilyBudget(data: data, pf: pf, mode: mode);
      case YearReviewSlideType.subscriptions:
        return SlideSubscriptions(data: data, pf: pf, mode: mode);
      case YearReviewSlideType.savingsRate:
        return SlideSavingsRate(data: data);
      case YearReviewSlideType.finale:
        return SlideFinale(
            year: widget.year, onShare: _share, onHome: _goHome);
      case YearReviewSlideType.littleData:
        return SlideLittleData(data: data);
    }
  }
}