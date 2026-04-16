import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomEmotionsWidget extends StatelessWidget {
  const CustomEmotionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppStyles.padding,
        vertical: AppStyles.padding,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.45),
              borderRadius: BorderRadius.all(
                Radius.circular(AppStyles.borderRadius),
              ),
            ),
            width: 56,
            height: 56,
            child: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(SvgImageLinks.smile),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.45),
              borderRadius: BorderRadius.all(
                Radius.circular(AppStyles.borderRadius),
              ),
            ),
            width: 56,
            height: 56,
            child: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(SvgImageLinks.happy),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.45),
              borderRadius: BorderRadius.all(
                Radius.circular(AppStyles.borderRadius),
              ),
            ),
            width: 56,
            height: 56,
            child: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(SvgImageLinks.sad),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.45),
              borderRadius: BorderRadius.all(
                Radius.circular(AppStyles.borderRadius),
              ),
            ),
            width: 56,
            height: 56,
            child: IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(SvgImageLinks.angry),
            ),
          ),
        ],
      ),
    );
  }
}
