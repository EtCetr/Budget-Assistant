// lib/features/security/presentation/screens/pin_onboarding_screen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/services/secure_storage_service.dart';
import 'package:budget_assistant/features/onboarding/domain/notifiers/onboarding_notifier.dart';
import 'package:budget_assistant/features/security/data/repositories/pin_code_repository.dart';
import 'package:budget_assistant/features/security/domain/usecases/set_pin_code_usecase.dart';
import 'package:budget_assistant/features/security/domain/usecases/validate_pin_strength_usecase.dart';
import 'package:budget_assistant/features/security/presentation/widgets/custom_pin_keypad.dart';
import 'package:budget_assistant/features/security/presentation/widgets/pin_indicators.dart';

enum PinOnboardingStep { welcome, enterPin, confirmPin, success }

class PinOnboardingScreen extends ConsumerStatefulWidget {
  const PinOnboardingScreen({super.key});

  @override
  ConsumerState<PinOnboardingScreen> createState() =>
      _PinOnboardingScreenState();
}

class _PinOnboardingScreenState extends ConsumerState<PinOnboardingScreen> {
  PinOnboardingStep _currentStep = PinOnboardingStep.welcome;
  String _enteredPin = '';
  String _firstPin = '';
  int _attemptCount = 0;
  String? _errorMessage;
  Timer? _clearTimer;

  final _validateUseCase = ValidatePinStrengthUseCase();
  late final _setPinUseCase = SetPinCodeUseCase(
    PinCodeRepositoryImpl(SecureStorageService()),
  );

  @override
  void dispose() {
    _clearTimer?.cancel();
    // Очищаем PIN из памяти при закрытии экрана
    _enteredPin = '';
    _firstPin = '';
    super.dispose();
  }

  void _onDigitPressed(String digit) {
    if (_enteredPin.length >= 4) return;

    setState(() {
      _enteredPin += digit;
      _errorMessage = null;
    });

    if (_enteredPin.length == 4) {
      _onPinComplete();
    }
  }

  void _onBackspacePressed() {
    if (_enteredPin.isEmpty) return;

    setState(() {
      _enteredPin = _enteredPin.substring(0, _enteredPin.length - 1);
      _errorMessage = null;
    });
  }

  void _onPinComplete() {
    HapticFeedback.mediumImpact();

    if (_currentStep == PinOnboardingStep.enterPin) {
      final validation = _validateUseCase(_enteredPin);

      if (!validation.isValid) {
        setState(() {
          _errorMessage = validation.errorMessage;
        });
        HapticFeedback.vibrate();
        _scheduleClearPin();
        return;
      }

      setState(() {
        _firstPin = _enteredPin;
        _enteredPin = '';
        _currentStep = PinOnboardingStep.confirmPin;
      });
    } else if (_currentStep == PinOnboardingStep.confirmPin) {
      if (_enteredPin == _firstPin) {
        _savePin();
      } else {
        setState(() {
          _errorMessage = 'PIN-коды не совпадают. Попробуйте снова';
          _attemptCount++;
        });
        HapticFeedback.vibrate();
        _scheduleClearPin();

        if (_attemptCount >= 3) {
          setState(() {
            _firstPin = '';
            _enteredPin = '';
            _attemptCount = 0;
            _currentStep = PinOnboardingStep.enterPin;
            _errorMessage = 'Начните заново с новым PIN-кодом';
          });
        }
      }
    }
  }

  Future<void> _savePin() async {
    final pin = _firstPin;
    final confirm = _enteredPin;

    try {
      final result = await _setPinUseCase(pin, confirm);

      result.when(
        success: (_) async {
          if (!mounted) return;
          AppLogger.i('PIN установлен в онбординге');

          setState(() {
            _currentStep = PinOnboardingStep.success;
            _enteredPin = '';
            _firstPin = '';
            _errorMessage = null;
          });

          await Future.delayed(const Duration(seconds: 3));
          if (!mounted) return;

          // Если экран открыт поверх стека — возвращаем результат вызвавшему,
          // иначе (внутри онбординга) — двигаем онбординг на следующий шаг
          if (Navigator.of(context).canPop()) {
            Navigator.of(context).pop(true);
          } else {
            ref.read(onboardingProvider.notifier).goToNextStep();
          }
        },
        failure: (failure) {
          if (!mounted) return;
          AppLogger.e('Не удалось сохранить PIN', failure, StackTrace.current);
          setState(() {
            _errorMessage = failure.message;
            _enteredPin = '';
          });
        },
      );
    } catch (e, stackTrace) {
      AppLogger.e('Unexpected error in _savePin', e, stackTrace);
      if (mounted) {
        setState(() {
          _errorMessage = 'Ошибка сохранения PIN. Попробуйте снова';
          _enteredPin = '';
        });
      }
    }
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

  void _skipOrBack() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(false);
    } else {
      ref.read(onboardingProvider.notifier).goToNextStep();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        leading:
            _currentStep == PinOnboardingStep.welcome ||
                _currentStep == PinOnboardingStep.success
            ? null
            : IconButton(icon: const Icon(Icons.close), onPressed: _skipOrBack),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            _buildContent(),
            const Spacer(),
            if (_currentStep != PinOnboardingStep.welcome &&
                _currentStep != PinOnboardingStep.success) ...[
              PinIndicators(
                length: 4,
                filledCount: _enteredPin.length,
                isError: _errorMessage != null,
              ),
              const SizedBox(height: 16),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(
                    _errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 32),
              CustomPinKeypad(
                onDigitPressed: _onDigitPressed,
                onBackspacePressed: _onBackspacePressed,
              ),
              const SizedBox(height: 32),
            ],
          ],
        ),
      ),
    );
  }

  String _getTitle() {
    switch (_currentStep) {
      case PinOnboardingStep.welcome:
        return 'Защитите приложение PIN-кодом';
      case PinOnboardingStep.enterPin:
        return 'Придумайте 4-значный PIN-код';
      case PinOnboardingStep.confirmPin:
        return 'Повторите PIN-код для подтверждения';
      case PinOnboardingStep.success:
        return 'PIN-код установлен!';
    }
  }

  Widget _buildContent() {
    switch (_currentStep) {
      case PinOnboardingStep.welcome:
        return _buildWelcomeContent();
      case PinOnboardingStep.success:
        return _buildSuccessContent();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildWelcomeContent() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          const Icon(Icons.lock_outline, size: 80, color: Colors.blue),
          const SizedBox(height: 24),
          const Text(
            '4-значный PIN-код потребуется при каждом входе в приложение. Код хранится зашифрованным на вашем устройстве.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 48),
          ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              setState(() {
                _currentStep = PinOnboardingStep.enterPin;
              });
            },
            child: const Text('Начать'),
          ),
          const SizedBox(height: 16),
          TextButton(onPressed: _skipOrBack, child: const Text('Пропустить')),
        ],
      ),
    );
  }

  Widget _buildSuccessContent() {
    return const Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(Icons.check_circle, size: 80, color: Colors.green),
          SizedBox(height: 24),
          Text(
            'Теперь для входа в приложение потребуется 4-значный PIN-код.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 24),
          Text(
            'Автоматический переход через 3 сек...',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
