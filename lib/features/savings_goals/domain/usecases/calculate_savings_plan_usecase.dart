import 'package:logger/logger.dart';

/// Live-предпросмотр плана накопления.
///
/// Рассчитывает, сколько нужно откладывать в месяц/год, чтобы достичь цели.
class CalculateSavingsPlanUseCase {
  CalculateSavingsPlanUseCase({required Logger logger}) : _logger = logger;

  final Logger _logger;

  SavingsPlan call({
    required int targetAmountKopecks,
    DateTime? deadline,
  }) {
    try {
      if (targetAmountKopecks <= 0) {
        return const SavingsPlan(
          monthlyAmountKopecks: 0,
          yearlyAmountKopecks: 0,
          monthsUntilDeadline: null,
        );
      }

      if (deadline == null) {
        // Без дедлайна: показываем план на 1 год и 10 лет
        return SavingsPlan(
          monthlyAmountKopecks: targetAmountKopecks ~/ 120, // 10 лет
          yearlyAmountKopecks: targetAmountKopecks ~/ 10,
          monthsUntilDeadline: null,
        );
      }

      // С дедлайном: рассчитываем до даты
      final now = DateTime.now();
      final monthsUntilDeadline =
          (deadline.year - now.year) * 12 + (deadline.month - now.month);
      if (monthsUntilDeadline <= 0) {
        return const SavingsPlan(
          monthlyAmountKopecks: 0,
          yearlyAmountKopecks: 0,
          monthsUntilDeadline: 0,
        );
      }

      final monthly = targetAmountKopecks ~/ monthsUntilDeadline;
      final yearly = monthly * 12;

      return SavingsPlan(
        monthlyAmountKopecks: monthly,
        yearlyAmountKopecks: yearly,
        monthsUntilDeadline: monthsUntilDeadline,
      );
    } catch (e, st) {
      _logger.e('CalculateSavingsPlanUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}

/// План накопления.
class SavingsPlan {
  const SavingsPlan({
    required this.monthlyAmountKopecks,
    required this.yearlyAmountKopecks,
    required this.monthsUntilDeadline,
  });

  final int monthlyAmountKopecks;
  final int yearlyAmountKopecks;
  final int? monthsUntilDeadline;
}