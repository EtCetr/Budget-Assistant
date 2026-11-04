// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_cards_dao.dart';

// ignore_for_file: type=lint
mixin _$LoyaltyCardsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $SpacesTable get spaces => attachedDatabase.spaces;
  $LoyaltyCardsTable get loyaltyCards => attachedDatabase.loyaltyCards;
  $LoyaltyCardDraftsTable get loyaltyCardDrafts =>
      attachedDatabase.loyaltyCardDrafts;
  LoyaltyCardsDaoManager get managers => LoyaltyCardsDaoManager(this);
}

class LoyaltyCardsDaoManager {
  final _$LoyaltyCardsDaoMixin _db;
  LoyaltyCardsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$SpacesTableTableManager get spaces =>
      $$SpacesTableTableManager(_db.attachedDatabase, _db.spaces);
  $$LoyaltyCardsTableTableManager get loyaltyCards =>
      $$LoyaltyCardsTableTableManager(_db.attachedDatabase, _db.loyaltyCards);
  $$LoyaltyCardDraftsTableTableManager get loyaltyCardDrafts =>
      $$LoyaltyCardDraftsTableTableManager(
        _db.attachedDatabase,
        _db.loyaltyCardDrafts,
      );
}
