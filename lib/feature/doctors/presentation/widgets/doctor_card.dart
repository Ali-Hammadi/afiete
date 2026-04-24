import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:afiete/feature/doctors/domain/entites/doctor_entity.dart';
import 'package:afiete/feature/doctors/presentation/widgets/doctor_profile_image.dart';
import 'package:flutter/material.dart';

class CustomDoctorCard extends StatelessWidget {
  final DoctorEntity doctor;
  final bool dense;

  const CustomDoctorCard({super.key, required this.doctor, this.dense = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final cardBackground = colorScheme.primaryContainer.withValues(alpha: 0.45);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: dense ? AppStyles.padding / 2 : AppStyles.padding,
        vertical: dense ? 6 : AppStyles.padding / 2,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: cardBackground,
          borderRadius: BorderRadius.all(
            Radius.circular(AppStyles.borderRadius),
          ),
        ),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                CustomDoctorProfileImage(height: 100),
                Expanded(
                  child: ListTile(
                    title: Text(doctor.name),
                    subtitle: Text(
                      SettingsStrings.specialtyLabel(doctor.specialization),
                    ),
                    trailing: SizedBox(
                      width: 56,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star_outline, color: colorScheme.primary),
                          Text(
                            doctor.ratingValue.toString(),
                            style: AppStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        SettingsStrings.experienceLabel,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        SettingsStrings.experienceYearsLabel(doctor.experience),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                VerticalDivider(thickness: 1, color: colorScheme.outline),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        SettingsStrings.consultationLabel,
                        textAlign: TextAlign.center,
                      ),
                      Text(doctor.rating, textAlign: TextAlign.center),
                    ],
                  ),
                ),
                VerticalDivider(),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        SettingsStrings.onlineLabel,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        doctor.isOnline
                            ? SettingsStrings.availableLabel
                            : SettingsStrings.offlineLabel,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            CustomButton(
              widget: Text(
                SettingsStrings.viewDetails,
                style: AppStyles.bodyMedium.copyWith(
                  color: colorScheme.onPrimary,
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  MyRoutes.doctorInfoScreen,
                  arguments: doctor,
                );
              },
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
