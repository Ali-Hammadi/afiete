import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/feature/home/presentation/widgets/doctor_profile_image.dart';
import 'package:flutter/material.dart';

class TopDoctorsWidget extends StatelessWidget {
  const TopDoctorsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppStyles.padding),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            TopDoctorCard(),
            TopDoctorCard(),
            TopDoctorCard(),
            TopDoctorCard(),
            TopDoctorCard(),
            TopDoctorCard(),
            TopDoctorCard(),
            TopDoctorCard(),
          ],
        ),
      ),
    );
  }
}

class TopDoctorCard extends StatelessWidget {
  const TopDoctorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppStyles.padding / 2),
      child: Container(
        padding: EdgeInsets.all(AppStyles.padding / 2),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryColor),
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(AppStyles.borderRadius),
          ),
        ),
        child: Column(
          children: [
            DoctorProfileImage(height: 90),
            Text("Dr. John Doe"),
            Text("Psychiatrist"),
          ],
        ),
      ),
    );
  }
}
