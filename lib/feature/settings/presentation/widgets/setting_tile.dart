import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingTile({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppStyles.borderRadius - 4),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppStyles.borderRadius - 4),
          border: Border.all(
            color: AppColors.unselectedFieldColor.withValues(alpha: 0.4),
          ),
          color: AppColors.whiteColor,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.unselectedIconColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppStyles.bodyMedium),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!, style: AppStyles.bodySmall),
                  ],
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.unselectedIconColor,
                ),
          ],
        ),
      ),
    );
  }
}
