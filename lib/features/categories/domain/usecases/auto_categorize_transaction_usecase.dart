// lib/features/categories/domain/usecases/auto_categorize_transaction_usecase.dart
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/utils/result.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../entities/category_rule.dart';
import '../repositories/category_repository.dart';

class AutoCategorizeTransactionUseCase {
  final CategoryRepository _repository;
  final Logger _logger;
  final Uuid _uuid;

  AutoCategorizeTransactionUseCase({
    required CategoryRepository repository,
    required Logger logger,
    required Uuid uuid,
  }) : _repository = repository,
       _logger = logger,
       _uuid = uuid;

  /// Auto-categorize transaction based on merchant name and bank
  /// Returns target category ID if rule matches, null otherwise
  /// trigger_string is [OPEN] field for SQL LIKE - NOT encrypted E2E
  Future<Result<String?>> execute({
    required String merchantName,
    required String bankName,
    required String? spaceId,
  }) async {
    try {
      if (merchantName.trim().isEmpty) {
        return Result.success(null);
      }

      // Get rules for this bank and space
      final rules = await _repository.getRulesByBankAndSpace(bankName, spaceId);

      if (rules.isEmpty) {
        _logger.d('No auto-categorization rules found for bank: $bankName');
        return Result.success(null);
      }

      // Find first matching rule
      for (final rule in rules) {
        if (rule.matches(merchantName: merchantName, bankName: bankName)) {
          _logger.i(
            'Auto-categorized "$merchantName" → category ${rule.targetCategoryId} '
            '(rule: ${rule.triggerString})',
          );
          return Result.success(rule.targetCategoryId);
        }
      }

      _logger.d('No matching rule found for "$merchantName" at $bankName');
      return Result.success(null);
    } catch (e, stackTrace) {
      _logger.e(
        'AutoCategorizeTransactionUseCase failed',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(Failure.database(e.toString(), stackTrace));
    }
  }

  /// Create new auto-categorization rule
  Future<Result<CategoryRule>> createRule({
    required String userId,
    required String bankName,
    required String triggerString,
    required String targetCategoryId,
    String? spaceId,
  }) async {
    try {
      // Validation
      if (triggerString.trim().isEmpty) {
        return Result.failure(
          const Failure.validation('Trigger string cannot be empty'),
        );
      }

      if (targetCategoryId.trim().isEmpty) {
        return Result.failure(
          const Failure.validation('Target category ID cannot be empty'),
        );
      }

      final now = DateTime.now().toUtc();

      final rule = CategoryRule(
        id: _uuid.v4(),
        userId: userId,
        spaceId: spaceId,
        bankName: bankName,
        triggerString: triggerString.trim(),
        targetCategoryId: targetCategoryId,
        createdAt: now,
        updatedAt: now,
        syncStatus: 'pending',
      );

      await _repository.insertRule(rule);
      _logger.i(
        'Category rule created: "${rule.triggerString}" → ${rule.targetCategoryId}',
      );

      return Result.success(rule);
    } catch (e, stackTrace) {
      _logger.e('Create rule failed', error: e, stackTrace: stackTrace);
      return Result.failure(Failure.database(e.toString(), stackTrace));
    }
  }
}
