import 'package:flutter/material.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../dashboard_strings.dart';

class DashboardEmptyState extends StatelessWidget {
  const DashboardEmptyState({super.key, required this.onConfigure});

  final VoidCallback onConfigure;

  @override
  Widget build(BuildContext context) {
    return EmptyStateWidget(
      animationAsset: 'assets/animations/clean_sheet.json',
      title: DashboardStrings.emptyTitle,
      subtitle: DashboardStrings.emptySubtitle,
      primaryAction: EmptyStateAction(
        label: DashboardStrings.configure,
        onPressed: onConfigure,
        isPrimary: true,
      ),
    );
  }
}