import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';
import 'package:budget_assistant/core/services/secure_flag_service.dart';
import 'package:budget_assistant/features/admin/presentation/providers/admin_providers.dart';
import '../../data/datasources/yearly_aggregates_dao.dart';
import '../../data/repositories/yearly_aggregates_repository_impl.dart';
import '../../domain/models/year_in_review_data.dart';
import '../../domain/models/yearly_aggregate.dart';
import '../../domain/usecases/get_available_years_usecase.dart';
import '../../domain/repositories/yearly_aggregates_repository.dart';
import '../../domain/usecases/calculate_year_in_review_usecase.dart';
import '../../domain/usecases/check_year_in_review_availability_usecase.dart';
import '../../domain/usecases/mark_year_in_review_as_viewed_usecase.dart';
import '../../domain/usecases/recalculate_yearly_aggregates_usecase.dart';
import '../../domain/usecases/share_year_in_review_slide_usecase.dart';

final Logger _logger = Logger();

/// Ключ запроса «год + пространство» для family-провайдера.
class YearReviewQuery {
  const YearReviewQuery({required this.year, required this.spaceId});

  final int year;
  final String? spaceId;

  @override
  bool operator ==(Object other) =>
      other is YearReviewQuery &&
      other.year == year &&
      other.spaceId == spaceId;

  @override
  int get hashCode => Object.hash(year, spaceId);
}

final yearlyAggregatesDaoProvider = Provider<YearlyAggregatesDao>(
  (ref) => YearlyAggregatesDao(ref.watch(appDatabaseProvider)),
);

final yearlyAggregatesRepositoryProvider =
    Provider<YearlyAggregatesRepository>((ref) {
  return YearlyAggregatesRepositoryImpl(
    dao: ref.watch(yearlyAggregatesDaoProvider),
    logger: _logger,
  );
});

final secureFlagServiceProvider =
    Provider<SecureFlagService>((ref) => SecureFlagService());

final recalculateYearlyAggregatesUseCaseProvider =
    Provider<RecalculateYearlyAggregatesUseCase>((ref) {
  return RecalculateYearlyAggregatesUseCase(
    repository: ref.watch(yearlyAggregatesRepositoryProvider),
    logger: _logger,
  );
});

final calculateYearInReviewUseCaseProvider =
    Provider<CalculateYearInReviewUseCase>((ref) {
  return CalculateYearInReviewUseCase(
    repository: ref.watch(yearlyAggregatesRepositoryProvider),
    recalculate: ref.watch(recalculateYearlyAggregatesUseCaseProvider),
    settingsDao: ref.watch(appSettingsDaoProvider),
    logger: _logger,
  );
});

final markYearInReviewAsViewedUseCaseProvider =
    Provider<MarkYearInReviewAsViewedUseCase>((ref) {
  return MarkYearInReviewAsViewedUseCase(
    repository: ref.watch(yearlyAggregatesRepositoryProvider),
    logger: _logger,
  );
});

final checkYearInReviewAvailabilityUseCaseProvider =
    Provider<CheckYearInReviewAvailabilityUseCase>((ref) {
  return CheckYearInReviewAvailabilityUseCase(
    repository: ref.watch(yearlyAggregatesRepositoryProvider),
    recalculate: ref.watch(recalculateYearlyAggregatesUseCaseProvider),
    settingsDao: ref.watch(appSettingsDaoProvider),
    logger: _logger,
  );
});

final shareYearInReviewSlideUseCaseProvider =
    Provider<ShareYearInReviewSlideUseCase>((ref) {
  return ShareYearInReviewSlideUseCase(
    logger: _logger,
    secureFlag: ref.watch(secureFlagServiceProvider),
    adminRepository: ref.watch(adminRepositoryProvider),
  );
});

/// Выбранное пространство на слайде Welcome (null = «Только я»).
class YearReviewSpaceNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void select(String? spaceId) => state = spaceId;
}

