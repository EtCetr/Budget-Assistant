import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:budget_assistant/core/services/secure_flag_service.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/core/widgets/empty_state_widget.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/loyalty_card.dart';
import '../loyalty_cards_strings.dart';
import '../providers/loyalty_card_display_providers.dart';
import '../providers/loyalty_cards_usecase_providers.dart';
import '../widgets/barcode_widget_factory.dart';
import '../widgets/card_number_display.dart';
import '../widgets/display_bottom_hint.dart';
import '../widgets/display_top_bar.dart';
import '../widgets/hidden_mode_warning_dialog.dart';

/// Полноэкранный показ карты кассиру (ТЗ 6.3.21): WakeLock, яркость 1.0,
/// immersive-режим, временное снятие FLAG_SECURE, авто-скрытие оверлеев,
/// ориентация per-card ([LOCAL]-поле preferred_orientation).
class LoyaltyCardDisplayScreen extends ConsumerStatefulWidget {
  const LoyaltyCardDisplayScreen({super.key, required this.cardId});

  final String cardId;

  @override
  ConsumerState<LoyaltyCardDisplayScreen> createState() =>
      _LoyaltyCardDisplayScreenState();
}

class _LoyaltyCardDisplayScreenState
    extends ConsumerState<LoyaltyCardDisplayScreen>
    with WidgetsBindingObserver {
  final SecureFlagService _secureFlag = SecureFlagService();
  Timer? _hideTimer;
  bool _overlayVisible = true;
  bool _secureDisabled = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    MotionTokens.heavy();
    _startHideTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _checkHiddenMode();
      _initDisplayMode();
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    _disableDisplayMode();
    MotionTokens.medium();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Safety-net (6.3.21.2): свернули приложение — FLAG_SECURE возвращается.
    if (state == AppLifecycleState.paused && _secureDisabled) {
      _secureFlag.restoreSecureFlag();
      _secureDisabled = false;
    }
    if (state == AppLifecycleState.resumed && !_secureDisabled) {
      _secureFlag
          .temporarilyDisableSecureFlag()
          .then((was) => _secureDisabled = was);
    }
  }

  Future<void> _checkHiddenMode() async {
    if (ref.read(privacyModeProvider) != BalanceVisibilityMode.hidden) return;
    final switchNow = await HiddenModeWarningDialog.show(context);
    if (!mounted) return;
    if (switchNow == true) {
      ref
          .read(privacyModeProvider.notifier)
          .setMode(BalanceVisibilityMode.visible);
    } else {
      context.pop();
    }
  }

  Future<void> _initDisplayMode() async {
    final card =
        await ref.read(loyaltyCardDisplayProvider(widget.cardId).future);
    if (!mounted) return;
    // 1. WakeLock: экран не гаснет у кассы.
    try {
      await WakelockPlus.enable();
    } catch (_) {}
    // 2. Максимальная яркость для сканеров.
    try {
      await ScreenBrightness().setApplicationScreenBrightness(1.0);
    } catch (_) {}
    // 3. Скрываем системные панели + блокируем ориентацию (сохранённая per-card).
    try {
      await SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.immersiveSticky,
      );
      await SystemChrome.setPreferredOrientations(
        card?.preferredOrientation == 'landscape'
            ? const [
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]
            : const [DeviceOrientation.portraitUp],
      );
    } catch (_) {}
    // 4. Временно снимаем FLAG_SECURE (страховка 10 мин нативно).
    _secureDisabled = await _secureFlag.temporarilyDisableSecureFlag();
  }

  Future<void> _disableDisplayMode() async {
    try {
      await _secureFlag.restoreSecureFlag();
      _secureDisabled = false;
    } catch (_) {}
    try {
      await ScreenBrightness().resetApplicationScreenBrightness();
    } catch (_) {}
    try {
      await WakelockPlus.disable();
    } catch (_) {}
    try {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      await SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    } catch (_) {}
  }

  void _startHideTimer() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _overlayVisible = false);
    });
  }

  void _toggleOverlay() {
    MotionTokens.light();
    setState(() => _overlayVisible = !_overlayVisible);
    if (_overlayVisible) _startHideTimer();
  }

  Future<void> _toggleOrientation() async {
    MotionTokens.medium();
    final current = MediaQuery.of(context).orientation;
    final next =
        current == Orientation.portrait ? 'landscape' : 'portrait';
    try {
      await SystemChrome.setPreferredOrientations(
        next == 'landscape'
            ? const [
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]
            : const [DeviceOrientation.portraitUp],
      );
    } catch (_) {}
    await ref
        .read(updateLoyaltyCardPreferredOrientationUseCaseProvider)
        .call(cardId: widget.cardId, orientation: next);
  }

  void _openEdit() {
    final router = GoRouter.of(context);
    MotionTokens.light();
    context.pop();
    router.push('/loyalty-cards/add?id=${widget.cardId}');
  }

  Color _brandColor(LoyaltyCard card) {
    final hex = card.brandColor;
    if (hex == null || hex.length != 7) return AppColors.surfaceCard;
    final value = int.tryParse(hex.substring(1), radix: 16);
    return value == null ? AppColors.surfaceCard : Color(0xFF000000 | value);
  }

  Widget _branding(LoyaltyCard card) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(card.iconAsset ?? '💳', style: const TextStyle(fontSize: 64)),
        const SizedBox(height: AppSpacing.spacing8),
        Text(
          card.storeName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: AppSpacing.spacing4),
        Text(
          LoyaltyCardsStrings.displaySubtitle,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _content(LoyaltyCard card) {
    final formatted = ref
        .watch(formatCardNumberForDisplayUseCaseProvider)
        .call(card.cardNumber ?? card.barcodeData);
    final code = BarcodeWidgetFactory(card: card);
    return GestureDetector(
      onTap: _toggleOverlay,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: _brandColor(card),
              padding: const EdgeInsets.all(AppSpacing.spacing24),
              child: OrientationBuilder(
                builder: (context, orientation) {
                  if (orientation == Orientation.landscape) {
                    return Row(
                      children: [
                        Expanded(
                          flex: 6,
                          child: Center(child: code),
                        ),
                        Expanded(
                          flex: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _branding(card),
                              const SizedBox(height: AppSpacing.spacing24),
                              CardNumberDisplay(number: formatted, fontSize: 28),
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                  return Column(
                    children: [
                      const SizedBox(height: 56),
                      _branding(card),
                      const SizedBox(height: AppSpacing.spacing24),
                      Expanded(child: Center(child: code)),
                      const SizedBox(height: AppSpacing.spacing24),
                      CardNumberDisplay(number: formatted),
                      const SizedBox(height: 56),
                    ],
                  );
                },
              ),
            ),
          ),
          IgnorePointer(
            ignoring: !_overlayVisible,
            child: AnimatedOpacity(
              opacity: _overlayVisible ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: Align(
                alignment: Alignment.topCenter,
                child: DisplayTopBar(
                  card: card,
                  onClose: () {
                    MotionTokens.light();
                    context.pop();
                  },
                  onRotate: _toggleOrientation,
                  onEdit: _openEdit,
                ),
              ),
            ),
          ),
          IgnorePointer(
            ignoring: true,
            child: AnimatedOpacity(
              opacity: _overlayVisible ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: const Align(
                alignment: Alignment.bottomCenter,
                child: DisplayBottomHint(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _notFound() {
    return EmptyStateWidget(
      icon: Icons.credit_card_off_outlined,
      title: LoyaltyCardsStrings.displayNotFoundTitle,
      subtitle: LoyaltyCardsStrings.displayNotFoundSubtitle,
      primaryAction: EmptyStateAction(
        label: LoyaltyCardsStrings.displayBack,
        onPressed: () => context.go('/loyalty-cards'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cardAsync = ref.watch(loyaltyCardDisplayProvider(widget.cardId));
    return Scaffold(
      backgroundColor: Colors.black,
      body: cardAsync.when(
        loading: () => const ColoredBox(
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ColoredBox(
                  color: Colors.black26,
                  child: SizedBox(width: 200, height: 64),
                ),
                SizedBox(height: 16),
                ColoredBox(
                  color: Colors.black12,
                  child: SizedBox(width: 300, height: 200),
                ),
                SizedBox(height: 16),
                ColoredBox(
                  color: Colors.black26,
                  child: SizedBox(width: 260, height: 48),
                ),
              ],
            ),
          ),
        ),
        error: (_, __) => _notFound(),
        data: (card) => card == null ? _notFound() : _content(card),
      ),
    );
  }
}