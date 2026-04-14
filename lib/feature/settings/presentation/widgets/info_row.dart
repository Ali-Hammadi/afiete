import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:flutter/material.dart';

class InfoRow extends StatelessWidget {
  final IconData icon;
  final String leftText;
  final String rightActionText;

  const InfoRow({
    super.key,
    required this.icon,
    required this.leftText,
    required this.rightActionText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 28, color: AppColors.unselectedIconColor),
        const SizedBox(width: 12),
        Expanded(child: Text(leftText, style: AppStyles.bodyMedium)),
        TextButton(
          onPressed: () {},
          child: Text(
            rightActionText,
            style: AppStyles.bodySmall.copyWith(color: AppColors.primaryColor),
          ),
        ),
      ],
    );
  }
}
