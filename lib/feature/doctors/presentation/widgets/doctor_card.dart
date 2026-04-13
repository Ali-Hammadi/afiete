import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:afiete/feature/doctors/domain/entites/doctor_entity.dart';
import 'package:afiete/feature/doctors/presentation/widgets/doctor_profile_image.dart';
import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final DoctorEntity doctor;

  const DoctorCard({super.key, required this.doctor});

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
                    title: Text(doctor.name),
                    subtitle: Text(doctor.specialization),
                    trailing: SizedBox(
                      width: 56,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Colors.amber),
                          Text(
                            doctor.ratingValue.toString(),
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
                      Text(doctor.experience, textAlign: TextAlign.center),
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
                      Text("Online", textAlign: TextAlign.center),
                      Text(
                        doctor.isOnline ? "Available" : "Offline",
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
                "View details",
                style: AppStyles.bodyMedium.copyWith(color: Colors.white),
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
