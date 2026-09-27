import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import '../../data/datasources/holidays_dao.dart';
import '../../data/repositories/holidays_repository_impl.dart';
import '../../domain/repositories/holidays_repository.dart';

final Logger _logger = Logger();

final holidaysDaoProvider = Provider<HolidaysDao>((ref) {
  return HolidaysDao(ref.watch(appDatabaseProvider));
});

final holidaysRepositoryProvider = Provider<HolidaysRepository>((ref) {
  return HolidaysRepositoryImpl(
    dao: ref.watch(holidaysDaoProvider),
    logger: _logger,
  );
});