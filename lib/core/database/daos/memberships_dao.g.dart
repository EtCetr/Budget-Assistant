// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memberships_dao.dart';

// ignore_for_file: type=lint
mixin _$MembershipsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $SpacesTable get spaces => attachedDatabase.spaces;
  $MembershipsTable get memberships => attachedDatabase.memberships;
  MembershipsDaoManager get managers => MembershipsDaoManager(this);
}

class MembershipsDaoManager {
  final _$MembershipsDaoMixin _db;
  MembershipsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$SpacesTableTableManager get spaces =>
      $$SpacesTableTableManager(_db.attachedDatabase, _db.spaces);
  $$MembershipsTableTableManager get memberships =>
      $$MembershipsTableTableManager(_db.attachedDatabase, _db.memberships);
}
