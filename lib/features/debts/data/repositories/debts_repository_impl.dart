import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import '../../domain/entities/debt.dart';
import '../../domain/entities/debt_form_draft.dart';
import '../../domain/repositories/debts_repository.dart';
import '../datasources/debts_dao.dart';

class DebtsRepositoryImpl implements DebtsRepository {
  DebtsRepositoryImpl({required DebtsDao dao, required Logger logger})
      : _dao = dao,
        _logger = logger;

  final DebtsDao _dao;
  final Logger _logger;

  @override
  Stream<List<Debt>> watchForUser({required String userId}) {
    try {
      return _dao.watchForUser(userId).map((rows) => rows.map(_map).toList());
    } catch (e, st) {
      _logger.e('debts watchForUser failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<Debt?> getById(String debtId) async {
    try {
      final row = await _dao.getById(debtId);
      return row == null ? null : _map(row);
    } catch (e, st) {
      _logger.e('debts getById failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> insert(Debt debt) async {
    try {
      await _dao.insertDebt(_toDb(debt));
    } catch (e, st) {
      _logger.e('debts insert failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> update(Debt debt) async {
    try {
      await _dao.updateDebt(_toDb(debt));
    } catch (e, st) {
      _logger.e('debts update failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> delete(String debtId) async {
    try {
      await _dao.deleteDebt(debtId);
    } catch (e, st) {
      _logger.e('debts delete failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> resolve({
    required String debtId,
    required String status,
  }) async {
    try {
      await _dao.resolve(debtId, status);
    } catch (e, st) {
      _logger.e('debts resolve failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> extendDueDate({
    required String debtId,
    required DateTime newDueDateUtc,
  }) async {
    try {
      await _dao.extendDueDate(debtId, newDueDateUtc);
    } catch (e, st) {
      _logger.e('debts extendDueDate failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<int> markExMember({required String memberUserId}) async {
    try {
      return await _dao.markExMember(memberUserId);
    } catch (e, st) {
      _logger.e('debts markExMember failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<DebtFormDraft?> getFreshDraft(String userId) async {
    try {
      final since = DateTime.now().toUtc().subtract(const Duration(hours: 24));
      final row = await _dao.getFreshDraft('debt_draft_$userId', since);
      if (row == null) return null;
      return DebtFormDraft.fromJson(
        jsonDecode(row.formDataJson) as Map<String, dynamic>,
      );
    } on FormatException catch (e) {
      _logger.w('Corrupt debt draft ignored: $e');
      return null;
    } catch (e, st) {
      _logger.e('debts getFreshDraft failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> saveDraft(String userId, DebtFormDraft draft) async {
    try {
      final now = DateTime.now().toUtc();
      await _dao.upsertDraft(
        id: 'debt_draft_$userId',
        userId: userId,
        debtId: draft.debtId,
        formDataJson: jsonEncode(draft.toJson()),
        updatedAt: now,
      );
      await _dao.cleanupOldDrafts(now.subtract(const Duration(days: 7)));
    } catch (e, st) {
      _logger.e('debts saveDraft failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> deleteDraftByUser(String userId) async {
    try {
      await _dao.deleteDraft('debt_draft_$userId');
    } catch (e, st) {
      _logger.e('debts deleteDraft failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<int> resolveAutoLinked({required String transactionId}) async {
    try {
      return await _dao.resolveAutoLinked(transactionId);
    } catch (e, st) {
      _logger.e('debts resolveAutoLinked failed', error: e, stackTrace: st);
      rethrow;
    }
  }
  Debt _map(DebtDb db) => Debt(
        id: db.id,
        creditorId: db.creditorId,
        debtorId: db.debtorId,
        spaceId: db.spaceId,
        categoryId: db.categoryId,
        amount: db.amount,
        currency: db.currency,
        description: db.description,
        counterpartyNameDative: db.counterpartyNameDative,
        originalTransactionId: db.originalTransactionId,
        splitId: db.splitId,
        dueDate: db.dueDate,
        resolvedAt: db.resolvedAt,
        resolutionStatus: db.resolutionStatus,
        isExMemberDebt: db.isExMemberDebt,
        autoResolve: db.autoResolve,
        createdBy: db.createdBy,
        createdAt: db.createdAt,
        updatedAt: db.updatedAt,
        syncStatus: db.syncStatus,
      );

  DebtDb _toDb(Debt d) => DebtDb(
        id: d.id,
        creditorId: d.creditorId,
        debtorId: d.debtorId,
        spaceId: d.spaceId,
        categoryId: d.categoryId,
        amount: d.amount,
        currency: d.currency,
        description: d.description,
        counterpartyNameDative: d.counterpartyNameDative,
        originalTransactionId: d.originalTransactionId,
        splitId: d.splitId,
        dueDate: d.dueDate,
        resolvedAt: d.resolvedAt,
        resolutionStatus: d.resolutionStatus,
        isExMemberDebt: d.isExMemberDebt,
        autoResolve: d.autoResolve,
        createdBy: d.createdBy,
        createdAt: d.createdAt,
        updatedAt: d.updatedAt,
        syncStatus: d.syncStatus,
      );



}