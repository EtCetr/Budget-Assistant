import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Список с поддержкой навигации стрелками клавиатуры (ТЗ 6.10.9).
class ArrowNavigableList extends StatelessWidget {
  const ArrowNavigableList({
    super.key,
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      child: ListView(
        children: children
            .map((child) => Focus(
                  onKeyEvent: (node, event) {
                    if (event is KeyDownEvent) {
                      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                        FocusScope.of(context).nextFocus();
                        return KeyEventResult.handled;
                      }
                      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                        FocusScope.of(context).previousFocus();
                        return KeyEventResult.handled;
                      }
                    }
                    return KeyEventResult.ignored;
                  },
                  child: child,
                ))
            .toList(),
      ),
    );
  }
}