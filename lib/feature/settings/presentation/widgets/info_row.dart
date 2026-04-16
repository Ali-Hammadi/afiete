import 'package:afiete/core/constants/styles.dart';
import 'package:flutter/material.dart';

class CustomInfoRow extends StatelessWidget {
  final IconData icon;
  final String leftText;
  final String rightActionText;
  final VoidCallback? onActionPressed;

  const CustomInfoRow({
    super.key,
    required this.icon,
    required this.leftText,
    required this.rightActionText,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Icon(icon, size: 28, color: colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(leftText, style: AppStyles.bodyMedium)),
        TextButton(
          onPressed: onActionPressed,
          child: Text(
            rightActionText,
            style: AppStyles.bodySmall.copyWith(color: colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
