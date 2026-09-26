import 'package:freezed_annotation/freezed_annotation.dart';
part 'debts_stats.freezed.dart';

/// Статистика долгов для шапки DebtsScreen (6.3.13.4): только активные.
@freezed
abstract class DebtsStats with _$DebtsStats {
  const factory DebtsStats({
    required int payableTotalKopecks,
    required int receivableTotalKopecks,
    required int overdueCount,
  }) = _DebtsStats;
}