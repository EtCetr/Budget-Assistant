import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';

/// Кнопка с поддержкой клавиатурной навигации и видимым индикатором фокуса
/// (ТЗ 6.10.9, WCAG 2.4.7).
class FocusableButton extends StatefulWidget {
  const FocusableButton({
    super.key,
    required this.child,
    required this.onPressed,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback onPressed;
  final String? semanticLabel;

  @override
  State<FocusableButton> createState() => _FocusableButtonState();
}

class _FocusableButtonState extends State<FocusableButton> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isFocused = _focusNode.hasFocus;
        });
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel,
      button: true,
      child: Focus(
        focusNode: _focusNode,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              (event.logicalKey == LogicalKeyboardKey.enter ||
               event.logicalKey == LogicalKeyboardKey.space)) {
            widget.onPressed();
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Container(
          decoration: BoxDecoration(
            border: _isFocused
                ? Border.all(color: AppColors.colorFAB, width: 2)
                : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: InkWell(
            onTap: widget.onPressed,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}