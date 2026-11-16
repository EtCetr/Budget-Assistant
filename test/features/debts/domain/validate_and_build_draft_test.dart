import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/features/debts/domain/usecases/build_debt_draft_usecase.dart';
import 'package:budget_assistant/features/debts/domain/usecases/validate_debt_form_usecase.dart';
import '../../../helpers/fake_debts_repository.dart';

/// Этап 24: ValidateDebtFormUseCase + BuildDebtDraftUseCase.
void main() {
  late ValidateDebtFormUseCase validate;
  late BuildDebtDraftUseCase build;

  setUp(() {
    validate = ValidateDebtFormUseCase();
    build = BuildDebtDraftUseCase();
  });

  group('ValidateDebtFormUseCase', () {
    test('пустой контрагент -> ошибка', () {
      final err = validate(makeDraft(
        selectedMemberIds: const [],
        externalNameDative: '',
      ));
      expect(err, contains('Выберите'));
    });

    test('слишком длинное внешнее имя -> ошибка', () {
      final err = validate(makeDraft(
        selectedMemberIds: const [],
        externalNameDative: 'А' * 51,
      ));
      expect(err, contains('50'));
    });

    test('нулевая сумма -> ошибка', () {
      final err = validate(makeDraft(amount: 0));
      expect(err, contains('больше'));
    });

    test('сумма меньше числа членов -> ошибка', () {
      final err = validate(makeDraft(
        amount: 1,
        selectedMemberIds: const ['m1', 'm2'],
      ));
      expect(err, contains('мала'));
    });

    test('слишком длинное описание -> ошибка', () {
      final err = validate(makeDraft(description: 'А' * 201));
      expect(err, contains('200'));
    });

    test('дедлайн в прошлом у новой цели -> ошибка', () {
      final err = validate(makeDraft(
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
      ));
      expect(err, contains('не раньше'));
    });

    test('дедлайн в прошлом при редактировании допустим', () {
      final err = validate(makeDraft(
        debtId: 'd1',
        dueDate: DateTime.now().subtract(const Duration(days: 1)),
      ));
      expect(err, isNull);
    });

    test('валидный черновик -> null', () {
      expect(validate(makeDraft()), isNull);
    });
  });

  group('BuildDebtDraftUseCase', () {
    test('пробелы в имени и описании обрезаются', () {
      final d = build(
        debtType: 'payable',
        counterpartyType: 'external',
        selectedMemberIds: const [],
        externalName: '  Ивану  ',
        amountKopecks: 100000,
        currency: 'RUB',
        description: '  за обед  ',
        autoResolve: true,
      );
      expect(d.externalNameDative, 'Ивану');
      expect(d.description, 'за обед');
    });

    test('updatedAt в UTC', () {
      final d = build(
        debtType: 'payable',
        counterpartyType: 'family_member',
        selectedMemberIds: const ['m1'],
        externalName: '',
        amountKopecks: 100000,
        currency: 'RUB',
        description: '',
        autoResolve: true,
      );
      expect(d.updatedAt.isUtc, isTrue);
    });
  });
}