import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final String userName = 'Ali'; // Placeholder for authenticated user

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 5.0),
      child: ListTile(
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.person, size: 40),
        ),
        contentPadding: EdgeInsets.zero,
        title: Text(
          'Welcome $userName',
          style: AppStyles.headingMedium.copyWith(
            color: AppColors.primaryColor,
          ),
        ),
        subtitle: Text(
          'Start your journey',
          style: AppStyles.bodyMedium.copyWith(
            color: AppColors.primarytextColor,
          ),
        ),
      ),
    );
  }
}
