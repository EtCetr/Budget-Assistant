import 'package:freezed_annotation/freezed_annotation.dart';
import 'dashboard_widget_type.dart';

part 'dashboard_widget_item.freezed.dart';

@freezed
abstract class DashboardWidgetItem with _$DashboardWidgetItem {
  const factory DashboardWidgetItem({
    required String id,
    required DashboardWidgetType type,
    required bool isVisible,
    required int sortOrder,
  }) = _DashboardWidgetItem;
}