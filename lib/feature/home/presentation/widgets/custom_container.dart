import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  const CustomContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppStyles.padding / 2),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryFillColor,
          borderRadius: BorderRadius.all(
            Radius.circular(AppStyles.borderRadius),
          ),
        ),
        padding: const EdgeInsets.all(AppStyles.padding),
        child: child,
      ),
    );
  }
}
