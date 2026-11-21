import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/entities/loyalty_card.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/entities/loyalty_card_form_data.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/usecases/build_loyalty_card_draft_usecase.dart';

/// Этап 24: сборка доменной карты из DTO формы (ТЗ 6.3.20.13).
/// [LOCAL]-поля (sort_order, preferred_orientation) при редактировании
/// сохраняются; E2E применяется только к sync-пейлоаду (Этап 25).
LoyaltyCard _existing() => LoyaltyCard(
      id: 'card-1',
      userId: 'u1',
      spaceId: 's1',
      storeName: 'Лента',
      barcodeType: BarcodeType.ean13,
      barcodeData: '4006381333931',
      brandColor: '#FF0000',
      iconAsset: '🛒',
      category: LoyaltyCardCategory.grocery,
      isFavorite: true,
      sortOrder: 5,
      preferredOrientation: 'landscape',
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
    );

LoyaltyCardFormData _form({
  String storeName = 'Пятёрочка',
  BarcodeType type = BarcodeType.manual,
  String data = '12345678',
  String visibility = 'personal',
}) =>
    LoyaltyCardFormData(
      storeName: storeName,
      barcodeType: type,
      barcodeData: data,
      visibility: visibility,
      category: LoyaltyCardCategory.grocery,
    );

void main() {
  late BuildLoyaltyCardDraftUseCase useCase;

  setUp(() {
    useCase = BuildLoyaltyCardDraftUseCase(
      uuid: const Uuid(),
      logger: Logger(level: Level.off),
    );
  });

  test('новая карта: id, pending, UTC-даты, не избранная', () {
    final card = useCase(form: _form(), userId: 'u1');

    expect(card.id, isNotEmpty);
    expect(card.userId, 'u1');
    expect(card.syncStatus, SyncStatus.pending);
    expect(card.createdAt.isUtc, isTrue);
    expect(card.updatedAt.isUtc, isTrue);
    expect(card.isFavorite, isFalse);
    expect(card.sortOrder, isNull);
    expect(card.preferredOrientation, isNull);
  });

  test('ручной номер дублируется в cardNumber', () {
    final card = useCase(form: _form(), userId: 'u1');

    expect(card.cardNumber, '12345678');
    expect(card.barcodeData, '12345678');
  });

  test('штрих-код не заполняет cardNumber', () {
    final card = useCase(
      form: _form(type: BarcodeType.ean13, data: '4006381333931'),
      userId: 'u1',
    );

    expect(card.cardNumber, isNull);
    expect(card.barcodeData, '4006381333931');
  });

  test('семейная видимость ставит пространство и isShared', () {
    final card = useCase(
      form: _form(visibility: 'family'),
      userId: 'u1',
      currentSpaceId: 's1',
    );

    expect(card.spaceId, 's1');
    expect(card.isShared, isTrue);
  });

  test('личная видимость обнуляет пространство', () {
    final card = useCase(
      form: _form(),
      userId: 'u1',
      currentSpaceId: 's1',
    );

    expect(card.spaceId, isNull);
    expect(card.isShared, isTrue);
  });

  test('личная видимость сохраняет isShared существующей карты', () {
    final card = useCase(
      form: _form(),
      userId: 'u1',
      existing: _existing().copyWith(isShared: false),
    );

    expect(card.isShared, isFalse);
  });

  test('редактирование сохраняет id, createdAt и LOCAL-поля', () {
    final old = _existing();

    final card = useCase(
      form: _form(storeName: 'Лента новая'),
      userId: 'u1',
      existing: old,
    );

    expect(card.id, old.id);
    expect(card.createdAt, old.createdAt);
    expect(card.sortOrder, 5);
    expect(card.preferredOrientation, 'landscape');
    expect(card.isFavorite, isTrue);
    expect(card.storeName, 'Лента новая');
    expect(card.updatedAt.isAfter(old.updatedAt), isTrue);
  });

  test('название и данные кода обрезаются', () {
    final card = useCase(
      form: _form(storeName: '  Лента  ', data: '  12345678  '),
      userId: 'u1',
    );

    expect(card.storeName, 'Лента');
    expect(card.barcodeData, '12345678');
    expect(card.cardNumber, '12345678');
  });
}