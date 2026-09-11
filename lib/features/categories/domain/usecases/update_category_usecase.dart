// lib/features/categories/domain/usecases/update_category_usecase.dart
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/utils/result.dart';
import '../repositories/category_repository.dart';

class UpdateCategoryUseCase {
  final CategoryRepository _repository;
  final Logger _logger;

  UpdateCategoryUseCase({
    required CategoryRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  Future<Result<void>> execute({
    required String categoryId,
    required String name,
    required String type,
    String? parentId,
    String? iconEmoji,
    String? colorHex,
  }) async {
    try {
      if (name.trim().isEmpty) {
        return Result.failure(
          const Failure.validation('Category name cannot be empty'),
        );
      }
      if (!['expense', 'income', 'transfer'].contains(type)) {
        return Result.failure(Failure.validation('Invalid category type: $type'));
      }
      if (parentId == categoryId) {
        return Result.failure(
          const Failure.validation('Category cannot be its own parent'),
        );
      }

      return await _repository.updateCategory(
        categoryId: categoryId,
        name: name.trim(),
        type: type,
        parentId: parentId,
        iconEmoji: iconEmoji,
        colorHex: colorHex,
      );
    } catch (e, stackTrace) {
      _logger.e('UpdateCategoryUseCase failed', error: e, stackTrace: stackTrace);
      return Result.failure(Failure.database(e.toString(), stackTrace));
    }
  }
}