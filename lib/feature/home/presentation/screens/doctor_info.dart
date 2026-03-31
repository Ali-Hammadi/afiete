import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DoctorInfo extends StatelessWidget {
  const DoctorInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dr. John Doe",
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
                "Dr. John Doe",
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
                              "4.9",
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
                        Text("+ 5 years"),
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
                      "Dr. John Doe is a highly skilled and compassionate physician with over 5 years of experience in the medical field. He has a proven track record of providing exceptional care to his patients, earning him a stellar reputation in the community. Dr. Doe is known for his dedication to staying up-to-date with the latest medical advancements and his commitment to delivering personalized treatment plans that cater to the unique needs of each patient.",
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
                        "Anxiety",
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
                  Text("Reviews", style: AppStyles.headingSmall),
                  Divider(),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(ImageLinks.man1),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text("Fadi"),
                          subtitle: Text("Excellent doctor!"),
                          trailing: SizedBox(
                            width: 56,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: Colors.amber),
                                Text(
                                  "4.8",
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
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(ImageLinks.man1),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text("Samer"),
                          subtitle: Text("Excellent doctor!"),
                          trailing: SizedBox(
                            width: 56,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: Colors.amber),
                                Text(
                                  "4.9",
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
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage: AssetImage(ImageLinks.woman2),
                      ),
                      Expanded(
                        child: ListTile(
                          title: Text("Maya"),
                          subtitle: Text("Excellent doctor!"),
                          trailing: SizedBox(
                            width: 56,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.star, color: Colors.amber),
                                Text(
                                  "4.8",
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
                ],
              ),
            ),
            CustomButton(
              widget: Text(
                "Book a session now",
                style: AppStyles.headingSmall.copyWith(color: Colors.white),
              ),
              onPressed: () {},
            ),
            SizedBox(height: 30),
            CustomButton(widget: Text("data"), onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  const CustomContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppStyles.padding / 2),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryFillColor,
          borderRadius: BorderRadius.all(
            Radius.circular(AppStyles.borderRadius),
          ),
        ),
        padding: const EdgeInsets.all(AppStyles.padding),
        child: child,
      ),
    );
  }
}
