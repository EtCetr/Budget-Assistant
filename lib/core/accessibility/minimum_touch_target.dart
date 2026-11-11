import 'package:flutter/material.dart';

/// Обёртка для обеспечения минимального размера зоны касания 48×48 логических пикселей
/// (ТЗ 6.10.3, WCAG 2.5.5).
class MinimumTouchTarget extends StatelessWidget {
  const MinimumTouchTarget({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.semanticLabel,
    this.excludeSemantics = false,
  });

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final String? semanticLabel;
  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: semanticLabel,
      button: onTap != null || onLongPress != null,
      excludeSemantics: excludeSemantics,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Center(child: child),
        ),
      ),
    );
  }
}