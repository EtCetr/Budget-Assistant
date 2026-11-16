import 'package:budget_assistant/features/debts/domain/entities/debt.dart';
import 'package:budget_assistant/features/debts/domain/entities/debt_form_draft.dart';
import 'package:budget_assistant/features/debts/domain/repositories/debts_repository.dart';

/// Этап 24: заглушка репозитория долгов для доменных тестов.
/// Деньги — целые копейки, даты — UTC.
class FakeDebtsRepository implements DebtsRepository {
  final Map<String, Debt> debts = <String, Debt>{};
  DebtFormDraft? draft;

  Object? error;
  final List<String> calls = <String>[];
  final List<({String debtId, String status})> resolves =
      <({String debtId, String status})>[];
  final List<({String debtId, DateTime due})> extensions =
      <({String debtId, DateTime due})>[];
  final List<String> markedExMember = <String>[];
  final List<String> autoResolved = <String>[];

  void _enter(String name) {
    calls.add(name);
    final e = error;
    if (e != null) throw e;
  }

  @override
  Stream<List<Debt>> watchForUser({required String userId}) =>
      Stream.value(debts.values
          .where((d) => d.debtorId == userId || d.creditorId == userId)
          .toList());

  @override
  Future<Debt?> getById(String debtId) async {
    _enter('getById');
    return debts[debtId];
  }

  @override
  Future<void> insert(Debt debt) async {
    _enter('insert');
    debts[debt.id] = debt;
  }

  @override
  Future<void> update(Debt debt) async {
    _enter('update');
    debts[debt.id] = debt;
  }

  @override
  Future<void> delete(String debtId) async {
    _enter('delete');
    debts.remove(debtId);
  }

  @override
  Future<void> resolve({required String debtId, required String status}) async {
    _enter('resolve');
    resolves.add((debtId: debtId, status: status));
    final d = debts[debtId];
    if (d != null) {
      debts[debtId] = d.copyWith(
        resolutionStatus: status,
        resolvedAt: DateTime.utc(2026, 7, 15),
        updatedAt: DateTime.utc(2026, 7, 15),
      );
    }
  }

  @override
  Future<void> extendDueDate({
    required String debtId,
    required DateTime newDueDateUtc,
  }) async {
    _enter('extendDueDate');
    extensions.add((debtId: debtId, due: newDueDateUtc));
  }

  @override
  Future<int> markExMember({required String memberUserId}) async {
    _enter('markExMember');
    markedExMember.add(memberUserId);
    return debts.values
        .where((d) =>
            (d.debtorId == memberUserId || d.creditorId == memberUserId) &&
            d.isActive)
        .length;
  }

  @override
  Future<int> resolveAutoLinked({required String transactionId}) async {
    _enter('resolveAutoLinked');
    autoResolved.add(transactionId);
    return 0;
  }

  @override
  Future<DebtFormDraft?> getFreshDraft(String userId) async {
    _enter('getFreshDraft');
    return draft;
  }

  @override
  Future<void> saveDraft(String userId, DebtFormDraft draft) async {
    _enter('saveDraft');
    this.draft = draft;
  }

  @override
  Future<void> deleteDraftByUser(String userId) async {
    _enter('deleteDraftByUser');
    draft = null;
  }
}

/// Фабрика долга для тестов. [createdAt] важен для Сценариев А/Б:
/// месяц создания долга сравнивается с месяцем закрытия.
Debt makeDebt({
  required String id,
  String? creditorId = 'cred',
  String? debtorId = 'debt',
  String? spaceId,
  String? categoryId = 'c1',
  int amount = 100000,
  String currency = 'RUB',
  String? description,
  String? counterpartyNameDative,
  String? originalTransactionId,
  String? splitId,
  DateTime? dueDate,
  DateTime? resolvedAt,
  DateTime? createdAt,
  String resolutionStatus = DebtResolutionStatus.active,
  bool isExMemberDebt = false,
  bool autoResolve = true,
  required String createdBy,
}) =>
    Debt(
      id: id,
      creditorId: creditorId,
      debtorId: debtorId,
      spaceId: spaceId,
      categoryId: categoryId,
      amount: amount,
      currency: currency,
      description: description,
      counterpartyNameDative: counterpartyNameDative,
      originalTransactionId: originalTransactionId,
      splitId: splitId,
      dueDate: dueDate,
      resolvedAt: resolvedAt,
      resolutionStatus: resolutionStatus,
      isExMemberDebt: isExMemberDebt,
      autoResolve: autoResolve,
      createdBy: createdBy,
      createdAt: createdAt ?? DateTime.utc(2026, 7, 1),
      updatedAt: DateTime.utc(2026, 7, 1),
    );

/// Фабрика черновика формы долга.
DebtFormDraft makeDraft({
  String? debtId,
  String debtType = 'payable',
  String counterpartyType = 'family_member',
  List<String> selectedMemberIds = const ['m1'],
  String externalNameDative = '',
  int? amount = 100000,
  String currency = 'RUB',
  String? categoryId = 'c1',
  String description = '',
  DateTime? dueDate,
  String? originalTransactionId,
  String? splitId,
  bool autoResolveOnLink = true,
}) =>
    DebtFormDraft(
      debtId: debtId,
      debtType: debtType,
      counterpartyType: counterpartyType,
      selectedMemberIds: selectedMemberIds,
      externalNameDative: externalNameDative,
      amount: amount,
      currency: currency,
      categoryId: categoryId,
      description: description,
      dueDate: dueDate,
      originalTransactionId: originalTransactionId,
      splitId: splitId,
      autoResolveOnLink: autoResolveOnLink,
      updatedAt: DateTime.utc(2026, 7, 15),
    );