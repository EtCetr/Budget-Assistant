import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/app.dart'; // Импорт app.dart

void main() {
  runApp(
    const ProviderScope(
      child:
          BudgetAssistantApp(), // Убрали const, если класс не константный, или оставили, если константный. В app.dart мы сделали его const.
    ),
  );
}
