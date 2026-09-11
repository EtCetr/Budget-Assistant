import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:budget_assistant/core/router/routes.dart';
import 'package:budget_assistant/features/security/presentation/widgets/pin_indicators.dart';
import 'package:budget_assistant/features/security/presentation/widgets/custom_pin_keypad.dart';
import 'package:budget_assistant/features/security/domain/usecases/verify_pin_code_usecase.dart';
import 'package:budget_assistant/features/security/data/repositories/pin_code_repository.dart';
import 'package:budget_assistant/features/security/services/biometric_service.dart';
import 'package:budget_assistant/core/services/secure_storage_service.dart';


class PinEntryScreen extends ConsumerStatefulWidget {
  final String mode; // 'unlock' или 'verify'

  const PinEntryScreen({super.key, this.mode = 'unlock'});

  @override
  ConsumerState<PinEntryScreen> createState() => _PinEntryScreenState();
}

class _PinEntryScreenState extends ConsumerState<PinEntryScreen> {
  String _enteredPin = '';
  int _attemptCount = 0;
  String? _errorMessage;
  bool _isLocked = false;
  int _lockoutSeconds = 0;
  Timer? _clearTimer;
  Timer? _lockoutTimer;
  bool _biometricAvailable = false;

  late final _verifyUseCase = VerifyPinCodeUseCase(
    PinCodeRepositoryImpl(SecureStorageService()),
  );

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    // Биометрия автозапускается только для mode=unlock
    if (widget.mode == 'unlock') {
      _autoTriggerBiometric();
    }
  }

  @override
  void dispose() {
    _clearTimer?.cancel();
    _lockoutTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkBiometricAvailability() async {
    final available = await BiometricService.isAvailable();
    if (mounted) {
      setState(() {
        _biometricAvailable = available;
      });
    }
  }

  Future<void> _autoTriggerBiometric() async {
    // Биометрия доступна только для unlock режима
    if (widget.mode != 'unlock') return;
    if (!_biometricAvailable) return;

    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;

    final success = await BiometricService.authenticate(
      reason: 'Войдите в Budget Assistant',
    );

    if (success && mounted) {
      _onAuthenticationSuccess();
    }
  }

  void _onDigitPressed(String digit) {
    if (_isLocked || _enteredPin.length >= 4) return;

    setState(() {
      _enteredPin += digit;
      _errorMessage = null;
    });

    if (_enteredPin.length == 4) {
      _verifyPin();
    }
  }

  void _onBackspacePressed() {
    if (_isLocked || _enteredPin.isEmpty) return;

    setState(() {
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      _errorMessage = null;
    });
  }

  Future<void> _verifyPin() async {
    final result = await _verifyUseCase(_enteredPin);

    // Используем .when() как в оригинале
    result.when(
      success: (isSuccess) {
        if (isSuccess) {
          HapticFeedback.mediumImpact();
          _onAuthenticationSuccess();
        } else {
          _handleWrongPin();
        }
      },
      failure: (failure) {
        _handleWrongPin();
      },
    );
  }

  // Логика обработки неверного PIN-кода
  void _handleWrongPin() {
    HapticFeedback.vibrate();
    setState(() {
      _attemptCount++;
      _errorMessage = 'Неверный PIN. Осталось попыток: ${5 - _attemptCount}';
    });

    _scheduleClearPin();

    if (_attemptCount >= 5) {
      _startLockout();
    }
  }

  void _onAuthenticationSuccess() {
    setState(() {
      _attemptCount = 0;
      _isLocked = false;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      if (widget.mode == 'unlock') {
        // Разблокировка приложения: переход на главный экран
        context.go(AppRoutes.home);
      } else {
        // Подтверждение операции: возврат с результатом
        Navigator.of(context).pop(true);
      }
    });
  }

  void _scheduleClearPin() {
    _clearTimer?.cancel();
    _clearTimer = Timer(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _enteredPin = '';
        });
      }
    });
  }

  void _startLockout() {
    setState(() {
      _isLocked = true;
      _lockoutSeconds = 30;
    });

    HapticFeedback.vibrate();

    _lockoutTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_lockoutSeconds <= 1) {
        timer.cancel();
        setState(() {
          _isLocked = false;
          _attemptCount = 0;
          _lockoutSeconds = 0;
          _errorMessage = null;
        });
      } else {
        setState(() {
          _lockoutSeconds--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isUnlockMode = widget.mode == 'unlock';
    final title = isUnlockMode ? 'Введите PIN-код' : 'Подтвердите операцию';
    final subtitle = isUnlockMode
        ? 'Для входа в приложение требуется 4-значный PIN-код или биометрия'
        : 'Введите PIN-код для подтверждения критичной операции';

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        // Для unlock режима нет кнопки назад (безопасность)
        automaticallyImplyLeading: !isUnlockMode,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 48),
            Icon(
              _isLocked ? Icons.lock_clock : Icons.lock_outline,
              size: 64,
              color: _errorMessage != null ? Colors.red : Colors.blue,
            ),
            const SizedBox(height: 24),
            // Подзаголовок
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 32),
            if (_isLocked)
              Text(
                '⏱️ Повторите через $_lockoutSeconds сек',
                style: const TextStyle(fontSize: 18, color: Colors.red),
              )
            else ...[
              PinIndicators(
                length: 4,
                filledCount: _enteredPin.length,
                isError: _errorMessage != null,
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ],
            const Spacer(),
            if (!_isLocked)
              CustomPinKeypad(
                onDigitPressed: _onDigitPressed,
                onBackspacePressed: _onBackspacePressed,
                // Биометрия показывается только для unlock режима
                showBiometricButton: _biometricAvailable && isUnlockMode,
                onBiometricPressed: _autoTriggerBiometric,
                isEnabled: !_isLocked,
              ),
            const SizedBox(height: 32),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Функция восстановления PIN в разработке'),
                  ),
                );
              },
              child: const Text('Забыли PIN?'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
