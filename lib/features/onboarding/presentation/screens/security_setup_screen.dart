import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/features/onboarding/domain/notifiers/onboarding_notifier.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecuritySetupScreen extends ConsumerWidget {
  const SecuritySetupScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Set Up Security')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Protect your data',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () async {
                final localAuth = LocalAuthentication();
                const secureStorage = FlutterSecureStorage();
                bool canCheckBiometrics = await localAuth.canCheckBiometrics;
                bool isDeviceSupported = await localAuth.isDeviceSupported();

                if (canCheckBiometrics && isDeviceSupported) {
                  bool authenticated = await localAuth.authenticate(
                    localizedReason: 'Authenticate to enable biometric unlock',
                    options: const AuthenticationOptions(biometricOnly: true),
                  );

                  if (!context.mounted) return;

                  if (authenticated) {
                    await secureStorage.write(
                      key: 'enable_biometric_login',
                      value: 'true',
                    );
                    ref
                        .read(onboardingProvider.notifier)
                        .goToNextStep();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Biometric authentication failed.'),
                      ),
                    );
                  }
                } else {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Biometric authentication is not available.',
                      ),
                    ),
                  );
                }
              },
              icon: const Icon(Icons.fingerprint),
              label: const Text('Enable Fingerprint/Login'),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () =>
                  ref.read(onboardingProvider.notifier).goToNextStep(),
              icon: const Icon(Icons.lock),
              label: const Text('Set Up PIN Code'),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () =>
                  ref.read(onboardingProvider.notifier).goToNextStep(),
              child: const Text('Continue Without Enhanced Security'),
            ),
          ],
        ),
      ),
    );
  }
}
