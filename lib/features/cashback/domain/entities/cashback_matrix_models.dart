import 'package:freezed_annotation/freezed_annotation.dart';

part 'cashback_matrix_models.freezed.dart';

/// Ячейка матрицы выгоды: одна карта в одной категории.
///
/// percentBps == null — у карты нет категории кэшбэка (пустая ячейка).
@freezed
abstract class CashbackMatrixCell with _$CashbackMatrixCell {
  const factory CashbackMatrixCell({
    required String accountId,
    required String accountName,
    required String currency,
    String? entryId,
    String? status,
    String? lifetimeType,
    int? percentBps,
    int? netKopecks,
    int? cashbackKopecks,
  }) = _CashbackMatrixCell;
}

/// Строка матрицы выгоды: категория x все карты пользователя.
///
/// [bestAccountId] — карта с максимальным процентом по категории
/// (при равенстве процентов — с большим фактическим кэшбэком).
@freezed
abstract class CashbackMatrixRow with _$CashbackMatrixRow {
  const factory CashbackMatrixRow({
    required String categoryId,
    required String categoryName,
    required List<CashbackMatrixCell> cells,
    required String? bestAccountId,
    required int bestPercentBps,
  }) = _CashbackMatrixRow;
}