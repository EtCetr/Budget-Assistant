// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yearly_aggregates_dao.dart';

// ignore_for_file: type=lint
mixin _$YearlyAggregatesDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $SpacesTable get spaces => attachedDatabase.spaces;
  $YearlyAggregatesTable get yearlyAggregates =>
      attachedDatabase.yearlyAggregates;
  YearlyAggregatesDaoManager get managers => YearlyAggregatesDaoManager(this);
}

class YearlyAggregatesDaoManager {
  final _$YearlyAggregatesDaoMixin _db;
  YearlyAggregatesDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$SpacesTableTableManager get spaces =>
      $$SpacesTableTableManager(_db.attachedDatabase, _db.spaces);
  $$YearlyAggregatesTableTableManager get yearlyAggregates =>
      $$YearlyAggregatesTableTableManager(
        _db.attachedDatabase,
        _db.yearlyAggregates,
      );
}
