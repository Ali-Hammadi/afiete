import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:afiete/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:afiete/feature/auth/presentation/widgets/auth_verification_pin_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailChangeScreen extends StatefulWidget {
  const EmailChangeScreen({super.key});

  @override
  State<EmailChangeScreen> createState() => _EmailChangeScreenState();
}

class _EmailChangeScreenState extends State<EmailChangeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _newEmailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  String _currentStep = 'email_input'; // email_input -> otp_verification
  bool _isLoading = false;
  String? _currentUserEmail;

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthLoaded) {
      _currentUserEmail = authState.user.email;
    } else if (authState is AuthProfileUpdated) {
      _currentUserEmail = authState.user.email;
    }
  }

  @override
  void dispose() {
    _newEmailController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          SettingsStrings.changeEmailTitle,
          style: AppStyles.headingMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppStyles.padding),
        child: Column(
          children: [
            if (_currentStep == 'email_input') ...[
              const SizedBox(height: 24),
              Text(
                SettingsStrings.enterNewEmailAddress,
                style: AppStyles.headingSmall,
              ),
              const SizedBox(height: 8),
              Text(
                SettingsStrings.currentEmailLabel(_currentUserEmail ?? ''),
                style: AppStyles.bodyMedium.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _newEmailController,
                  decoration: InputDecoration(
                    labelText: SettingsStrings.emailAddressLabel,
                    hintText: SettingsStrings.newEmailHint,
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return SettingsStrings.emailRequired;
                    }
                    if (!value.contains('@')) {
                      return SettingsStrings.invalidEmailError;
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                onPressed: _isLoading ? null : _handleRequestOtp,
                widget: _isLoading
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
                        SettingsStrings.continueText,
                        style: AppStyles.headingSmall.copyWith(
                          color: colorScheme.onPrimary,
                        ),
                      ),
              ),
            ] else if (_currentStep == 'otp_verification') ...[
              const SizedBox(height: 24),
              Text(
                SettingsStrings.verifyYourNewEmail,
                style: AppStyles.headingSmall,
              ),
              const SizedBox(height: 16),
              Text(
                SettingsStrings.verificationCodeSentTo(
                  _newEmailController.text,
                ),
                textAlign: TextAlign.center,
                style: AppStyles.bodyMedium.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              CustomAuthVerificationPinInput(
                controller: _otpController,
                onCompleted: (_) => _handleVerifyOtp(),
              ),
              const SizedBox(height: 24),
              CustomButton(
                onPressed: _isLoading ? null : _handleVerifyOtp,
                widget: _isLoading
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
                        style: AppStyles.headingSmall.copyWith(
                          color: colorScheme.onPrimary,
                        ),
                      ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _isLoading ? null : _handleResendOtp,
                child: Text(
                  SettingsStrings.resendCode,
                  style: AppStyles.bodyMedium.copyWith(
                    color: colorScheme.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _handleRequestOtp() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final message = await context.read<AuthCubit>().requestEmailChangeOtp(
        newEmail: _newEmailController.text.trim(),
      );

      if (!mounted) return;

      if (message == null) {
        setState(() {
          _isLoading = false;
          _currentStep = 'otp_verification';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(SettingsStrings.otpSentToNewEmail)),
        );
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(SettingsStrings.errorWith(message))),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(SettingsStrings.errorWith(e.toString()))),
      );
    }
  }

  Future<void> _handleVerifyOtp() async {
    if (_otpController.text.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(SettingsStrings.invalidFourDigitCode)),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await context.read<AuthCubit>().confirmEmailChange(
        newEmail: _newEmailController.text.trim(),
        otp: _otpController.text,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(SettingsStrings.emailUpdatedSuccess)),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(SettingsStrings.incorrectOtpTryAgain)),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(SettingsStrings.errorWith(e.toString()))),
      );
    }
  }

  Future<void> _handleResendOtp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final message = await context.read<AuthCubit>().requestEmailChangeOtp(
        newEmail: _newEmailController.text.trim(),
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message ?? SettingsStrings.otpResentToEmail)),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(SettingsStrings.errorWith(e.toString()))),
      );
    }
  }
}
