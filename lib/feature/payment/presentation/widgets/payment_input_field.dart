import 'package:afiete/core/constants/styles.dart';
import 'package:flutter/material.dart';

class CustomPaymentInputField extends StatelessWidget {
  final String? label;
  final String hint;
  final IconData? prefixIcon;

  const CustomPaymentInputField({
    super.key,
    this.label,
    required this.hint,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: AppStyles.headingSmall),
          const SizedBox(height: 8),
        ],
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    color: colorScheme.onSurface.withValues(alpha: 0.75),
                  )
                : null,
            filled: true,
            fillColor: theme.cardColor,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            hintStyle: AppStyles.bodyMedium.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.75),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: colorScheme.outline.withValues(alpha: 0.35),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary),
            ),
          ),
        ),
      ],
    );
  }
}
