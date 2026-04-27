// ignore_for_file: deprecated_member_use

import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:afiete/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:afiete/feature/auth/presentation/widgets/auth_verification_pin_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VerifyAccountScreen extends StatefulWidget {
  final String email;

  const VerifyAccountScreen({super.key, this.email = ''});

  @override
  State<VerifyAccountScreen> createState() => _VerifyAccountScreenState();
}

class _VerifyAccountScreenState extends State<VerifyAccountScreen> {
  late final TextEditingController _pinPutController = TextEditingController();

  bool get isFormValid => _pinPutController.text.length == 4;

  void _verifyOTP(String pin) {
    context.read<AuthCubit>().verifyOtpCode(widget.email, pin);
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
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoaded) {
            // OTP verification successful, navigate to home
            Navigator.pushNamed(context, MyRoutes.homeScreen);
          } else if (state is AuthError) {
            // Show error message
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SafeArea(
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
                    Text(
                      SettingsStrings.verifyAccountTitle,
                      style: AppStyles.headingLarge,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Please enter the code sent to ${widget.email}',
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
                      widget: state is AuthLoading
                          ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colorScheme.onPrimary,
                                ),
                              ),
                            )
                          : Text(
                              SettingsStrings.verify,
                              style: TextStyle(
                                color: colorScheme.onPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                      onPressed: state is AuthLoading
                          ? null
                          : isFormValid
                          ? () => _verifyOTP(_pinPutController.text)
                          : null,
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () {
                        _pinPutController.clear();
                        context.read<AuthCubit>().sendVerificationOtp(
                          widget.email,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(SettingsStrings.codeResentToEmail),
                          ),
                        );
                      },
                      child: Text(
                        SettingsStrings.didntReceiveCodeResend,
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
          );
        },
      ),
    );
  }
}
