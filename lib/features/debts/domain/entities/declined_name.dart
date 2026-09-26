import 'package:freezed_annotation/freezed_annotation.dart';
part 'declined_name.freezed.dart';

/// Результат склонения ФИО (DeclineNameUseCase, вариант «а»: свой
/// правил-бейсд склонятель без внешних зависимостей).
@freezed
abstract class DeclinedName with _$DeclinedName {
  const factory DeclinedName({
    required String original,
    /// Дательный падеж; при неудаче равен original.
    required String dative,
    /// false — правила не смогли просклонять (UI 6.3.14 предложит ручной ввод).
    required bool success,
  }) = _DeclinedName;
}