import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/features/debts/domain/usecases/decline_name_usecase.dart';
import 'package:budget_assistant/features/debts/domain/usecases/format_debt_title_usecase.dart';
import '../../../helpers/fake_debts_repository.dart';

/// Этап 24: офлайн-склонение имени в дательный падеж и заголовок долга.
void main() {
  late DeclineNameUseCase decline;
  late FormatDebtTitleUseCase format;

  setUp(() {
    decline = DeclineNameUseCase();
    format = FormatDebtTitleUseCase(declineName: decline);
  });

  group('DeclineNameUseCase', () {
    test('женское имя на -ия -> -ии', () {
      final r = decline('Мария');
      expect(r.dative, 'Марии');
      expect(r.success, isTrue);
    });

    test('мужское имя на согласный -> -у', () {
      final r = decline('Иван');
      expect(r.dative, 'Ивану');
      expect(r.success, isTrue);
    });

    test('фамилия на -ова -> -ой', () {
      final r = decline('Иванова');
      expect(r.dative, 'Ивановой');
      expect(r.success, isTrue);
    });

    test('отчество на -ич -> -у', () {
      final r = decline('Иванович');
      expect(r.dative, 'Ивановичу');
      expect(r.success, isTrue);
    });

    test('несклоняемое имя на -о остаётся как есть', () {
      final r = decline('Нико');
      expect(r.dative, 'Нико');
      expect(r.success, isTrue);
    });

    test('пустая строка -> success = false', () {
      final r = decline('');
      expect(r.success, isFalse);
      expect(r.dative, '');
    });

    test('регистр первой буквы сохраняется', () {
      final r = decline('мария');
      expect(r.dative[0], r.dative[0].toLowerCase());
    });
  });

  group('FormatDebtTitleUseCase', () {
    test('внешний контрагент: берётся готовое имя в дательном', () {
      final d = makeDebt(
        id: 'd1',
        debtorId: null,
        creditorId: 'me',
        createdBy: 'me',
        counterpartyNameDative: 'Ивану',
      );

      expect(format(debt: d), 'Ивану');
    });

    test('семейный долг: склоняется display_name участника', () {
      final d = makeDebt(
        id: 'd1',
        debtorId: 'other',
        creditorId: 'me',
        createdBy: 'me',
      );

      expect(format(debt: d, familyDisplayName: 'Мария'), 'Марии');
    });

    test('пустое имя участника -> пустой заголовок', () {
      final d = makeDebt(
        id: 'd1',
        debtorId: 'other',
        creditorId: 'me',
        createdBy: 'me',
      );

      expect(format(debt: d, familyDisplayName: ''), '');
    });
  });
}