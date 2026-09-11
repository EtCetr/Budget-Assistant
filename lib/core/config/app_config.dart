import 'package:flutter/foundation.dart';

enum Flavor { dev, prod }

class AppConfig {
  static late Flavor appFlavor;
  static late String supabaseUrl;
  static late String supabaseAnonKey;

  /// Initializes app configuration based on the selected flavor.
  /// Secrets are injected via --dart-define during build to prevent hardcoding.
  static void init(Flavor flavor) {
    appFlavor = flavor;

    switch (flavor) {
      case Flavor.dev:
        supabaseUrl = const String.fromEnvironment('SUPABASE_URL_DEV');
        supabaseAnonKey = const String.fromEnvironment('SUPABASE_ANON_KEY_DEV');
        break;
      case Flavor.prod:
        supabaseUrl = const String.fromEnvironment('SUPABASE_URL_PROD');
        supabaseAnonKey = const String.fromEnvironment(
          'SUPABASE_ANON_KEY_PROD',
        );
        break;
    }

    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      debugPrint(
        'WARNING: Supabase keys are missing! Check your --dart-define arguments.',
      );
    }
  }
}
