import 'package:flutter/material.dart';

/// Расширения для упрощения добавления семантики (ТЗ 6.10.4).
extension SemanticsX on Widget {
  /// Обёртка с семантикой кнопки.
  Widget asButton({String? label}) {
    return Semantics(
      label: label,
      button: true,
      child: this,
    );
  }

  /// Обёртка с семантикой заголовка.
  Widget asHeader({String? label}) {
    return Semantics(
      label: label,
      header: true,
      child: this,
    );
  }

  /// Обёртка с семантикой прогресс-бара.
  Widget asProgress({required String label}) {
    return Semantics(
      label: label,
      excludeSemantics: true,
      child: this,
    );
  }
}