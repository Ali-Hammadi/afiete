import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:afiete/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReactivateAccountScreen extends StatefulWidget {
  final String email;
  final String password;
  final String message;

  const ReactivateAccountScreen({
    super.key,
    required this.email,
    required this.password,
    required this.message,
  });

  @override
  State<ReactivateAccountScreen> createState() => _ReactivateAccountScreenState();
}

class _ReactivateAccountScreenState extends State<ReactivateAccountScreen> {
  bool _isSubmitting = false;
  bool _didStartRequest = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_didStartRequest) {
        _startReactivateFlow();
      }
    });
  }

  Future<void> _startReactivateFlow() async {
    if (_didStartRequest) return;
    _didStartRequest = true;

    setState(() {
      _isSubmitting = true;
    });

    final success = await context.read<AuthCubit>().reactivateAccount(
          widget.email,
          widget.password,
        );

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    if (!success) {
      _didStartRequest = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is OtpSent) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('A verification code was sent to ${state.email}')),
          );
          Navigator.pushReplacementNamed(
            context,
            MyRoutes.verifyAccountScreen,
            arguments: state.email,
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = _isSubmitting || state is AuthLoading;

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            elevation: 0,
            title: Text(
              'Reactivate account',
              style: AppStyles.headingMedium,
            ),
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppStyles.padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    widget.message.isNotEmpty
                        ? widget.message
                        : 'This account is inactive. Reactivate it to receive a new verification code.',
                    style: AppStyles.bodyLarge.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.8),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Email',
                          style: AppStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        Text(widget.email, style: AppStyles.bodyMedium),
                        const SizedBox(height: 16),
                        Text(
                          'Tap reactivate to request a new OTP for this account.',
                          style: AppStyles.bodyMedium.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  CustomButton(
                    widget: isLoading
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
                            'Reactivate account',
                            style: AppStyles.bodyMedium.copyWith(
                              color: colorScheme.onPrimary,
                            ),
                          ),
                    onPressed: isLoading ? null : _startReactivateFlow,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}