import 'package:afiete/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

import 'package:afiete/core/constants/styles.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.widget,
    required this.onPressed,
  });
  final Widget widget;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          minimumSize: const Size(0, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyles.borderRadius),
          ),
        ),
        onPressed: onPressed,
        child: widget,
      ),
    );
  }
}
