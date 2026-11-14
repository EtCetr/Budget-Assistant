import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// Этап 24: чтение семантики так, как её видит TalkBack.
///
/// find.bySemanticsLabel сравнивает метку целиком, а Flutter дописывает
/// в неё тексты потомков (DECISIONS D22-6). Поэтому берём узел официальным
/// tester.getSemantics и проверяем вхождение подстроки.
/// Требует активного tester.ensureSemantics().
String semanticsLabelOf(WidgetTester tester, Finder finder) =>
    tester.getSemantics(finder).label;

/// Все непустые метки поддерева виджета.
///
/// Нужно, когда первый узел — служебная обёртка (например, скролл
/// у EmptyStateWidget) с пустой меткой, а нужная метка лежит глубже.
List<String> semanticsLabelsOf(WidgetTester tester, Finder finder) {
  final labels = <String>[];
  void visit(SemanticsNode node) {
    if (node.label.isNotEmpty) labels.add(node.label);
    node.visitChildren((child) {
      visit(child);
      return true;
    });
  }

  visit(tester.getSemantics(finder));
  return labels;
}