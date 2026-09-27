/// Уверенность автодетекта (ТЗ 6.3.9.6):
/// high — >= 6 вхождений, medium — 3..5 вхождений.
class CalculateConfidenceUseCase {
  static const String high = 'high';
  static const String medium = 'medium';

  String call(int occurrenceCount) =>
      occurrenceCount >= 6 ? high : medium;
}