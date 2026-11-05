import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart' hide BarcodeType;
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/core/providers/security_providers.dart';
import 'package:budget_assistant/core/theme/app_colors.dart';
import 'package:budget_assistant/core/theme/app_spacing.dart';
import 'package:budget_assistant/core/theme/motion_tokens.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import '../../domain/entities/loyalty_card.dart';
import '../loyalty_cards_strings.dart';
import '../providers/add_loyalty_card_providers.dart';
import '../providers/loyalty_cards_usecase_providers.dart';
import '../widgets/add_loyalty_card_mode_toggle.dart';
import '../widgets/barcode_scanner_view.dart';
import '../widgets/loyalty_card_editors.dart';
import '../widgets/loyalty_card_tile.dart';
import '../widgets/popular_stores_row.dart';

/// Добавление / редактирование скидочной карты (ТЗ 6.3.20):
/// галерея (распознавание со скриншота) / сканер / ручной ввод,
/// пресеты магазинов, черновики 5 сек, валидация и сборка — через UseCases.
class AddLoyaltyCardScreen extends ConsumerStatefulWidget {
  const AddLoyaltyCardScreen({super.key, this.cardId});

  final String? cardId;

  @override
  ConsumerState<AddLoyaltyCardScreen> createState() =>
      _AddLoyaltyCardScreenState();
}

