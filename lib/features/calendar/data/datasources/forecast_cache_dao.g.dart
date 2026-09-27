// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_cache_dao.dart';

// ignore_for_file: type=lint
mixin _$ForecastCacheDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $SpacesTable get spaces => attachedDatabase.spaces;
  $CategoriesTable get categories => attachedDatabase.categories;
  $ForecastCacheTable get forecastCache => attachedDatabase.forecastCache;
  ForecastCacheDaoManager get managers => ForecastCacheDaoManager(this);
}

class ForecastCacheDaoManager {
  final _$ForecastCacheDaoMixin _db;
  ForecastCacheDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$SpacesTableTableManager get spaces =>
      $$SpacesTableTableManager(_db.attachedDatabase, _db.spaces);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$ForecastCacheTableTableManager get forecastCache =>
      $$ForecastCacheTableTableManager(_db.attachedDatabase, _db.forecastCache);
}
