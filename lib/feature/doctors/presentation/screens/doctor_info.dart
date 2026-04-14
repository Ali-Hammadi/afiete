import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:afiete/core/widget/error_custom_button.dart';
import 'package:afiete/feature/doctors/domain/entites/doctor_entity.dart';
import 'package:afiete/feature/home/presentation/widgets/custom_container.dart';
import 'package:afiete/feature/doctors/presentation/widgets/doctor_review_item.dart';
import 'package:flutter/material.dart';

class DoctorInfo extends StatefulWidget {
  final DoctorEntity? doctor;

  const DoctorInfo({super.key, this.doctor});

  @override
  State<DoctorInfo> createState() => _DoctorInfoState();
}

class _DoctorInfoState extends State<DoctorInfo> {
  bool _isFirstReviewExpanded = false;
  bool _isSecondReviewExpanded = false;
  bool _isThirdReviewExpanded = false;

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;
    final doctorName = doctor?.name ?? 'Dr. John Doe';
    final doctorSpecialization = doctor?.specialization ?? 'Specialist';
    final doctorDescription = doctor?.description.isNotEmpty == true
        ? doctor!.description
        : 'Doctor profile details are not available right now.';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          doctorName,
          style: AppStyles.headingMedium.copyWith(
            color: AppColors.primarytextColor,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.share, color: AppColors.primarytextColor),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppStyles.padding),
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage(ImageLinks.man1),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppStyles.padding),
              child: Text(
                doctorName,
                style: AppStyles.headingMedium.copyWith(
                  color: AppColors.primarytextColor,
                ),
              ),
            ),
            CustomContainer(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.star, color: Colors.amber),
                            Text(
                              (doctor?.ratingValue ?? 4.9).toStringAsFixed(1),
                              style: AppStyles.bodySmall.copyWith(
                                color: AppColors.primarytextColor,
                              ),
                            ),
                          ],
                        ),
                        Text(" Reviews", style: AppStyles.bodySmall),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(doctor?.experience ?? '+ 5 years'),
                        Text("Experience", style: AppStyles.bodySmall),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("+1.2K"),
                        Text("Patients", style: AppStyles.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("About Doctor", style: AppStyles.headingSmall),
                  Divider(),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      doctorDescription,
                      style: AppStyles.bodyMedium.copyWith(
                        color: AppColors.primarytextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Specialist", style: AppStyles.headingSmall),
                  Divider(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doctorSpecialization,
                        style: AppStyles.bodySmall.copyWith(
                          color: AppColors.primarytextColor,
                        ),
                      ),
                      Text("Cardiology"),
                      Text("CBT"),
                      Text("Depression"),
                    ],
                  ),
                ],
              ),
            ),
            CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Price Contact Doctor details",
                    style: AppStyles.headingSmall,
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Chat"),
                    subtitle: Text("10\$ / min"),
                    leading: Icon(
                      Icons.chat,
                      size: 28,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  ListTile(
                    title: Text("Video Call "),
                    subtitle: Text("20\$ / min"),
                    leading: Icon(
                      Icons.videocam_sharp,
                      size: 28,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  ListTile(
                    title: Text("Voice Call"),
                    subtitle: Text("15\$ / min"),
                    leading: Icon(
                      Icons.keyboard_voice_sharp,
                      size: 28,
                      color: AppColors.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            CustomContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Reviews", style: AppStyles.headingSmall),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          "See all",
                          style: AppStyles.bodySmall.copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Divider(),
                  DoctorReviewItem(
                    avatarAsset: ImageLinks.man1,
                    reviewerName: "Fadi",
                    reviewTime: "Yesterday",
                    rating: "4.8",
                    review:
                        "Dr. John Doe is an exceptional doctor who provided me with excellent care and support throughout my treatment. He was always attentive to my needs and concerns, and his expertise and professionalism were evident in every interaction. I highly recommend Dr. John Doe to anyone seeking top-notch medical care.",
                    isExpanded: _isFirstReviewExpanded,
                    onToggle: () {
                      setState(() {
                        _isFirstReviewExpanded = !_isFirstReviewExpanded;
                      });
                    },
                  ),
                  Divider(),
                  DoctorReviewItem(
                    avatarAsset: ImageLinks.man1,
                    reviewerName: "Samer",
                    reviewTime: "Last month",
                    rating: "4.9",
                    review:
                        "this is a very long review that should be truncated to fit in the available space. The doctor was very professional and attentive to my needs. I highly recommend him to anyone looking for a great healthcare provider.",
                    isExpanded: _isSecondReviewExpanded,
                    onToggle: () {
                      setState(() {
                        _isSecondReviewExpanded = !_isSecondReviewExpanded;
                      });
                    },
                  ),
                  Divider(),
                  DoctorReviewItem(
                    avatarAsset: ImageLinks.woman2,
                    reviewerName: "Maya",
                    reviewTime: "Last week",
                    rating: "4.8",
                    review:
                        "this is a very long review that should be truncated to fit in the available space. The doctor was very professional and attentive to my needs. I highly recommend him to anyone looking for a great healthcare provider.",
                    isExpanded: _isThirdReviewExpanded,
                    onToggle: () {
                      setState(() {
                        _isThirdReviewExpanded = !_isThirdReviewExpanded;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            CustomButton(
              widget: Text(
                "Book a session now",
                style: AppStyles.headingSmall.copyWith(color: Colors.white),
              ),
              onPressed: () {
                // if (doctor == null) {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       content: Text('Doctor data not loaded yet.'),
                //     ),
                //   );
                //   return;
                // }

                Navigator.pushNamed(
                  context,
                  MyRoutes.bookSessionScreen,
                  arguments: doctor,
                );
              },
            ),
            SizedBox(height: 20),
            ErrorCustomButton(
              widget: Text(
                "Report Doctor",
                style: AppStyles.bodyMedium.copyWith(color: Colors.white),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
