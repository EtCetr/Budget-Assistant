import 'package:flutter_test/flutter_test.dart';

import 'package:budget_assistant/core/utils/retry_policy.dart';

void main() {
  group('RetryPolicy', () {
    test('успех с первой попытки', () async {
      const policy = RetryPolicy(jitter: false);
      var calls = 0;
      final result = await policy.run<int>(
        () async {
          calls++;
          return 42;
        },
        label: 'test_success',
      );
      expect(result, 42);
      expect(calls, 1);
    });

    test('повторяет до успеха', () async {
      const policy = RetryPolicy(
        initialDelay: Duration(milliseconds: 1),
        jitter: false,
      );
      var calls = 0;
      final result = await policy.run<int>(
        () async {
          calls++;
          if (calls < 3) throw StateError('transient');
          return 7;
        },
        label: 'test_retry',
      );
      expect(result, 7);
      expect(calls, 3);
    });

    test('сдаётся после maxAttempts и пробрасывает ошибку', () async {
      const policy = RetryPolicy(
        maxAttempts: 2,
        initialDelay: Duration(milliseconds: 1),
        jitter: false,
      );
      var calls = 0;
      await expectLater(
        policy.run<int>(
          () async {
            calls++;
            throw StateError('always');
          },
          label: 'test_giveup',
        ),
        throwsStateError,
      );
      expect(calls, 2);
    });

    test('retryWhen=false останавливает повторы', () async {
      final policy = RetryPolicy(
        maxAttempts: 5,
        initialDelay: const Duration(milliseconds: 1),
        jitter: false,
        retryWhen: (e) => false,
      );
      var calls = 0;
      await expectLater(
        policy.run<int>(
          () async {
            calls++;
            throw StateError('fatal');
          },
          label: 'test_noretry',
        ),
        throwsStateError,
      );
      expect(calls, 1);
    });

    test('экспоненциальная задержка упирается в maxDelay', () {
      const policy = RetryPolicy(
        maxAttempts: 4,
        initialDelay: Duration(milliseconds: 10),
        multiplier: 10,
        maxDelay: Duration(milliseconds: 50),
        jitter: false,
      );
      expect(policy.delayForAttempt(1), const Duration(milliseconds: 10));
      expect(policy.delayForAttempt(2), const Duration(milliseconds: 50));
      expect(policy.delayForAttempt(3), const Duration(milliseconds: 50));
    });
  });
}