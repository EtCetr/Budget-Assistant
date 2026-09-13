import 'package:logger/logger.dart';
import '../../data/repositories/dashboard_layout_repository_impl.dart';
import '../entities/dashboard_widget_item.dart';

class UpdateDashboardLayoutUseCase {
  UpdateDashboardLayoutUseCase({
    required DashboardLayoutRepositoryImpl repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final DashboardLayoutRepositoryImpl _repository;
  final Logger _logger;

  Future<void> call({
    required String userId,
    required List<DashboardWidgetItem> items,
  }) async {
    try {
      await _repository.saveLayout(userId, items);
    } catch (e, st) {
      _logger.e('UpdateDashboardLayoutUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}