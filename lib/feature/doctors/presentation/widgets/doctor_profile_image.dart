import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/constants/styles.dart';

import 'package:flutter/material.dart';

class CustomDoctorProfileImage extends StatelessWidget {
  final double height;
  final String imagePath;

  const CustomDoctorProfileImage({
    super.key,
    required this.height,
    this.imagePath = ImageLinks.man1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppStyles.padding / 3),
      child: Container(
        padding: EdgeInsets.all(AppStyles.padding),
        height: height,
        width: height, // Square for circular
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(AppStyles.borderRadius),
          ),
          shape: BoxShape.rectangle,

          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
