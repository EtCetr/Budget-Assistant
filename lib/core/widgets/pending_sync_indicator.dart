import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class PendingSyncIndicator extends StatefulWidget {
  const PendingSyncIndicator({super.key});

  @override
  State<PendingSyncIndicator> createState() => _PendingSyncIndicatorState();
}

class _PendingSyncIndicatorState extends State<PendingSyncIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
      lowerBound: 0.35,
      upperBound: 1,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _controller,
      child: const Icon(
        Icons.cloud_off,
        size: 16,
        color: AppColors.colorPendingSync,
      ),
    );
  }
}
