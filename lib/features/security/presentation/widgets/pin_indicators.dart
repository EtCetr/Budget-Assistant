import 'package:flutter/material.dart';

class PinIndicators extends StatelessWidget {
  final int length;
  final int filledCount;
  final bool isError;

  const PinIndicators({
    super.key,
    required this.length,
    required this.filledCount,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        length,
        (index) => Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < filledCount
                ? (isError ? Colors.red : Colors.blue)
                : Colors.transparent,
            border: Border.all(
              color: isError ? Colors.red : Colors.grey,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
