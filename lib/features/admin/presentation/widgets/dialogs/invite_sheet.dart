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

/// Bottom sheet приглашения (D17-1: вкладка Email disabled до Этапа 25).
class InviteSheet extends ConsumerStatefulWidget {
  const InviteSheet({super.key, required this.spaceId});

  final String spaceId;

  @override
  ConsumerState<InviteSheet> createState() => _InviteSheetState();
}

class _InviteSheetState extends ConsumerState<InviteSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;
  MemberRole _role = MemberRole.member;
  bool _busy = false;
  InvitationInfo? _invite;
  String? _error;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
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

  @override
  Widget build(BuildContext context) {
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
              onSelectionChanged: (s) => setState(() => _role = s.first),
            ),
            const SizedBox(height: AppSpacing.spacing16),
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
                children: [_qrTab(), _linkTab(), _emailTab()],
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

  Widget _qrTab() {
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
          const SizedBox(height: AppSpacing.spacing8),
          Text(
              'Действительно до ${_invite!.expiresAt.toLocal().toString().split('.').first}',
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _linkTab() {
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
            borderRadius: const BorderRadius.all(Radius.circular(AppRadius.radiusMd)),
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

  /// D17-1: Email disabled до подключения облака (Этап 25).
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
