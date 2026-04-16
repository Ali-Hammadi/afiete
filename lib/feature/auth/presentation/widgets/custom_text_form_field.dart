import 'package:afiete/core/constants/styles.dart';
import 'package:flutter/material.dart';

class CustomTextFormFiled extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final IconData prefixIcon;
  final IconButton? suffixIcon;
  const CustomTextFormFiled({
    super.key,
    required this.label,
    required this.controller,
    required this.obscureText,
    required this.keyboardType,
    this.validator,
    required this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppStyles.bodyMedium,
        errorStyle: AppStyles.bodySmall.copyWith(color: colorScheme.error),
        suffixIcon: suffixIcon,
        prefixIcon: Icon(prefixIcon, color: colorScheme.primary),
        fillColor: colorScheme.primaryContainer.withValues(alpha: 0.45),
        filled: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppStyles.padding,
          vertical: 12,
        ),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.outline),
          borderRadius: BorderRadius.all(
            Radius.circular(AppStyles.borderRadius),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
          borderRadius: BorderRadius.all(
            Radius.circular(AppStyles.borderRadius),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.error),
          borderRadius: BorderRadius.all(
            Radius.circular(AppStyles.borderRadius),
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: colorScheme.outline),
          borderRadius: BorderRadius.all(
            Radius.circular(AppStyles.borderRadius),
          ),
        ),
      ),
    );
  }
}
