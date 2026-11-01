import 'package:flutter/widgets.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:logger/logger.dart';
import 'package:workmanager/workmanager.dart';
import 'package:budget_assistant/core/database/daos/app_settings_dao.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/services/secure_storage_service.dart';
import 'package:budget_assistant/features/sync/application/sync_background_database.dart';
import 'package:budget_assistant/features/year_in_review/data/datasources/yearly_aggregates_dao.dart';
import 'package:budget_assistant/features/year_in_review/data/repositories/yearly_aggregates_repository_impl.dart';
import 'package:budget_assistant/features/year_in_review/domain/usecases/recalculate_yearly_aggregates_usecase.dart';

const String yearlyAggregatesTaskName = 'budget_assistant_yearly_aggregates';

/// Фоновый пересчёт годовых итогов (6.3.37.4): 1-е число месяца и 27 декабря.
/// Запускается каждые 12 часов, но реально считает только в нужные дни.
@pragma('vm:entry-point')
Future<bool> handleYearlyAggregatesTask() async {
  WidgetsFlutterBinding.ensureInitialized();
  final now = DateTime.now();
  final isMonthly = now.day == 1;
  final isYearFinal = now.month == 12 && now.day >= 27;
  if (!isMonthly && !isYearFinal) return true;

  final storage = SecureStorageService();
  final uid = await storage.read('current_user_id');
  if (uid == null || uid.isEmpty) return true;

  final db = await openSyncDatabaseInBackground();
  try {
    final logger = Logger();
    final settings = await AppSettingsDao(db).getForUser(uid);
    final useCase = RecalculateYearlyAggregatesUseCase(
      repository: YearlyAggregatesRepositoryImpl(
        dao: YearlyAggregatesDao(db),
        logger: logger,
      ),
      logger: logger,
    );
    // Личная статистика.
    await useCase(
      userId: uid,
      year: now.year,
      spaceId: null,
      baseCurrency: settings.baseCurrency,
    );
    // Каждое активное пространство.
    final spaces = await db.customSelect(
      "SELECT space_id FROM memberships WHERE user_id = ? AND status = 'active'",
      variables: [Variable(uid)],
    ).get();
    for (final s in spaces) {
      final spaceId = s.readNullable<String>('space_id');
      if (spaceId == null) continue;
      await useCase(
        userId: uid,
        year: now.year,
        spaceId: spaceId,
        baseCurrency: settings.baseCurrency,
      );
    }
    AppLogger.i('YearlyAggregates: recalculated for ${spaces.length + 1} scopes');
    return true;
  } catch (e, st) {
    AppLogger.e('YearlyAggregatesTask failed', e, st);
    return false;
  } finally {
    await db.close();
  }
}

/// Регистрация фоновых задач пересчёта.
class YearlyAggregatesWorker {
  static Future<void> register() async {
    try {
      await Workmanager().registerPeriodicTask(
        yearlyAggregatesTaskName,
        yearlyAggregatesTaskName,
        existingWorkPolicy: ExistingWorkPolicy.keep,
        frequency: const Duration(hours: 12),
        initialDelay: const Duration(seconds: 45),
      );
      await Workmanager().registerOneOffTask(
        '${yearlyAggregatesTaskName}_boot',
        yearlyAggregatesTaskName,
        existingWorkPolicy: ExistingWorkPolicy.replace,
        initialDelay: const Duration(seconds: 30),
      );
      AppLogger.i('YearlyAggregatesWorker registered');
    } catch (e, st) {
      AppLogger.e('YearlyAggregatesWorker register failed', e, st);
    }
  }
}