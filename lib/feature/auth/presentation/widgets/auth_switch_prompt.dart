import 'package:afiete/core/constants/styles.dart';
import 'package:flutter/material.dart';

class CustomAuthSwitchPrompt extends StatelessWidget {
  final String promptText;
  final String actionText;
  final VoidCallback onPressed;

  const CustomAuthSwitchPrompt({
    super.key,
    required this.promptText,
    required this.actionText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(promptText, style: AppStyles.bodyMedium),
        TextButton(
          onPressed: onPressed,
          child: Text(
            actionText,
            style: AppStyles.headingSmall.copyWith(color: colorScheme.primary),
          ),
        ),
      ],
    );
  }
}
