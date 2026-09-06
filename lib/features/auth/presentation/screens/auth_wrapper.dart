// lib/features/auth/presentation/screens/auth_wrapper.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/providers/auth_providers.dart';
import 'package:budget_assistant/features/auth/domain/notifiers/auth_notifier.dart';

/// Следит за статусом auth:
/// unknown → загрузка, unauthenticated → форма входа, authenticated → ждём redirect
class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final status = ref.watch(authProvider);

    // ✅ УБРАЛИ ref.listen с context.go — redirect в app_router сделает это сам

    switch (status) {
      case AuthStatus.unknown:
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case AuthStatus.authenticated:
        // Ждём redirect от app_router
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      case AuthStatus.unauthenticated:
        return const _AuthScreen();
    }
  }
}

/// Экран входа/регистрации: email + пароль, без кодов из писем
class _AuthScreen extends ConsumerStatefulWidget {
  const _AuthScreen();

  @override
  ConsumerState<_AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<_AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final repo = ref.read(authRepositoryProvider);

      final result = _isLogin
          ? await repo.signInWithEmailAndPassword(
              _emailController.text.trim(),
              _passwordController.text,
            )
          : await repo.signUpWithEmailAndPassword(
              _emailController.text.trim(),
              _passwordController.text,
            );

      result.when(
        success: (response) {
          if (!mounted) return;
          // Если в Supabase включено подтверждение почты — сессии не будет
          if (response.session == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Проверьте почту для подтверждения регистрации'),
              ),
            );
          }
          // ✅ Иначе AuthNotifier получит событие, authProvider обновится,
          // и redirect в app_router автоматически отправит на /onboarding
        },
        failure: (failure) {
          if (!mounted) return;
          AppLogger.e('Auth failed', failure, StackTrace.current);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(failure.message)));
        },
      );
    } catch (e, st) {
      AppLogger.e('Unexpected auth error', e, st);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Ошибка: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Вход' : 'Регистрация')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.account_balance_wallet, size: 72),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                validator: (v) => (v == null || !v.contains('@'))
                    ? 'Введите корректный email'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (v) =>
                    (v == null || v.length < 6) ? 'Минимум 6 символов' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(_isLogin ? 'Войти' : 'Создать аккаунт'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => setState(() => _isLogin = !_isLogin),
                child: Text(
                  _isLogin
                      ? 'Нет аккаунта? Зарегистрироваться'
                      : 'Уже есть аккаунт? Войти',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
