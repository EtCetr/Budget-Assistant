// lib/features/categories/domain/usecases/delete_category_usecase.dart
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/utils/result.dart';
import '../repositories/category_repository.dart';

class DeleteCategoryUseCase {
  final CategoryRepository _repository;
  final Logger _logger;

  DeleteCategoryUseCase({
    required CategoryRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  /// Удаляет категорию; дочерние категории «подшиваются» к её родителю (сплайс).
  Future<Result<void>> execute(String categoryId) async {
    try {
      await _repository.deleteCategory(categoryId);
      _logger.i('Category deleted: $categoryId');
      return Result.success(null);
    } catch (e, stackTrace) {
      _logger.e('DeleteCategoryUseCase failed', error: e, stackTrace: stackTrace);
      return Result.failure(Failure.database(e.toString(), stackTrace));
    }
  }
}