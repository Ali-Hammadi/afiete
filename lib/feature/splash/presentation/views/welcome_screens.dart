import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class WelcomeScreens extends StatefulWidget {
  const WelcomeScreens({super.key});

  @override
  State<WelcomeScreens> createState() => _WelcomeScreensState();
}

class _WelcomeScreensState extends State<WelcomeScreens> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primarybackgroundColor,
      appBar: null,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [
                  _buildFirstPage(),
                  _buildSecondScreen(),
                  _buildThirdScreen(),
                ],
              ),
            ),
            SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: WormEffect(
                activeDotColor: AppColors.primaryColor,
                dotColor: Colors.grey,
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildThirdScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 70),
        ClipRRect(
          borderRadius: BorderRadiusGeometry.only(
            topLeft: Radius.circular(AppStyles.borderRadius * 5),
            topRight: Radius.circular(AppStyles.borderRadius * 5),
          ),
          child: SizedBox(
            width: 320,
            height: 320,
            child: Image.asset(ImageLinks.protectingMental),
          ),
        ),

        const SizedBox(height: 20),
        Text(
          "You are't alone in this journey.",
          style: AppStyles.headingLarge,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),
        Text(
          "Let's take this journey together",
          style: AppStyles.bodyLarge,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 90),
        CustomButton(
          widget: Text(
            "Get Started",
            style: AppStyles.bodyMedium.copyWith(color: Colors.white),
          ),
          onPressed: () {
            Navigator.pushNamed(context, MyRoutes.signup);
          },
        ),

        Spacer(flex: 1),
      ],
    );
  }

  Widget _buildSecondScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 70),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppStyles.borderRadius * 5),
              topRight: Radius.circular(AppStyles.borderRadius * 5),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.unselectedFieldColor,
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppStyles.borderRadius * 5),
              topRight: Radius.circular(AppStyles.borderRadius * 5),
            ),
            child: Image.asset(ImageLinks.professionalDoctor),
          ),
        ),
        const SizedBox(height: 30),
        Text(
          "A select group of experts at your fingertips",
          style: AppStyles.headingLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          "Choose the right therapist for you, with a wide range of specialties.",
          style: AppStyles.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFirstPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 70),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppStyles.borderRadius * 5),
              topRight: Radius.circular(AppStyles.borderRadius * 5),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.unselectedFieldColor,
                blurRadius: 20,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppStyles.borderRadius * 5),
              topRight: Radius.circular(AppStyles.borderRadius * 5),
            ),
            child: Image.asset(ImageLinks.peacefulMind),
          ),
        ),
        const SizedBox(height: 30),
        const Text(
          "Your mental health matters",
          style: AppStyles.headingLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Text(
          "Take a moment to breathe and relax,\n reflect and care for your being well.",
          style: AppStyles.bodyLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
