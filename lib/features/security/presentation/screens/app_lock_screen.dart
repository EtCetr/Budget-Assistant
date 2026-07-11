import 'package:flutter/material.dart';
import 'package:budget_assistant/features/security/presentation/screens/pin_entry_screen.dart';

class AppLockScreen extends StatelessWidget {
  const AppLockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // AppLockScreen просто рендерит PinEntryScreen в режиме разблокировки.
    // PinEntryScreen сам обрабатывает:
    // - Автоматический запуск биометрии (если включена)
    // - Ввод PIN-кода с кастомной клавиатурой
    // - Блокировку после 5 неудачных попыток
    // - Временное включение FLAG_SECURE на время ввода
    // - Переход на главный экран после успешной аутентификации
    return const PinEntryScreen(mode: 'unlock');
  }
}
