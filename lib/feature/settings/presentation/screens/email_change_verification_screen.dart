import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:afiete/feature/auth/presentation/widgets/auth_verification_pin_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmailChangeVerificationScreen extends StatefulWidget {
  final String newEmail;

  const EmailChangeVerificationScreen({super.key, required this.newEmail});

  @override
  State<EmailChangeVerificationScreen> createState() =>
      _EmailChangeVerificationScreenState();
}

class _EmailChangeVerificationScreenState
    extends State<EmailChangeVerificationScreen> {
  final TextEditingController _pinController = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _sendOtp());
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    final message = await context.read<AuthCubit>().requestEmailChangeOtp(
      newEmail: widget.newEmail,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message ?? 'OTP sent.')));
  }

  Future<void> _confirmEmailChange() async {
    if (_pinController.text.length != 4) return;
    setState(() {
      _loading = true;
    });

    final success = await context.read<AuthCubit>().confirmEmailChange(
      newEmail: widget.newEmail,
      otp: _pinController.text,
    );

    if (!mounted) return;

    setState(() {
      _loading = false;
    });

    if (success) {
      Navigator.pop(context, true);
    }
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
        title: const Text(
          SettingsStrings.verifyNewEmailTitle,
          style: AppStyles.headingMedium,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppStyles.padding),
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  'We sent a 4-digit code to:\n${widget.newEmail}',
                  textAlign: TextAlign.center,
                  style: AppStyles.bodyLarge.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.75),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                CustomAuthVerificationPinInput(
                  controller: _pinController,
                  onCompleted: (_) => _confirmEmailChange(),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  widget: _loading
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
                  onPressed: _loading ? null : _confirmEmailChange,
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _sendOtp,
                  child: Text(
                    SettingsStrings.resendCode,
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
