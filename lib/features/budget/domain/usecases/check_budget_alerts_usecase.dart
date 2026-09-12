import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/daos/notifications_dao.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import '../repositories/budget_limits_repository.dart';

class CheckBudgetAlertsUseCase {
  final BudgetLimitsRepository _repository;
  final NotificationsDao _notificationsDao;
  final Logger _logger;

  const CheckBudgetAlertsUseCase({
    required BudgetLimitsRepository repository,
    required NotificationsDao notificationsDao,
    required Logger logger,
  })  : _repository = repository,
        _notificationsDao = notificationsDao,
        _logger = logger;

  Future<Result<void>> call({
    required String userId,
    String? spaceId,
    required int year,
    required int month,
    required String alertMode,
    required int globalAlertPercent,
    required int globalAlertAmount,
  }) async {
    try {
      final limits = await _repository.getForMonth(
        userId: userId,
        spaceId: spaceId,
        year: year,
        month: month,
      );

      final pnlResult = await _repository.calculateMonthlyPnl(
        userId: userId,
        spaceId: spaceId,
        year: year,
        month: month,
      );
      final totalExpense = pnlResult.fold(
        onSuccess: (pnl) => pnl.totalExpense,
        onError: (_) => 0,
      );

      int totalLimit = 0;
      for (final limit in limits) {
        totalLimit += limit.limitAmount;
      }

      if (alertMode == 'global_percent' && totalLimit > 0) {
        final threshold = (totalLimit * globalAlertPercent) ~/ 100;
        if (totalExpense >= threshold) {
          await _createAlertIfNotDuplicate(
            userId: userId,
            spaceId: spaceId,
            type: 'limit_global_percent',
            title: '⚠️ Бюджет под угрозой',
            body: 'Потрачено $globalAlertPercent% месячного бюджета',
            relatedEntityId: null,
          );
        }
      } else if (alertMode == 'global_amount' && totalLimit > 0) {
        final remaining = totalLimit - totalExpense;
        if (remaining <= globalAlertAmount && remaining >= 0) {
          await _createAlertIfNotDuplicate(
            userId: userId,
            spaceId: spaceId,
            type: 'limit_global_amount',
            title: '📉 До лимита осталось мало',
            body: 'До конца бюджета осталось ${globalAlertAmount ~/ 100} ₽',
            relatedEntityId: null,
          );
        }
      }

      if (alertMode == 'individual') {
        for (final limit in limits) {
          final expenseResult = await _repository.calculateCategoryExpense(
            userId: userId,
            spaceId: spaceId,
            categoryId: limit.categoryId,
            year: year,
            month: month,
          );
          final expense = expenseResult.fold(
            onSuccess: (value) => value,
            onError: (_) => 0,
          );

          if (limit.alertPercent > 0 && limit.limitAmount > 0) {
            final threshold = (limit.limitAmount * limit.alertPercent) ~/ 100;
            if (expense >= threshold) {
              await _createAlertIfNotDuplicate(
                userId: userId,
                spaceId: spaceId,
                type: 'limit_individual',
                title: '🛒 Лимит категории почти исчерпан',
                body: 'Потрачено ${limit.alertPercent}% лимита категории',
                relatedEntityId: limit.categoryId,
              );
            }
          }

          if (limit.alertAmount > 0 && limit.limitAmount > 0) {
            final remaining = limit.limitAmount - expense;
            if (remaining <= limit.alertAmount && remaining >= 0) {
              await _createAlertIfNotDuplicate(
                userId: userId,
                spaceId: spaceId,
                type: 'limit_individual',
                title: '📉 Лимит категории заканчивается',
                body: 'До конца лимита категории осталось ${limit.alertAmount ~/ 100} ₽',
                relatedEntityId: limit.categoryId,
              );
            }
          }
        }
      }

      return const Success(null);
    } catch (e, stack) {
      _logger.e('CheckBudgetAlertsUseCase failed', error: e, stackTrace: stack);
      return Error(Failure.database(e.toString(), stack));
    }
  }

  Future<void> _createAlertIfNotDuplicate({
    required String userId,
    String? spaceId,
    required String type,
    required String title,
    required String body,
    String? relatedEntityId,
  }) async {
    final cutoff = DateTime.now().toUtc().subtract(const Duration(hours: 24));
    final existing = await _notificationsDao.db.customSelect(
      '''
      SELECT COUNT(*) AS cnt FROM notifications
      WHERE user_id = ? AND type = ? AND related_entity_id = ?
        AND created_at > ?
      ''',
      variables: [
        Variable.withString(userId),
        Variable.withString(type),
        Variable.withString(relatedEntityId ?? ''),
        Variable.withDateTime(cutoff),
      ],
    ).getSingle();

    if (existing.read<int>('cnt') > 0) {
      _logger.d('Alert already exists within 24h: $type');
      return;
    }

    final notification = Notification(
      id: const Uuid().v4(),
      userId: userId,
      spaceId: spaceId,
      type: type,
      title: title,
      body: body,
      isRead: false,
      relatedEntityId: relatedEntityId,
      actionTaken: null,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
      syncStatus: 'pending',
    );

    await _notificationsDao.insert(notification);
    _logger.i('Budget alert created: $type');
  }
}