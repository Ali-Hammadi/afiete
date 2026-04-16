// ignore_for_file: deprecated_member_use

import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:afiete/feature/auth/presentation/widgets/auth_verification_pin_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
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
                  color: colorScheme.primary,
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 30),
                Text("Verify your account", style: AppStyles.headingLarge),
                const SizedBox(height: 10),
                Text(
                  "We have sent 4-digit code to your Email\nEnter the code below to verify your account.",
                  style: AppStyles.bodyLarge.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.75),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                CustomAuthVerificationPinInput(
                  controller: _pinPutController,
                  onCompleted: _verifyOTP,
                ),
                const SizedBox(height: 30),
                CustomButton(
                  widget: Text(
                    "Verify",
                    style: TextStyle(
                      color: colorScheme.onPrimary,
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
                      color: colorScheme.primary,
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
