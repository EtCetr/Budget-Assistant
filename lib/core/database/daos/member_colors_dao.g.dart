// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_colors_dao.dart';

// ignore_for_file: type=lint
mixin _$MemberColorsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $MemberColorsTable get memberColors => attachedDatabase.memberColors;
  MemberColorsDaoManager get managers => MemberColorsDaoManager(this);
}

class MemberColorsDaoManager {
  final _$MemberColorsDaoMixin _db;
  MemberColorsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$MemberColorsTableTableManager get memberColors =>
      $$MemberColorsTableTableManager(_db.attachedDatabase, _db.memberColors);
}
