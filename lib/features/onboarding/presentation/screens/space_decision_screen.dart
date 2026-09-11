import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/features/onboarding/domain/notifiers/onboarding_notifier.dart';
import 'package:budget_assistant/core/providers/encryption_providers.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SpaceDecisionScreen extends ConsumerWidget {
  const SpaceDecisionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Financial Space')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'How would you like to manage your finances?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.home_outlined),
                title: const Text('Create My Own Space'),
                subtitle: const Text('For personal finances'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () async {
                  final encryptionService = ref.read(encryptionServiceProvider);
                  final spaceMasterKey = await encryptionService.generateKey();
                  const secureStorage = FlutterSecureStorage();
                  await secureStorage.write(
                    key: 'space_master_key',
                    value: spaceMasterKey,
                  );
                  ref.read(onboardingProvider.notifier).goToNextStep();
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.group_add_outlined),
                title: const Text('Join a Family Space'),
                subtitle: const Text('Share finances with family members'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => ref
                    .read(onboardingProvider.notifier)
                    .goToNextStep(),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Just Me'),
                subtitle: const Text('Skip creating a space for now'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () => ref
                    .read(onboardingProvider.notifier)
                    .goToNextStep(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
