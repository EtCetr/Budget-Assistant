import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/router/app_router.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../../domain/entities/holiday.dart';
import '../../domain/repositories/holidays_repository.dart';
import '../../domain/usecases/create_holiday_usecase.dart';
import '../../domain/usecases/delete_holiday_usecase.dart';
import '../../domain/usecases/toggle_holiday_usecase.dart';
import '../../domain/usecases/update_holiday_usecase.dart';
import 'holidays_repository_providers.dart';

final Logger _holidaysLogger = Logger();

final createHolidayUseCaseProvider = Provider<CreateHolidayUseCase>((ref) {
  return CreateHolidayUseCase(
    repository: ref.watch(holidaysRepositoryProvider),
    logger: _holidaysLogger,
  );
});

final updateHolidayUseCaseProvider = Provider<UpdateHolidayUseCase>((ref) {
  return UpdateHolidayUseCase(
    repository: ref.watch(holidaysRepositoryProvider),
    logger: _holidaysLogger,
  );
});

final deleteHolidayUseCaseProvider = Provider<DeleteHolidayUseCase>((ref) {
  return DeleteHolidayUseCase(
    repository: ref.watch(holidaysRepositoryProvider),
    logger: _holidaysLogger,
  );
});

final toggleHolidayUseCaseProvider = Provider<ToggleHolidayUseCase>((ref) {
  return ToggleHolidayUseCase(
    repository: ref.watch(holidaysRepositoryProvider),
    logger: _holidaysLogger,
  );
});

class HolidaysScopeNotifier extends Notifier<HolidaysScope> {
  @override
  HolidaysScope build() => HolidaysScope.all;
  void set(HolidaysScope scope) => state = scope;
}

final holidaysScopeProvider =
    NotifierProvider<HolidaysScopeNotifier, HolidaysScope>(
  HolidaysScopeNotifier.new,
);

final presetHolidaysProvider = StreamProvider<List<Holiday>>((ref) {
  return ref.watch(holidaysRepositoryProvider).watchPresets();
});

final personalHolidaysProvider = StreamProvider<List<Holiday>>((ref) {
  return ref.watch(holidaysRepositoryProvider).watchPersonal(
        userId: ref.watch(currentUserIdProvider),
        spaceId: ref.watch(currentSpaceIdProvider),
        scope: ref.watch(holidaysScopeProvider),
      );
});

/// Палитра цветов праздника (ТЗ 6.3.8.4).
const List<String> holidayColorPalette = [
  '#F59E0B',
  '#EF4444',
  '#22C55E',
  '#3B82F6',
  '#A855F7',
  '#EC4899',
  '#14B8A6',
];