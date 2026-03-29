// ignore_for_file: deprecated_member_use

import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';

class VerifyAccountScreen extends StatefulWidget {
  const VerifyAccountScreen({super.key});

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  late final TextEditingController _pinPutController = TextEditingController();

  bool get isFormValid => _pinPutController.text.length == 4;

  void _verifyOTP(String pin) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('OTP Verified: $pin')));
  }

  @override
  void dispose() {
    _pinPutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(AppStyles.padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  SvgImageLinks.verifyAccount,
                  color: AppColors.primaryColor,
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 30),
                Text("Verify your account", style: AppStyles.headingLarge),
                const SizedBox(height: 10),
                Text(
                  "We have sent 4-digit code to your Email\nEnter the code below to verify your account.",
                  style: AppStyles.bodyLarge.copyWith(
                    color: AppColors.secondarytextColor,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Pinput(
                  length: 4,
                  controller: _pinPutController,
                  onCompleted: _verifyOTP,
                  defaultPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: AppColors.primarytextColor,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.unselectedFieldColor),
                      borderRadius: BorderRadius.circular(
                        AppStyles.borderRadius,
                      ),
                      color: AppColors.primaryFillColor,
                    ),
                  ),
                  focusedPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: AppColors.primarytextColor,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.selectedFieldColor),
                      borderRadius: BorderRadius.circular(
                        AppStyles.borderRadius,
                      ),
                      color: AppColors.primaryFillColor,
                    ),
                  ),
                  submittedPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: AppColors.primarytextColor,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        AppStyles.borderRadius,
                      ),
                      color: Colors.green,
                      border: Border.all(color: Colors.green),
                    ),
                  ),
                  errorPinTheme: PinTheme(
                    width: 56,
                    height: 56,
                    textStyle: TextStyle(
                      fontSize: 20,
                      color: AppColors.primarytextColor,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.errorColor),
                      borderRadius: BorderRadius.circular(
                        AppStyles.borderRadius,
                      ),
                      color: AppColors.primaryFillColor,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                CustomButton(
                  widget: const Text(
                    "Verify",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed:
                      // isFormValid
                      //     ? () => _verifyOTP(_pinPutController.text)
                      //     : null,
                      () {
                        Navigator.pushNamed(context, MyRoutes.homeScreen);
                      },
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    _pinPutController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Code resent to your email'),
                      ),
                    );
                  },
                  child: Text(
                    "Didn't receive the code? Resend",
                    style: AppStyles.bodyMedium.copyWith(
                      color: AppColors.primaryColor,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
