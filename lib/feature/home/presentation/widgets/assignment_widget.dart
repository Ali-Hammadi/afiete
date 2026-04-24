import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:flutter/material.dart';

class CustomAssignmentWidget extends StatelessWidget {
  const CustomAssignmentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppStyles.padding),
      height: 200,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.all(Radius.circular(AppStyles.borderRadius)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            SettingsStrings.takeAssignmentTitle,
            style: AppStyles.bodyMedium.copyWith(color: colorScheme.onPrimary),
            textAlign: TextAlign.start,
          ),
          Text(
            SettingsStrings.takeAssignmentDescription,
            style: AppStyles.bodyMedium.copyWith(color: colorScheme.onPrimary),
            overflow: TextOverflow.visible,
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, MyRoutes.assignmentTestScreen);
            },
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: colorScheme.onPrimary,
                borderRadius: BorderRadius.all(
                  Radius.circular(AppStyles.borderRadius),
                ),
              ),
              child: Text(
                SettingsStrings.takeAssignmentButton,
                style: AppStyles.bodyMedium.copyWith(
                  color: colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
