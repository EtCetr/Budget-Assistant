import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/security_providers.dart';
import '../../../../core/theme/motion_tokens.dart';
import '../../../../features/auth/presentation/providers/current_user_provider.dart';
import '../labels/receipts_strings.dart';
import '../providers/receipt_preview_providers.dart';
import '../providers/receipts_providers.dart';

/// Диалог именования товара (ТЗ 6.3.49): scope self/family,
/// спам-защита через recordNamingDecision.
Future<bool> showProductNamingDialog(
  BuildContext context,
  WidgetRef ref, {
  required String originalName,
  required String categoryId,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => _ProductNamingDialog(
      originalName: originalName,
      categoryId: categoryId,
    ),
  );
  return result ?? false;
}

class _ProductNamingDialog extends ConsumerStatefulWidget {
  const _ProductNamingDialog({
    required this.originalName,
    required this.categoryId,
  });

  final String originalName;
  final String categoryId;

  @override
  ConsumerState<_ProductNamingDialog> createState() =>
      _ProductNamingDialogState();
}

class _ProductNamingDialogState extends ConsumerState<_ProductNamingDialog> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.originalName.trim().toLowerCase(),
  );
  bool _family = false;

  Future<void> _save() async {
    final name = _controller.text.trim();
    if (name.isEmpty) return;
    MotionTokens.medium();
    final userId = ref.read(currentUserIdProvider);
    final spaceId = ref.read(currentSpaceIdProvider);
    await ref.read(findOrCreateProductAliasUseCaseProvider)(
      originalName: name,
      categoryId: widget.categoryId,
      userId: userId,
      spaceId: _family ? spaceId : null,
    );
    await ref
        .read(recordNamingDecisionUseCaseProvider)(userId: userId, accepted: true);
    if (mounted) Navigator.of(context).pop(true);
  }

  Future<void> _skip() async {
    MotionTokens.light();
    final userId = ref.read(currentUserIdProvider);
    await ref
        .read(recordNamingDecisionUseCaseProvider)(userId: userId, accepted: false);
    if (mounted) Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(ReceiptsStrings.namingTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(ReceiptsStrings.namingHint),
          const SizedBox(height: 12),
          TextField(controller: _controller),
          const SizedBox(height: 12),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(value: false, label: Text(ReceiptsStrings.namingScopeSelf)),
              ButtonSegment(value: true, label: Text(ReceiptsStrings.namingScopeFamily)),
            ],
            selected: {_family},
            onSelectionChanged: (v) =>
                setState(() => _family = v.first),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _skip,
          child: const Text(ReceiptsStrings.namingSkip),
        ),
        FilledButton(
          onPressed: _save,
          child: const Text(ReceiptsStrings.namingSave),
        ),
      ],
    );
  }
}