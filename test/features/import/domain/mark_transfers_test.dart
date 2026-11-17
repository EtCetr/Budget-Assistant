import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/features/import/domain/entities/parsed_row.dart';
import 'package:budget_assistant/features/import/domain/entities/transfer_profile.dart';
import 'package:budget_assistant/features/import/domain/usecases/mark_transfers_usecase.dart';

/// Этап 24: пометка переводов при импорте (без объединений).
/// Критерий (ИЛИ): маркер / телефон (последние 10 цифр) / >=2 из 3 токенов ФИО.
ParsedRow _row(String merchant, {int index = 0}) => ParsedRow(
      rowIndex: index,
      date: DateTime.utc(2026, 7, 1),
      amountKopecks: -100000,
      merchantName: merchant,
    );

void main() {
  late MarkTransfersUseCase useCase;

  setUp(() {
    useCase = MarkTransfersUseCase();
  });

  bool marked(String merchant, TransferProfile profile) => useCase(
        rows: [_row(merchant)],
        profile: profile,
      ).single.isTransfer;

  group('Маркеры банка', () {
    test('«между счетами одного клиента»', () {
      expect(
        marked('Перевод между счетами одного клиента', const TransferProfile()),
        isTrue,
      );
    });

    test('«на свой счёт» в любом регистре', () {
      expect(
        marked('ПЕРЕВОД НА СВОЙ СЧЁТ', const TransferProfile()),
        isTrue,
      );
    });

    test('«пополнение. система быстрых платежей»', () {
      expect(
        marked(
          'Пополнение. Система быстрых платежей',
          const TransferProfile(),
        ),
        isTrue,
      );
    });

    test('обычный мерчант не помечается', () {
      expect(marked('Пятёрочка', const TransferProfile()), isFalse);
    });
  });

  group('Телефоны', () {
    const profile = TransferProfile(myPhones: ['+7 (999) 123-45-67']);

    test('последние 10 цифров совпадают', () {
      expect(marked('Перевод на 8 999 123-45-67', profile), isTrue);
    });

    test('короткий номер не участвует в детекте', () {
      expect(
        marked('Перевод 12345', const TransferProfile(myPhones: ['12345'])),
        isFalse,
      );
    });

    test('чужой номер не помечается', () {
      expect(marked('Перевод 8 911 222-33-44', profile), isFalse);
    });
  });

  group('ФИО', () {
    const profile = TransferProfile(myNames: ['Иванов Иван Иванович']);

    test('два токена из трёх достаточно', () {
      expect(marked('Перевод Иванов Иван', profile), isTrue);
    });

    test('ни одного токена — не перевод', () {
      expect(marked('Перевод Петров', profile), isFalse);
    });

    test('одно слово в профиле ищется как подстрока', () {
      expect(
        marked(
          'Перевод Иванов',
          const TransferProfile(myNames: ['Иванов']),
        ),
        isTrue,
      );
    });
  });

  group('Семейные контакты', () {
    const family = FamilyGroup(
      name: 'Семья',
      members: [
        FamilyMember(name: 'Петрова Анна', phones: ['+7 911 222-33-44']),
      ],
    );

    test('выключенный тумблер — семейные телефоны не участвуют', () {
      expect(
        marked(
          'Перевод 8 911 222-33-44',
          const TransferProfile(families: [family]),
        ),
        isFalse,
      );
    });

    test('включённый тумблер — семейный телефон помечает перевод', () {
      expect(
        marked(
          'Перевод 8 911 222-33-44',
          const TransferProfile(families: [family], familyAsTransfers: true),
        ),
        isTrue,
      );
    });

    test('включённый тумблер — семейное ФИО помечает перевод', () {
      expect(
        marked(
          'Перевод Петрова Анна',
          const TransferProfile(families: [family], familyAsTransfers: true),
        ),
        isTrue,
      );
    });
  });

  test('остальные поля строки не меняются', () {
    final source = ParsedRow(
      rowIndex: 7,
      date: DateTime.utc(2026, 7, 5, 12),
      amountKopecks: -250000,
      merchantName: 'Перевод на свой счёт',
      bankCategory: 'Переводы',
    );

    final result = useCase(
      rows: [source],
      profile: const TransferProfile(),
    ).single;

    expect(result.isTransfer, isTrue);
    expect(result.rowIndex, 7);
    expect(result.amountKopecks, -250000);
    expect(result.date, source.date);
    expect(result.bankCategory, 'Переводы');
  });

  group('TransferProfile', () {
    test('JSON round-trip сохраняет семьи и тумблер', () {
      const profile = TransferProfile(
        myPhones: ['+7 999 123-45-67'],
        myNames: ['Иванов Иван'],
        familyAsTransfers: true,
        families: [
          FamilyGroup(name: 'Семья', members: [
            FamilyMember(name: 'Петрова Анна', phones: ['+7 911 222-33-44']),
          ]),
        ],
      );

      final restored = TransferProfile.fromJson(profile.toJson());

      expect(restored.myPhones, profile.myPhones);
      expect(restored.myNames, profile.myNames);
      expect(restored.familyAsTransfers, isTrue);
      expect(restored.families.single.members.single.name, 'Петрова Анна');
      expect(restored.effectivePhones().length, 2);
      expect(restored.effectiveNames().length, 2);
    });

    test('пустой JSON даёт пустой профиль', () {
      final profile = TransferProfile.fromJson(const {});

      expect(profile.myPhones, isEmpty);
      expect(profile.familyAsTransfers, isFalse);
      expect(profile.effectivePhones(), isEmpty);
      expect(profile.effectiveNames(), isEmpty);
    });
  });
}