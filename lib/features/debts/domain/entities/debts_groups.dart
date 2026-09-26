import 'package:freezed_annotation/freezed_annotation.dart';
import 'debt.dart';
part 'debts_groups.freezed.dart';

/// Группировка долгов по направлению и статусу (6.3.13.3/.5).
@freezed
abstract class DebtsGroups with _$DebtsGroups {
  const factory DebtsGroups({
    required List<Debt> payableActive,
    required List<Debt> payableClosed,
    required List<Debt> receivableActive,
    required List<Debt> receivableClosed,
  }) = _DebtsGroups;
}