class _AddLoyaltyCardScreenState extends ConsumerState<AddLoyaltyCardScreen> {
  final _storeController = TextEditingController();
  final _barcodeController = TextEditingController();
  final MobileScannerController _analyzeController = MobileScannerController();
  String _mode = 'gallery';
  bool _initialized = false;
  late final Future<bool> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _init();
  }

  @override
  void dispose() {
    _storeController.dispose();
    _barcodeController.dispose();
    _analyzeController.dispose();
    super.dispose();
  }

  Future<bool> _init() async {
    final userId = ref.read(currentUserIdProvider);
    if (widget.cardId != null) {
      final result =
          await ref.read(getLoyaltyCardByIdUseCaseProvider).call(widget.cardId!);
      if (!mounted) return false;
      switch (result) {
        case Success(value: final card):
          if (card == null) {
            context.pop();
            return false;
          }
          if (card.userId != userId) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(LoyaltyCardsStrings.notCreator)),
            );
            context.pop();
            return false;
          }
          ref.read(addLoyaltyCardFormProvider.notifier).loadFromCard(card);
          _mode = 'manual';
        case Error():
          context.pop();
          return false;
      }
    } else {
      final draftResult =
          await ref.read(restoreLoyaltyCardDraftUseCaseProvider).call(userId);
      if (!mounted) return true;
      switch (draftResult) {
        case Success(value: final draft):
          if (draft != null) {
            final restore = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text(LoyaltyCardsStrings.draftRestoreTitle),
                content: const Text(LoyaltyCardsStrings.draftRestoreText),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx, false),
                    child: const Text(LoyaltyCardsStrings.draftRestoreNo),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text(LoyaltyCardsStrings.draftRestoreYes),
                  ),
                ],
              ),
            );
            if (!mounted) return true;
            if (restore == true) {
              ref
                  .read(addLoyaltyCardFormProvider.notifier)
                  .loadFromDraft(draft);
            } else {
              await ref
                  .read(clearLoyaltyCardDraftUseCaseProvider)
                  .call(userId);
            }
          }
        case Error():
          break;
      }
    }
    if (!mounted) return false;
    final form = ref.read(addLoyaltyCardFormProvider);
    _storeController.text = form.storeName;
    _barcodeController.text = form.barcodeData;
    ref.read(addLoyaltyCardFormProvider.notifier).startDraftAutosave(userId);
    setState(() => _initialized = true);
    return true;
  }

  BarcodeType _mapFormat(BarcodeFormat format) => switch (format) {
        BarcodeFormat.ean13 => BarcodeType.ean13,
        BarcodeFormat.code128 => BarcodeType.code128,
        BarcodeFormat.qrCode => BarcodeType.qr,
        BarcodeFormat.pdf417 => BarcodeType.pdf417,
        _ => BarcodeType.manual,
      };

  void _applyDetected(String raw, BarcodeType type) {
    final notifier = ref.read(addLoyaltyCardFormProvider.notifier);
    notifier.setBarcodeData(raw);
    notifier.setBarcodeType(type);
    _barcodeController.text = raw;
    setState(() => _mode = 'manual');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(LoyaltyCardsStrings.scanDetected)),
    );
  }

  /// Распознавание кода с картинки из галереи (большинство карт — скриншоты).
  Future<void> _pickFromGallery() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final picker = ImagePicker();
      final file = await picker.pickImage(source: ImageSource.gallery);
      if (file == null) return;
      final capture = await _analyzeController.analyzeImage(file.path);
      if (!mounted) return;
      final codes = capture?.barcodes ?? const <Barcode>[];
      final barcode = codes.isEmpty ? null : codes.first;
      final raw = barcode?.rawValue;
      if (raw == null || raw.isEmpty) {
        MotionTokens.error();
        messenger.showSnackBar(
          const SnackBar(content: Text(LoyaltyCardsStrings.galleryNotFound)),
        );
        return;
      }
      MotionTokens.medium();
      _applyDetected(raw, _mapFormat(barcode!.format));
    } catch (_) {
      if (!mounted) return;
      MotionTokens.error();
      messenger.showSnackBar(
        const SnackBar(content: Text(LoyaltyCardsStrings.galleryNotFound)),
      );
    }
  }

  Future<void> _save() async {
    final messenger = ScaffoldMessenger.of(context);
    final userId = ref.read(currentUserIdProvider);
    final spaceId = ref.read(currentSpaceIdProvider);
    final form = ref.read(addLoyaltyCardFormProvider);
    final validated = ref
        .read(validateLoyaltyCardFormUseCaseProvider)
        .call(form: form, currentSpaceId: spaceId);
    switch (validated) {
      case Error(failure: final f):
        MotionTokens.error();
        messenger.showSnackBar(
          SnackBar(
            content: Text(f is ValidationFailure
                ? f.message
                : LoyaltyCardsStrings.actionFailed),
          ),
        );
        return;
      case Success():
        break;
    }
    LoyaltyCard? existing;
    if (form.cardId != null) {
      final existingResult =
          await ref.read(getLoyaltyCardByIdUseCaseProvider).call(form.cardId!);
      if (existingResult case Success(value: final card)) {
        existing = card;
      }
    }
    final card = ref.read(buildLoyaltyCardDraftUseCaseProvider).call(
          form: form,
          userId: userId,
          currentSpaceId: spaceId,
          existing: existing,
        );
    final result = form.cardId == null
        ? await ref.read(createLoyaltyCardUseCaseProvider).call(card)
        : await ref.read(updateLoyaltyCardUseCaseProvider).call(card);
    if (!mounted) return;
    switch (result) {
      case Success():
        MotionTokens.medium();
        await ref
            .read(addLoyaltyCardFormProvider.notifier)
            .stopAutosaveAndClearDraft(userId);
        if (mounted) context.pop(true);
      case Error(failure: final f):
        MotionTokens.error();
        messenger.showSnackBar(
          SnackBar(
            content: Text(f is ValidationFailure
                ? f.message
                : LoyaltyCardsStrings.actionFailed),
          ),
        );
    }
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSpacing.spacing4, AppSpacing.spacing16, 0, AppSpacing.spacing8),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _galleryPicker() {
    return Container(
      height: 180,
      decoration: const BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.photo_library_outlined,
                size: 40, color: AppColors.textSecondary),
            const SizedBox(height: AppSpacing.spacing8),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.spacing24),
              child: Text(
                LoyaltyCardsStrings.galleryHint,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
              ),
            ),
            const SizedBox(height: AppSpacing.spacing12),
            FilledButton.icon(
              onPressed: () {
                MotionTokens.light();
                _pickFromGallery();
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.colorFAB,
              ),
              icon: const Icon(Icons.upload_file_outlined, color: Colors.white),
              label: const Text(
                LoyaltyCardsStrings.galleryPick,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(addLoyaltyCardFormProvider);
    final spaceId = ref.watch(currentSpaceIdProvider);
    final userId = ref.watch(currentUserIdProvider);
    final mode = ref.watch(privacyModeProvider);
    final formatter = ref.watch(privacyFormatterProvider);
    final popularAsync = ref.watch(popularStoresProvider);
    final preview = ref.read(buildLoyaltyCardDraftUseCaseProvider).call(
          form: form,
          userId: userId,
          currentSpaceId: spaceId,
        );
    return Scaffold(
      backgroundColor: AppColors.surfaceBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surfaceBackground,
        title: Text(form.cardId == null
            ? LoyaltyCardsStrings.addCard
            : LoyaltyCardsStrings.editTitle),
      ),
      body: FutureBuilder<bool>(
        future: _initFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: const EdgeInsets.all(AppSpacing.spacing16),
            children: [
              SizedBox(
                height: 170,
                child: LoyaltyCardTile(
                  card: preview,
                  mode: mode,
                  formatter: formatter,
                  currentUserId: userId,
                ),
              ),
              const SizedBox(height: AppSpacing.spacing16),
              AddLoyaltyCardModeToggle(
                mode: _mode,
                onChanged: (v) => setState(() => _mode = v),
              ),
              const SizedBox(height: AppSpacing.spacing16),
              if (_mode == 'gallery' && form.cardId == null)
                _galleryPicker()
              else if (_mode == 'scan' && form.cardId == null)
                BarcodeScannerView(
                  onDetected: (raw, type) => _applyDetected(raw, type),
                )
              else ...[
                TextField(
                  controller: _barcodeController,
                  style: const TextStyle(color: AppColors.textPrimary),
                  onChanged: (v) => ref
                      .read(addLoyaltyCardFormProvider.notifier)
                      .setBarcodeData(v),
                  decoration: const InputDecoration(
                    hintText: LoyaltyCardsStrings.barcodeLabel,
                    filled: true,
                    fillColor: AppColors.surfaceElevated,
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.radiusFull,
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                _label(LoyaltyCardsStrings.typeLabel),
                BarcodeTypeChips(
                  selected: form.barcodeType,
                  onChanged: (t) => ref
                      .read(addLoyaltyCardFormProvider.notifier)
                      .setBarcodeType(t),
                ),
              ],
              _label(LoyaltyCardsStrings.popularLabel),
              popularAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
                data: (stores) => PopularStoresRow(
                  stores: stores,
                  onTap: (s) {
                    ref
                        .read(addLoyaltyCardFormProvider.notifier)
                        .applyPopularStore(s);
                    _storeController.text = s.name;
                  },
                ),
              ),
              _label(LoyaltyCardsStrings.storeNameLabel),
              TextField(
                controller: _storeController,
                style: const TextStyle(color: AppColors.textPrimary),
                onChanged: (v) => ref
                    .read(addLoyaltyCardFormProvider.notifier)
                    .setStoreName(v),
                decoration: const InputDecoration(
                  hintText: LoyaltyCardsStrings.storeNameLabel,
                  filled: true,
                  fillColor: AppColors.surfaceElevated,
                  border: OutlineInputBorder(
                    borderRadius: AppRadius.radiusFull,
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              _label(LoyaltyCardsStrings.categoryLabel),
              CategoryChips(
                selected: form.category,
                onChanged: (c) =>
                    ref.read(addLoyaltyCardFormProvider.notifier).setCategory(c),
              ),
              _label(LoyaltyCardsStrings.colorLabel),
              BrandColorGrid(
                selected: form.brandColor,
                onChanged: (hex) => ref
                    .read(addLoyaltyCardFormProvider.notifier)
                    .setBrandColor(hex),
              ),
              _label(LoyaltyCardsStrings.emojiLabel),
              EmojiGrid(
                selected: form.iconAsset,
                onChanged: (e) => ref
                    .read(addLoyaltyCardFormProvider.notifier)
                    .setIconAsset(e),
              ),
              _label(LoyaltyCardsStrings.visibilityFamily),
              VisibilityToggle(
                visibility: form.visibility,
                familyAvailable: spaceId != null,
                onChanged: (v) => ref
                    .read(addLoyaltyCardFormProvider.notifier)
                    .setVisibility(v),
              ),
              const SizedBox(height: AppSpacing.spacing24),
              FilledButton(
                onPressed: _initialized ? _save : null,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.colorFAB,
                ),
                child: const Text(LoyaltyCardsStrings.saveCard),
              ),
              const SizedBox(height: AppSpacing.spacing16),
            ],
          );
        },
      ),
    );
  }
}