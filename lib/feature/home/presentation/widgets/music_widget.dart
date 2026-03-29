import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:flutter/material.dart';

class MusicWidget extends StatelessWidget {
  const MusicWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: AppStyles.padding),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor),
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.all(
            Radius.circular(AppStyles.borderRadius),
          ),
        ),
        child: Column(
          children: [
            Image.asset(ImageLinks.beatch),
            ListTile(
              title: Text(
                "Relaxing Music",
                style: AppStyles.bodyMedium.copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
              subtitle: Text(
                "Take a deep breath and enjoy the music",
                style: AppStyles.bodyMedium.copyWith(
                  color: AppColors.primarytextColor,
                ),
              ),
              trailing: IconButton(
                onPressed: () {},
                icon: Icon(Icons.play_arrow),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
