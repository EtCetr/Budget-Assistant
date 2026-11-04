// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_analytics_cache_dao.dart';

// ignore_for_file: type=lint
mixin _$ProductAnalyticsCacheDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $ProductAnalyticsCacheTable get productAnalyticsCache =>
      attachedDatabase.productAnalyticsCache;
  ProductAnalyticsCacheDaoManager get managers =>
      ProductAnalyticsCacheDaoManager(this);
}

class ProductAnalyticsCacheDaoManager {
  final _$ProductAnalyticsCacheDaoMixin _db;
  ProductAnalyticsCacheDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$ProductAnalyticsCacheTableTableManager get productAnalyticsCache =>
      $$ProductAnalyticsCacheTableTableManager(
        _db.attachedDatabase,
        _db.productAnalyticsCache,
      );
}
