import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:budget_assistant/features/security/services/biometric_service.dart';
import 'package:budget_assistant/core/logger.dart';

class BiometricOnboardingScreen extends ConsumerStatefulWidget {
  const BiometricOnboardingScreen({super.key});

  @override
  ConsumerState<BiometricOnboardingScreen> createState() =>
      _BiometricOnboardingScreenState();
}

class _BiometricOnboardingScreenState
    extends ConsumerState<BiometricOnboardingScreen> {
  bool _isChecking = true;
  bool _isAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkAvailability();
  }

  Future<void> _checkAvailability() async {
    final available = await BiometricService.isAvailable();
    setState(() {
      _isAvailable = available;
      _isChecking = false;
    });
  }

  Future<void> _enableBiometric() async {
    HapticFeedback.lightImpact();

    final success = await BiometricService.authenticate(
      reason: 'Включите биометрический вход',
    );

    if (success && mounted) {
      // TODO: Сохранить флаг enable_biometric_login в app_settings
      AppLogger.i('Biometric enabled');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Биометрический вход включён')),
      );

      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Биометрический вход')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.fingerprint, size: 80, color: Colors.blue),
              const SizedBox(height: 24),
              const Text(
                'Упростите вход с помощью биометрии',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                'Используйте отпечаток пальца или Face ID для быстрого входа в приложение. PIN-код останется как резервный метод.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 48),
              if (_isAvailable) ...[
                ElevatedButton.icon(
                  onPressed: _enableBiometric,
                  icon: const Icon(Icons.fingerprint),
                  label: const Text('Включить биометрию'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Пропустить'),
                ),
              ] else
                const Text(
                  'Биометрия недоступна на этом устройстве',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
