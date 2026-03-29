import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:flutter/material.dart';

class AssignmentWidget extends StatelessWidget {
  const AssignmentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppStyles.padding),
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.secondaryColor,
        borderRadius: BorderRadius.all(Radius.circular(AppStyles.borderRadius)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Not sure where to start ?\n ",
            style: AppStyles.bodyMedium.copyWith(color: AppColors.whiteColor),
            textAlign: TextAlign.left,
          ),
          Text(
            "Take a short mental health assignment so we can understand your state and suggest the best doctors for you",
            style: AppStyles.bodyMedium.copyWith(color: AppColors.whiteColor),
            overflow: TextOverflow.visible,
          ),
          TextButton(
            onPressed: () {},
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(AppStyles.borderRadius),
                ),
              ),
              child: Text(
                " Take the assignment ",
                style: AppStyles.bodyMedium.copyWith(
                  color: AppColors.secondaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
