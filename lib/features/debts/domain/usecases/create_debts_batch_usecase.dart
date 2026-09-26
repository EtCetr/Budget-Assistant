import 'dart:math';
import 'package:budget_assistant/core/logger.dart';
import '../entities/debt.dart';
import '../repositories/debts_repository.dart';

/// Создание долгов из формы 6.3.14: по записи на каждого выбранного
/// члена семьи; сумма делится ПОРОВНУ (копейки вниз, остаток первому),
/// либо один долг с внешним контрагентом (D13-2: NULL-сторона + имя).
class CreateDebtsBatchUseCase {
  CreateDebtsBatchUseCase({required DebtsRepository repository})
      : _repository = repository;

  final DebtsRepository _repository;

  Future<List<Debt>> call({
    required String creatorUserId,
    required String? spaceId,
    /// 'payable' (я должен) | 'receivable' (мне должны).
    required String debtType,
    required List<String> memberIds,
    String? externalNameDative,
    required int amountKopecks,
    String currency = 'RUB',
    String? categoryId,
    String? description,
    DateTime? dueDateUtc,
    String? originalTransactionId,
    String? splitId,
    bool autoResolve = true,
  }) async {
    try {
      if (amountKopecks <= 0) {
        throw ArgumentError('amountKopecks must be > 0');
      }
      final external = (externalNameDative ?? '').trim();
      final members = memberIds.where((id) => id != creatorUserId).toList();
      if (members.isEmpty && external.isEmpty) {
        throw ArgumentError('counterparty is required');
      }
      if (members.length > 1 && amountKopecks < members.length) {
        throw ArgumentError('amount too small to split');
      }
      final now = DateTime.now().toUtc();
      final debts = <Debt>[];

      if (members.isNotEmpty) {
        final perPerson = amountKopecks ~/ members.length;
        final remainder = amountKopecks % members.length;
        for (var i = 0; i < members.length; i++) {
          final share = perPerson + (i == 0 ? remainder : 0);
          final debtor = debtType == 'payable' ? creatorUserId : members[i];
          final creditor = debtType == 'payable' ? members[i] : creatorUserId;
          debts.add(
            Debt(
              id: _newId(),
              creditorId: creditor,
              debtorId: debtor,
              spaceId: spaceId,
              categoryId: categoryId,
              amount: share,
              currency: currency,
              description: description,
              dueDate: dueDateUtc,
              originalTransactionId: originalTransactionId,
              splitId: splitId,
              autoResolve: autoResolve,
              createdBy: creatorUserId,
              createdAt: now,
              updatedAt: now,
            ),
          );
        }
      } else {
        final debtor = debtType == 'payable' ? creatorUserId : null;
        final creditor = debtType == 'payable' ? null : creatorUserId;
        debts.add(
          Debt(
            id: _newId(),
            creditorId: creditor,
            debtorId: debtor,
            spaceId: spaceId,
            categoryId: categoryId,
            amount: amountKopecks,
            currency: currency,
            description: description,
            counterpartyNameDative: external,
            dueDate: dueDateUtc,
            originalTransactionId: originalTransactionId,
            splitId: splitId,
            autoResolve: autoResolve,
            createdBy: creatorUserId,
            createdAt: now,
            updatedAt: now,
          ),
        );
      }

      for (final d in debts) {
        await _repository.insert(d);
      }
      return debts;
    } catch (e, st) {
      AppLogger.e('CreateDebtsBatchUseCase failed: $e', e, st);
      rethrow;
    }
  }

  String _newId() =>
      'debt_${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}'
      '_${_counter = (_counter + 1) % 1296}'
      '${_rnd.nextInt(46656).toRadixString(36).padLeft(3, '0')}';
  static int _counter = 0;
  static final _rnd = Random();
}