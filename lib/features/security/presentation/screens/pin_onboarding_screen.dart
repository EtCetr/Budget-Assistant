import 'dart:async';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:budget_assistant/core/utils/result.dart';
import 'package:budget_assistant/features/security/presentation/widgets/pin_indicators.dart';
import 'package:budget_assistant/features/security/presentation/widgets/custom_pin_keypad.dart';
import 'package:budget_assistant/features/security/domain/usecases/validate_pin_strength_usecase.dart';
import 'package:budget_assistant/features/security/domain/usecases/set_pin_code_usecase.dart';
import 'package:budget_assistant/features/security/data/repositories/pin_code_repository.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:budget_assistant/core/logger.dart';

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
    PinCodeRepositoryImpl(const FlutterSecureStorage()),
  );

  @override
  void dispose() {
    _clearTimer?.cancel();
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
    final result = await _setPinUseCase(_enteredPin);

    if (result.isSuccess) {
      HapticFeedback.heavyImpact();
      setState(() {
        _currentStep = PinOnboardingStep.success;
        _enteredPin = '';
      });

      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      });
    } else {
      AppLogger.e(
        'Failed to save PIN: ${Result.failure.message ?? "Unknown error"}',
      );
      setState(() {
        _errorMessage = 'Не удалось сохранить PIN. Попробуйте снова';
      });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        leading:
            _currentStep == PinOnboardingStep.welcome ||
                _currentStep == PinOnboardingStep.success
            ? null
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(false),
              ),
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
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Пропустить'),
          ),
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

extension on Result<T> Function<T>(Failure failure) {
  String? get message => null;
}
