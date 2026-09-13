enum DashboardWidgetType {
  balanceSummary,
  expenseFlowChart,
  activeCashbackCategories,
  limitCards,
}

extension DashboardWidgetTypeX on DashboardWidgetType {
  String get title {
    switch (this) {
      case DashboardWidgetType.balanceSummary:
        return 'Общий баланс';
      case DashboardWidgetType.expenseFlowChart:
        return 'Движение расходов';
      case DashboardWidgetType.activeCashbackCategories:
        return 'Активный кэшбэк';
      case DashboardWidgetType.limitCards:
        return 'Лимиты';
    }
  }
}