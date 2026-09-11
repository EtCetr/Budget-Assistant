import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomPinKeypad extends StatelessWidget {
  final void Function(String digit) onDigitPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback? onBiometricPressed;
  final bool showBiometricButton;
  final bool isEnabled;

  const CustomPinKeypad({
    super.key,
    required this.onDigitPressed,
    required this.onBackspacePressed,
    this.onBiometricPressed,
    this.showBiometricButton = false,
    this.isEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: isEnabled ? 1.0 : 0.5,
      child: Column(
        children: [
          _buildRow(['1', '2', '3']),
          _buildRow(['4', '5', '6']),
          _buildRow(['7', '8', '9']),
          _buildBottomRow(),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: digits.map((digit) => _buildKey(digit)).toList(),
    );
  }

  Widget _buildBottomRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (showBiometricButton) _buildBiometricKey() else _buildEmptyKey(),
        _buildKey('0'),
        _buildBackspaceKey(),
      ],
    );
  }

  Widget _buildKey(String digit) {
    return GestureDetector(
      onTap: isEnabled
          ? () {
              HapticFeedback.selectionClick();
              onDigitPressed(digit);
            }
          : null,
      child: Container(
        width: 72,
        height: 72,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade200,
        ),
        child: Center(
          child: Text(
            digit,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildBackspaceKey() {
    return GestureDetector(
      onTap: isEnabled
          ? () {
              HapticFeedback.lightImpact();
              onBackspacePressed();
            }
          : null,
      child: Container(
        width: 72,
        height: 72,
        margin: const EdgeInsets.all(8),
        child: const Icon(Icons.backspace_outlined, size: 32),
      ),
    );
  }

  Widget _buildBiometricKey() {
    return GestureDetector(
      onTap: isEnabled
          ? () {
              HapticFeedback.lightImpact();
              onBiometricPressed?.call();
            }
          : null,
      child: Container(
        width: 72,
        height: 72,
        margin: const EdgeInsets.all(8),
        child: const Icon(Icons.fingerprint, size: 32),
      ),
    );
  }

  Widget _buildEmptyKey() {
    return const SizedBox(width: 72, height: 72, child: SizedBox.shrink());
  }
}
