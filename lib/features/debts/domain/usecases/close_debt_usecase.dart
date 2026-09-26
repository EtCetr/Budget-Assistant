import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';
import 'package:budget_assistant/features/transactions/domain/repositories/transactions_repository.dart';
import '../entities/debt.dart';
import '../repositories/debts_repository.dart';
import '../services/system_category_port.dart';

/// Закрытие долга с компенсирующими транзакциями (ТОМ 4 §6).
///
/// Ретро-пересчёт аналитики ЗАПРЕЩЁН (DECISIONS.md): история прошлых
/// месяцев не меняется, компенсации создаются текущей датой.
///
/// Сценарий А (закрытие в месяце исходной траты):
///   категория = категория исходной траты; должник -> expense,
///   кредитор -> income (личные лимиты месяца сходятся).
/// Сценарий Б (позже): системная категория SYSTEM_DEBT_REPAYMENT.
///
/// D13-3: компенсации пишутся с spaceId = NULL (личный контур),
/// поэтому семейная аналитика их не учитывает. Внешняя сторона долга
/// (NULL-сторона) компенсацию не получает.
class CloseDebtUseCase {
  CloseDebtUseCase({
    required DebtsRepository debtsRepository,
    required TransactionsRepository transactionsRepository,
    required SystemCategoryPort systemCategory,
    required Logger logger,
  })  : _debts = debtsRepository,
        _transactions = transactionsRepository,
        _systemCategory = systemCategory,
        _logger = logger;

  final DebtsRepository _debts;
  final TransactionsRepository _transactions;
  final SystemCategoryPort _systemCategory;
  final Logger _logger;

  /// [compensationAccountId] — счёт актёра, на котором отражаются
  /// компенсации (transactions.account_id NOT NULL).
  Future<void> call({
    required String debtId,
    required String actorUserId,
    required String compensationAccountId,
    String status = DebtResolutionStatus.resolved,
  }) async {
    try {
      final debt = await _debts.getById(debtId);
      if (debt == null) throw StateError('Debt not found: $debtId');
      if (!debt.isActive) throw StateError('Debt already closed: $debtId');
      if (debt.debtorId != actorUserId && debt.creditorId != actorUserId) {
        throw StateError('Actor is not a party of the debt: $debtId');
      }
      final now = DateTime.now().toUtc();

      // Месяц исходной траты: связанная транзакция, иначе дата создания.
      var originalDate = debt.createdAt;
      Transaction? originalTx;
      final originalTxId = debt.originalTransactionId;
      if (originalTxId != null) {
        originalTx = await _transactions.getTransactionById(originalTxId);
        if (originalTx != null) originalDate = originalTx.date;
      }
      final sameMonth =
          originalDate.year == now.year && originalDate.month == now.month;

      String? categoryId =
          sameMonth ? (debt.categoryId ?? originalTx?.customCategoryId) : null;
      categoryId ??= await _systemCategory.getOrCreateDebtRepaymentCategory(
        userId: actorUserId,
      );

      final compensations = <Transaction>[];
      final debtorId = debt.debtorId;
      if (debtorId != null) {
        compensations.add(
          Transaction(
            id: const Uuid().v4(),
            accountId: compensationAccountId,
            userId: debtorId,
            spaceId: null,
            date: now,
            amount: debt.amount,
            type: TransactionType.expense,
            customCategoryId: categoryId,
            merchantName: 'Погашение долга',
            comment: sameMonth
                ? 'Компенсация закрытия долга (сценарий А)'
                : 'Компенсация закрытия долга (сценарий Б)',
            isUserEdited: true,
            createdAt: now,
            updatedAt: now,
            syncStatus: SyncStatus.pending,
          ),
        );
      }
      final creditorId = debt.creditorId;
      if (creditorId != null) {
        compensations.add(
          Transaction(
            id: const Uuid().v4(),
            accountId: compensationAccountId,
            userId: creditorId,
            spaceId: null,
            date: now,
            amount: debt.amount,
            type: TransactionType.income,
            customCategoryId: categoryId,
            merchantName: 'Возврат долга',
            comment: sameMonth
                ? 'Компенсация закрытия долга (сценарий А)'
                : 'Компенсация закрытия долга (сценарий Б)',
            isUserEdited: true,
            createdAt: now,
            updatedAt: now,
            syncStatus: SyncStatus.pending,
          ),
        );
      }
      for (final tx in compensations) {
        await _transactions.createTransaction(tx, const []);
      }
      await _debts.resolve(debtId: debtId, status: status);
    } catch (e, st) {
      _logger.e('CloseDebtUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Авто-закрытие долгов, связанных с транзакцией (6.3.14.13 п.4.b):
  /// только активные долги с auto_resolve = TRUE, БЕЗ компенсаций
  /// (сама транзакция возврата и есть компенсация).
  Future<int> autoResolveLinked({required String transactionId}) async {
    try {
      return await _debts.resolveAutoLinked(transactionId: transactionId);
    } catch (e, st) {
      _logger.e('CloseDebtUseCase.autoResolveLinked failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}