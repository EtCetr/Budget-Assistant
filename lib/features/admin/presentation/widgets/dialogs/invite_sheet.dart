import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/features/admin/domain/entities/admin_entities.dart';
import 'package:budget_assistant/features/admin/presentation/providers/admin_providers.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';

/// Bottom sheet приглашения (D17-1: Email disabled до Этапа 25).
/// Privacy-matrix: в hidden QR/ссылка скрываются.
/// Роль вшита в токен (поле r): смена роли сбрасывает текущий инвайт,
/// чтобы ссылка/QR всегда соответствовали выбранной роли.
class InviteSheet extends ConsumerStatefulWidget {
  const InviteSheet({super.key, required this.spaceId});

  final String spaceId;

  @override
  ConsumerState<InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends ConsumerState<InviteSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  Timer? _countdown;
  MemberRole _role = MemberRole.member;
  bool _busy = false;
  InvitationInfo? _invite;
  String? _error;
  int _secondsLeft = 0;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _countdown?.cancel();
    _tab.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    final scope = ref.read(adminScopeProvider);
    if (scope == null) {
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
      _invite = null;
    });
    try {
      final inv = await ref.read(generateInviteUseCaseProvider).call(
          spaceId: scope.spaceId, actorId: scope.userId, role: _role);
      if (mounted) {
        setState(() => _invite = inv);
      }
      _startCountdown(inv);
      ref.invalidate(invitationsStreamProvider(scope.spaceId));
    } catch (e, st) {
      AppLogger.e('InviteSheet generate failed', e, st);
      if (mounted) {
        setState(() => _error = '$e');
      }
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  void _startCountdown(InvitationInfo inv) {
    _countdown?.cancel();
    final expiresAt = inv.expiresAt;
    _countdown = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) {
        return;
      }
      final secs = expiresAt.difference(DateTime.now()).inSeconds;
      if (secs <= 0) {
        _countdown?.cancel();
        setState(() {
          _invite = null;
          _secondsLeft = 0;
        });
        return;
      }
      if (secs != _secondsLeft) {
        setState(() => _secondsLeft = secs);
      }
    });
    setState(() {
      _secondsLeft = expiresAt.difference(DateTime.now()).inSeconds;
    });
  }

  String _formatCountdown(int secs) {
    final h = (secs ~/ 3600).toString().padLeft(2, '0');
    final m = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (secs % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final hidden =
        ref.watch(privacyModeProvider) == BalanceVisibilityMode.hidden;
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.75,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (ctx, controller) => Container(
        decoration: const BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: ListView(
          controller: controller,
          padding: const EdgeInsets.all(AppSpacing.spacing16),
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: const BoxDecoration(
                  color: AppColors.borderDivider,
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.spacing16),
            const Text('Пригласить участника',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.spacing16),
            const Text('Роль приглашённого',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            SegmentedButton<MemberRole>(
              segments: const [
                ButtonSegment(value: MemberRole.member, label: Text('Участник')),
                ButtonSegment(value: MemberRole.admin, label: Text('Админ')),
              ],
              selected: {_role},
              onSelectionChanged: (s) {
                _countdown?.cancel();
                setState(() {
                  _role = s.first;
                  _invite = null;
                  _secondsLeft = 0;
                  _error = null;
                });
              },
            ),
            const SizedBox(height: AppSpacing.spacing16),
            if (_invite != null) ...[
              Container(
                padding: const EdgeInsets.all(AppSpacing.spacing8),
                decoration: BoxDecoration(
                  color: AppColors.colorFAB.withValues(alpha: 0.12),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _role == MemberRole.admin
                          ? Icons.admin_panel_settings
                          : Icons.person,
                      size: 16,
                      color: AppColors.colorFAB,
                    ),
                    const SizedBox(width: AppSpacing.spacing8),
                    Text('Ссылка для роли: ${_role.label}',
                        style: const TextStyle(
                            color: AppColors.colorFAB, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.spacing8),
              Text('Срок действия: ${_formatCountdown(_secondsLeft)}',
                  style: TextStyle(
                    color: _secondsLeft < 600
                        ? AppColors.colorExpense
                        : AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  )),
              const SizedBox(height: AppSpacing.spacing8),
            ],
            TabBar(
              controller: _tab,
              labelColor: AppColors.colorFAB,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.colorFAB,
              tabs: const [
                Tab(text: 'QR-код'),
                Tab(text: 'Ссылка'),
                Tab(text: 'Email'),
              ],
            ),
            SizedBox(
              height: 320,
              child: TabBarView(
                controller: _tab,
                children: [_qrTab(hidden), _linkTab(hidden), _emailTab()],
              ),
            ),
            const SizedBox(height: AppSpacing.spacing16),
            if (_error != null)
              Text(_error!,
                  style: const TextStyle(color: AppColors.colorExpense),
                  textAlign: TextAlign.center),
            FilledButton(
              onPressed: _busy ? null : _generate,
              child: _busy
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : Text(_invite == null
                      ? 'Сгенерировать приглашение'
                      : 'Обновить'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qrTab(bool hidden) {
    if (hidden) {
      return const Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.visibility_off, size: 48, color: AppColors.textSecondary),
          SizedBox(height: AppSpacing.spacing12),
          Text('QR-код скрыт (режим конфиденциальности)',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary)),
        ]),
      );
    }
    if (_invite == null) {
      return const Center(
        child: Text('Сначала сгенерируйте',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    return Center(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.spacing8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: QrImageView(
              data: _invite!.deepLink,
              version: QrVersions.auto,
              size: 200,
              backgroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _linkTab(bool hidden) {
    if (hidden) {
      return const Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.visibility_off, size: 48, color: AppColors.textSecondary),
          SizedBox(height: AppSpacing.spacing12),
          Text('Ссылка скрыта (режим конфиденциальности)',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary)),
        ]),
      );
    }
    if (_invite == null) {
      return const Center(
        child: Text('Сначала сгенерируйте',
            style: TextStyle(color: AppColors.textSecondary)),
      );
    }
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.spacing12),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.all(color: AppColors.borderDivider),
          ),
          child: Text(_invite!.deepLink,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 12)),
        ),
        const SizedBox(height: AppSpacing.spacing12),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _invite!.deepLink));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Ссылка скопирована'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.copy, size: 18),
                label: const Text('Копировать'),
              ),
            ),
            const SizedBox(width: AppSpacing.spacing12),
            Expanded(
              child: FilledButton.icon(
                onPressed: () => SharePlus.instance
                    .share(ShareParams(text: _invite!.deepLink)),
                icon: const Icon(Icons.share, size: 18),
                label: const Text('Поделиться'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _emailTab() => const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.lock_outline, size: 48, color: AppColors.textSecondary),
            SizedBox(height: AppSpacing.spacing12),
            Text('Email-приглашения',
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600)),
            SizedBox(height: AppSpacing.spacing8),
            Text('Будет доступно после подключения облака (Этап 25)',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          ],
        ),
      );
}