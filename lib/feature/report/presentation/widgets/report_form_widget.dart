import 'package:flutter/material.dart';
import 'package:afiete/core/constants/styles.dart';

class CustomReportFormWidget extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final int maxLines;
  final int? maxLength;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  const CustomReportFormWidget({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.maxLines = 6,
    this.maxLength = 500,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          maxLength: maxLength,
          onChanged: onChanged,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppStyles.bodyMedium.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.75),
            ),
            filled: true,
            fillColor: theme.cardColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.borderRadius),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.borderRadius),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.borderRadius),
              borderSide: BorderSide(color: colorScheme.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppStyles.borderRadius),
              borderSide: BorderSide(color: colorScheme.error, width: 2),
            ),
            errorText: errorText,
            counterStyle: AppStyles.bodySmall.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.75),
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
          style: AppStyles.bodyMedium.copyWith(color: colorScheme.onSurface),
        ),
      ],
    );
  }
}
