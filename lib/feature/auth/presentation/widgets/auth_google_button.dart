import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAuthGoogleButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomAuthGoogleButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return CustomButton(
      widget: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(SvgImageLinks.googleIcon, height: 18, width: 18),
          const SizedBox(width: 10),
          Text(
            'Continue with Google',
            style: AppStyles.bodyMedium.copyWith(color: colorScheme.onPrimary),
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
