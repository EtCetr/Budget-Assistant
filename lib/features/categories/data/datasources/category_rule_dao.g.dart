// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_rule_dao.dart';

// ignore_for_file: type=lint
mixin _$CategoryRuleDaoMixin on DatabaseAccessor<AppDatabase> {
  $SpacesTable get spaces => attachedDatabase.spaces;
  $UsersTable get users => attachedDatabase.users;
  $CategoriesTable get categories => attachedDatabase.categories;
  $CategoryRulesTable get categoryRules => attachedDatabase.categoryRules;
  CategoryRuleDaoManager get managers => CategoryRuleDaoManager(this);
}

class CategoryRuleDaoManager {
  final _$CategoryRuleDaoMixin _db;
  CategoryRuleDaoManager(this._db);
  $$SpacesTableTableManager get spaces =>
      $$SpacesTableTableManager(_db.attachedDatabase, _db.spaces);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$CategoryRulesTableTableManager get categoryRules =>
      $$CategoryRulesTableTableManager(_db.attachedDatabase, _db.categoryRules);
}
