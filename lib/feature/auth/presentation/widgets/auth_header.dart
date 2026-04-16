import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:flutter/material.dart';

class CustomAuthHeader extends StatelessWidget {
  final String title;

  const CustomAuthHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(ImageLinks.appIcon),
        const SizedBox(height: 10),
        Text(title, style: AppStyles.headingLarge, textAlign: TextAlign.center),
      ],
    );
  }
}
