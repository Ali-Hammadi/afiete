import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:afiete/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _step = 'request_otp';
  bool _isLoading = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
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
          SettingsStrings.forgotPasswordTitle,
          style: AppStyles.headingMedium,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppStyles.padding),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Text(
              SettingsStrings.forgotPasswordDesc,
              textAlign: TextAlign.center,
              style: AppStyles.bodyMedium.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              enabled: _step == 'request_otp',
              decoration: InputDecoration(
                labelText: SettingsStrings.emailAddressLabel,
                hintText: SettingsStrings.forgotEmailHint,
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            if (_step == 'verify_otp') ...[
              const SizedBox(height: 16),
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                decoration: InputDecoration(
                  labelText: 'OTP Code',
                  hintText: '1234',
                  prefixIcon: const Icon(Icons.verified_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _newPasswordController,
                obscureText: !_showNewPassword,
                decoration: InputDecoration(
                  labelText: SettingsStrings.newPasswordLabel,
                  hintText: SettingsStrings.newPasswordHint,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _showNewPassword = !_showNewPassword;
                      });
                    },
                    icon: Icon(
                      _showNewPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _confirmPasswordController,
                obscureText: !_showConfirmPassword,
                decoration: InputDecoration(
                  labelText: SettingsStrings.confirmPasswordLabel,
                  hintText: SettingsStrings.confirmPasswordHint,
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _showConfirmPassword = !_showConfirmPassword;
                      });
                    },
                    icon: Icon(
                      _showConfirmPassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            CustomButton(
              onPressed: _isLoading
                  ? null
                  : _step == 'request_otp'
                  ? _handleSendResetOtp
                  : _handleResetPassword,
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
                      _step == 'request_otp'
                          ? SettingsStrings.sendCode
                          : SettingsStrings.resetPassword,
                      style: AppStyles.headingSmall.copyWith(
                        color: colorScheme.onPrimary,
                      ),
                    ),
            ),
            if (_step == 'verify_otp') ...[
              const SizedBox(height: 8),
              TextButton(
                onPressed: _isLoading ? null : _handleSendResetOtp,
                child: Text(SettingsStrings.resendCode),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              SettingsStrings.resetInstructionsHint,
              textAlign: TextAlign.center,
              style: AppStyles.bodySmall.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSendResetOtp() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(SettingsStrings.invalidEmailError)),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final error = await context.read<AuthCubit>().requestForgotPasswordOtp(
        email: email,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          if (error == null) {
            _step = 'verify_otp';
          }
        });

        if (error == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(SettingsStrings.verificationCodeSent)),
          );
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(error)));
        }
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

  Future<void> _handleResetPassword() async {
    if (_otpController.text.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(SettingsStrings.invalidFourDigitCode)),
      );
      return;
    }

    if (_newPasswordController.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(SettingsStrings.passwordAtLeastSixChars)),
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(SettingsStrings.passwordMismatch)),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final success = await context.read<AuthCubit>().resetPassword(
        email: _emailController.text.trim(),
        otp: _otpController.text,
        newPassword: _newPasswordController.text,
      );

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(SettingsStrings.passwordChanged)),
        );
        Navigator.pop(context);
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
}
