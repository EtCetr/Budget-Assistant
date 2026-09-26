import 'dart:convert';
import 'package:logger/logger.dart';
import '../../domain/entities/split_position_draft.dart';
import '../../domain/repositories/split_drafts_repository.dart';
import '../datasources/split_drafts_dao.dart';

class SplitDraftsRepositoryImpl implements SplitDraftsRepository {
  SplitDraftsRepositoryImpl({
    required SplitDraftsDao dao,
    required Logger logger,
  })  : _dao = dao,
        _logger = logger;

  final SplitDraftsDao _dao;
  final Logger _logger;

  @override
  Future<List<SplitPositionDraft>?> getFreshPositions(
    String transactionId,
  ) async {
    try {
      final since = DateTime.now().toUtc().subtract(const Duration(hours: 24));
      final row = await _dao.getFresh('split_draft_$transactionId', since);
      if (row == null) return null;
      final list = jsonDecode(row.positionsJson) as List<dynamic>;
      return list
          .map((e) =>
              SplitPositionDraft.fromJson(e as Map<String, dynamic>))
          .toList();
    } on FormatException catch (e) {
      _logger.w('Corrupt split draft ignored: $e');
      return null;
    } catch (e, st) {
      _logger.e('split draft get failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> savePositions(
    String transactionId,
    List<SplitPositionDraft> positions,
  ) async {
    try {
      final now = DateTime.now().toUtc();
      await _dao.upsert(
        id: 'split_draft_$transactionId',
        transactionId: transactionId,
        positionsJson: jsonEncode(positions.map((p) => p.toJson()).toList()),
        updatedAt: now,
      );
      await _dao.cleanupOld(now.subtract(const Duration(days: 7)));
    } catch (e, st) {
      _logger.e('split draft save failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> deleteByTransaction(String transactionId) async {
    try {
      await _dao.deleteById('split_draft_$transactionId');
    } catch (e, st) {
      _logger.e('split draft delete failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}