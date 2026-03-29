import 'package:afiete/core/constants/app_colors.dart';
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
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppStyles.bodyMedium,
        errorStyle: AppStyles.bodySmall.copyWith(color: AppColors.errorColor),
        suffixIcon: suffixIcon,
        prefixIcon: Icon(prefixIcon, color: AppColors.primaryColor),
        fillColor: AppColors.primaryFillColor,
        filled: true,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppStyles.padding,
          vertical: 12,
        ),

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.selectedFieldColor),
          borderRadius: BorderRadius.all(
            Radius.circular(AppStyles.borderRadius),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
          borderRadius: BorderRadius.all(
            Radius.circular(AppStyles.borderRadius),
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.errorColor),
          borderRadius: BorderRadius.all(
            Radius.circular(AppStyles.borderRadius),
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.unselectedFieldColor),
          borderRadius: BorderRadius.all(
            Radius.circular(AppStyles.borderRadius),
          ),
        ),
      ),
    );
  }
}
