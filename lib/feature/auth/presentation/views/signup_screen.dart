import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:afiete/feature/auth/presentation/widgets/auth_google_button.dart';
import 'package:afiete/feature/auth/presentation/widgets/auth_header.dart';
import 'package:afiete/feature/auth/presentation/widgets/auth_switch_prompt.dart';
import 'package:afiete/feature/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/auth_cubit.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obsecureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: true,
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoaded) {
            if (state.user.isVerified) {
              Navigator.pushNamed(context, MyRoutes.authInfoScreens);
            } else {
              Navigator.pushNamed(
                context,
                MyRoutes.verifyAccountScreen,
                arguments: state.user.email,
              );
            }
          } else if (state is WaitingForOtpVerification) {
            // Auto-navigate to OTP verification screen when account not verified
            Navigator.pushNamed(
              context,
              MyRoutes.verifyAccountScreen,
              arguments: state.email,
            );
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppStyles.padding),
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                scrollDirection: Axis.vertical,
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomAuthHeader(title: SettingsStrings.createYourAccount),
                    const SizedBox(height: 20),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          CustomTextFormFiled(
                            label: SettingsStrings.nicknameLabel,
                            controller: nameController,
                            obscureText: false,
                            keyboardType: TextInputType.text,
                            prefixIcon: Icons.text_fields,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return SettingsStrings.nameRequired;
                              }
                              if (value.trim().length < 2) {
                                return SettingsStrings.nameMinTwoChars;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormFiled(
                            label: "Email",
                            controller: emailController,
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return SettingsStrings.emailRequired;
                              }
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(value)) {
                                return SettingsStrings.invalidEmailError;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 10),
                          CustomTextFormFiled(
                            label: SettingsStrings.passwordTitle,
                            controller: passwordController,
                            obscureText: obsecureText,
                            keyboardType: TextInputType.visiblePassword,
                            prefixIcon: Icons.lock,
                            suffixIcon: IconButton(
                              icon: Icon(
                                obsecureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  obsecureText = !obsecureText;
                                });
                              },
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return SettingsStrings.passwordRequired;
                              }
                              if (value.length < 6) {
                                return SettingsStrings.passwordMinSixChars;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
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
                              "Signup",
                              style: AppStyles.bodyMedium.copyWith(
                                color: colorScheme.onPrimary,
                              ),
                            ),
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              if (formKey.currentState!.validate()) {
                                final name = nameController.text.trim();
                                final email = emailController.text.trim();
                                final password = passwordController.text;
                                context.read<AuthCubit>().signup(
                                  name,
                                  email,
                                  password,
                                );
                              }
                            },
                    ),
                    const SizedBox(height: 20),
                    CustomAuthGoogleButton(
                      onPressed: () {
                        context.read<AuthCubit>().googleSignIn();
                      },
                    ),
                    const SizedBox(height: 30),
                    CustomAuthSwitchPrompt(
                      promptText: 'Already have an account?',
                      actionText: 'Login',
                      onPressed: () {
                        Navigator.pushNamed(context, MyRoutes.login);
                      },
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

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
