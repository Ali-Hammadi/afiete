// ignore_for_file: deprecated_member_use

import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:afiete/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:afiete/feature/auth/presentation/widgets/auth_verification_pin_input.dart';
import 'package:afiete/feature/auth/presentation/widgets/countdown_timer.dart';
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
  bool _showCountdown = true;
  bool _isResending = false;
  int _countdownSeconds = 60;

  bool get isFormValid => _pinPutController.text.length == 4;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    _syncCountdownSecondsFromState(authState);
    _showCountdown = authState is OtpSent;
  }

  void _syncCountdownSecondsFromState(AuthState state) {
    if (state is OtpSent && state.expiresInSeconds > 0) {
      _countdownSeconds = state.expiresInSeconds;
    }
  }

  void _verifyOTP(String otp) {
    context.read<AuthCubit>().verifyOtp(widget.email, otp.trim());
  }

  Future<void> _handleResendOtp() async {
    setState(() {
      _isResending = true;
    });
    try {
      _pinPutController.clear();
      final success = await context.read<AuthCubit>().sendVerificationOtp(widget.email);
      if (mounted) {
        final currentState = context.read<AuthCubit>().state;
        _syncCountdownSecondsFromState(currentState);
        setState(() {
          _showCountdown = success;
          _isResending = false;
        });
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(SettingsStrings.codeResentToEmail)),
          );
        }
        // If not success, cubit's listener will show the error message.
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to resend code: $e')));
      }
    }
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
          _syncCountdownSecondsFromState(state);

          if (state is SignupOtpVerified) {
            // PHASE 2 → PHASE 3: OTP verified in signup flow, navigate to profile completion
            Navigator.pushReplacementNamed(
              context,
              MyRoutes.authInfoScreens,
              arguments: state.user,
            );
          } else if (state is AuthReset) {
            // Account deleted or session reset: clear UI and restart app flow
            final msg = (state.message != null && state.message!.isNotEmpty)
                ? state.message!
                : 'Your account or session was removed. The app will restart.';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(msg)),
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              MyRoutes.splashScreen,
              (route) => false,
            );
          } else if (state is AuthLoaded) {
            // OTP verified in login/password reset flow
            if (!(state.user.accessToken?.isNotEmpty == true)) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Authentication session is not available. Please sign in again.',
                  ),
                ),
              );
              Navigator.pushReplacementNamed(context, MyRoutes.login);
              return;
            }

            // OTP verification successful - check if it was signup or login flow
            final user = state.user;
            final isProfileIncomplete =
                user.birthDate == null ||
                user.age == null ||
                user.gender == null ||
                user.gender?.isEmpty == true ||
                user.phoneNumber == null ||
                user.phoneNumber?.isEmpty == true;

            if (isProfileIncomplete) {
              // Signup flow: complete profile information
              Navigator.pushReplacementNamed(context, MyRoutes.authInfoScreens);
            } else {
              // Login flow or signup with existing profile: proceed to home
              Navigator.pushReplacementNamed(context, MyRoutes.homeScreen);
            }
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
                    const SizedBox(height: 30),
                    // Countdown timer with resend button
                    if (_showCountdown)
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Resend code in ',
                                style: AppStyles.bodyMedium,
                              ),
                              CountdownTimer(
                                key: ValueKey(_countdownSeconds),
                                initialSeconds: _countdownSeconds,
                                onCountdownComplete: () {
                                  setState(() {
                                    _showCountdown = false;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    // Resend button
                    TextButton(
                      onPressed: !_showCountdown && !_isResending
                          ? _handleResendOtp
                          : null,
                      child: _isResending
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  colorScheme.primary,
                                ),
                              ),
                            )
                          : Text(
                              _showCountdown
                                  ? SettingsStrings.didntReceiveCodeResend
                                  : 'Resend Code',
                              style: AppStyles.bodyMedium.copyWith(
                                color: !_showCountdown && !_isResending
                                    ? colorScheme.primary
                                    : colorScheme.outlineVariant,
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
