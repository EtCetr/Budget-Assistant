// lib/features/categories/domain/usecases/create_category_usecase.dart
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/utils/result.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import '../entities/category.dart';
import '../repositories/category_repository.dart';

class CreateCategoryUseCase {
  final CategoryRepository _repository;
  final Logger _logger;
  final Uuid _uuid;

  CreateCategoryUseCase({
    required CategoryRepository repository,
    required Logger logger,
    required Uuid uuid,
  }) : _repository = repository,
       _logger = logger,
       _uuid = uuid;

  Future<Result<Category>> execute({
    required String userId,
    required String name,
    required String type, // 'expense', 'income', 'transfer'
    String? spaceId,
    String? parentId,
    String? iconEmoji,
    String? colorHex,
    bool isPinnedForCashback = false,
  }) async {
    try {
      // Validation
      if (name.trim().isEmpty) {
        return Result.failure(
          const Failure.validation('Category name cannot be empty'),
        );
      }

      if (!['expense', 'income', 'transfer'].contains(type)) {
        return Result.failure(
          Failure.validation('Invalid category type: $type'),
        );
      }

      final now = DateTime.now().toUtc();

      final category = Category(
        id: _uuid.v4(),
        userId: userId,
        spaceId: spaceId,
        parentId: parentId,
        name: name.trim(),
        type: type,
        iconEmoji: iconEmoji,
        colorHex: colorHex,
        isPinnedForCashback: isPinnedForCashback,
        isSystem: false,
        createdAt: now,
        updatedAt: now,
        syncStatus: 'pending',
      );

      await _repository.insertCategory(category);
      _logger.i('Category created: ${category.id} (${category.name})');

      return Result.success(category);
    } catch (e, stackTrace) {
      _logger.e(
        'CreateCategoryUseCase failed',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(Failure.database(e.toString(), stackTrace));
    }
  }
}
