import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:afiete/feature/home/presentation/widgets/doctor_profile_image.dart';
import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppStyles.padding,
        vertical: AppStyles.padding / 2,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryFillColor,
          borderRadius: BorderRadius.all(
            Radius.circular(AppStyles.borderRadius),
          ),
        ),
        width: double.infinity,
        child: Column(
          children: [
            Row(
              children: [
                DoctorProfileImage(height: 100),
                Expanded(
                  child: ListTile(
                    title: Text("Dr. John Doe"),
                    subtitle: Text("Psychiatrist"),
                    trailing: SizedBox(
                      width: 56,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.amber),
                          Text(
                            "4.5",
                            style: AppStyles.bodySmall.copyWith(
                              color: AppColors.primarytextColor,
                            ),
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
                      Text("Experience", textAlign: TextAlign.center),
                      Text("+ 5 years", textAlign: TextAlign.center),
                    ],
                  ),
                ),
                VerticalDivider(
                  thickness: 1,
                  color: AppColors.unselectedFieldColor,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Consultation", textAlign: TextAlign.center),
                      Text("40\$/hour", textAlign: TextAlign.center),
                    ],
                  ),
                ),
                VerticalDivider(),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Reviews", textAlign: TextAlign.center),
                      Text("97 review", textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ],
            ),
            Divider(),
            CustomButton(
              widget: Text(
                "View details",
                style: AppStyles.bodyMedium.copyWith(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pushNamed(context, MyRoutes.doctorInfoScreen);
              },
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
