import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import '../../data/datasources/loyalty_cards_dao.dart';
import '../../data/repositories/loyalty_cards_repository_impl.dart';
import '../../domain/repositories/loyalty_cards_repository.dart';

final Logger _logger = Logger();

/// DAO скидочных карт.
final loyaltyCardsDaoProvider = Provider<LoyaltyCardsDao>((ref) {
  return LoyaltyCardsDao(ref.watch(appDatabaseProvider));
});

/// Репозиторий скидочных карт.
final loyaltyCardsRepositoryProvider =
    Provider<LoyaltyCardsRepository>((ref) {
  return LoyaltyCardsRepositoryImpl(
    dao: ref.watch(loyaltyCardsDaoProvider),
    logger: _logger,
  );
});