// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parser_configs_dao.dart';

// ignore_for_file: type=lint
mixin _$ParserConfigsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ParserConfigsTable get parserConfigs => attachedDatabase.parserConfigs;
  ParserConfigsDaoManager get managers => ParserConfigsDaoManager(this);
}

class ParserConfigsDaoManager {
  final _$ParserConfigsDaoMixin _db;
  ParserConfigsDaoManager(this._db);
  $$ParserConfigsTableTableManager get parserConfigs =>
      $$ParserConfigsTableTableManager(_db.attachedDatabase, _db.parserConfigs);
}
