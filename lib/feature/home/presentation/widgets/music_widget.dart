import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:flutter/material.dart';

class CustomMusicWidget extends StatelessWidget {
  const CustomMusicWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: AppStyles.padding),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: colorScheme.primary),
          color: theme.cardColor,
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
                  color: colorScheme.primary,
                ),
              ),
              subtitle: Text(
                "Take a deep breath and enjoy the music",
                style: AppStyles.bodyMedium,
              ),
              trailing: SizedBox(
                width: 56,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.play_arrow),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