final yearReviewSpaceProvider =
    NotifierProvider<YearReviewSpaceNotifier, String?>(
  YearReviewSpaceNotifier.new,
);

/// Годовые итоги для экрана (кэш или расчёт на лету).
final yearInReviewDataProvider =
    FutureProvider.family<YearInReviewData?, YearReviewQuery>((ref, query) {
  final useCase = ref.watch(calculateYearInReviewUseCaseProvider);
  final userId = ref.watch(currentUserIdProvider);
  return useCase(
    userId: userId,
    year: query.year,
    spaceId: query.spaceId,
  );
});

/// Настройки пользователя для шеринга (PIN / защита экрана).
final yearReviewSettingsProvider = FutureProvider<AppSetting?>((ref) async {
  try {
    final dao = ref.watch(appSettingsDaoProvider);
    final userId = ref.watch(currentUserIdProvider);
    return await dao.getForUser(userId);
  } catch (e, st) {
    AppLogger.e('yearReviewSettings failed', e, st);
    return null;
  }
});

/// Какие слайды реально показываем (условный показ по данным, ТЗ 6.3.37.11).
/// Прогресс-бар подстраивается под длину этого списка.
enum YearReviewSlideType {
  welcome,
  income,
  expense,
  topCategories,
  generousDay,
  investments,
  savings,
  cashback,
  family,
  subscriptions,
  savingsRate,
  finale,
  littleData,
}

final yearReviewSlidesProvider =
    Provider.family<List<YearReviewSlideType>, YearReviewQuery>((ref, query) {
  final data = ref.watch(yearInReviewDataProvider(query)).value;
  if (data == null || data.transactionCount == 0) {
    return const [YearReviewSlideType.welcome];
  }
  if (data.transactionCount < 10) {
    return const [
      YearReviewSlideType.welcome,
      YearReviewSlideType.littleData,
      YearReviewSlideType.finale,
    ];
  }
  final slides = <YearReviewSlideType>[YearReviewSlideType.welcome];
  if (data.totalIncome > 0) slides.add(YearReviewSlideType.income);
  if (data.totalExpense > 0) slides.add(YearReviewSlideType.expense);
  if (data.topCategories.isNotEmpty) {
    slides.add(YearReviewSlideType.topCategories);
  }
  if (data.mostGenerousDay != null) {
    slides.add(YearReviewSlideType.generousDay);
  }
  if (data.netInvested > 0) slides.add(YearReviewSlideType.investments);
  if (data.totalSaved > 0 || data.goalsTotal > 0) {
    slides.add(YearReviewSlideType.savings);
  }
  if (data.cashbackTotal > 0) slides.add(YearReviewSlideType.cashback);
  if (data.isFamily && data.familyTotalExpense > 0) {
    slides.add(YearReviewSlideType.family);
  }
  if (data.subscriptionsTotal > 0) {
    slides.add(YearReviewSlideType.subscriptions);
  }
  if (data.totalIncome > 0) slides.add(YearReviewSlideType.savingsRate);
  slides.add(YearReviewSlideType.finale);
  return slides;
});

/// Шеринг доступен во всех режимах, кроме hidden (Privacy Matrix 6.3.37).
final yearReviewCanShareProvider = Provider<bool>((ref) {
  final mode = ref.watch(privacyModeProvider);
  return mode != BalanceVisibilityMode.hidden;
});

final getAvailableYearsUseCaseProvider =
    Provider<GetAvailableYearsUseCase>((ref) {
  return GetAvailableYearsUseCase(
    repository: ref.watch(yearlyAggregatesRepositoryProvider),
    logger: _logger,
  );
});

/// Годы с данными для экрана «Статистика по годам».
final availableYearsProvider =
    FutureProvider<List<YearInReviewYearInfo>>((ref) {
  final useCase = ref.watch(getAvailableYearsUseCaseProvider);
  final userId = ref.watch(currentUserIdProvider);
  return useCase(userId: userId);
});

