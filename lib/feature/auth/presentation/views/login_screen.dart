import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:afiete/feature/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:afiete/core/di/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool obsecureText = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (_) => sl<AuthCubit>(),
      child: Scaffold(
        backgroundColor: AppColors.primarybackgroundColor,
        resizeToAvoidBottomInset: false,
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLoaded) {
              Navigator.pushNamed(context, MyRoutes.homeScreen);
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
                      Image.asset(ImageLinks.appIcon),
                      const SizedBox(height: 10),
                      Text(
                        'Enter your account',
                        style: AppStyles.headingLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),

                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            CustomTextFormFiled(
                              label: "Email",
                              controller: emailController,
                              obscureText: false,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Email is required';
                                }
                                if (!RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                ).hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            CustomTextFormFiled(
                              label: 'Password',
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
                                  return 'Password is required';
                                }
                                if (value.length < 6) {
                                  return 'Password must be at least 6 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        widget: state is AuthLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                "Login",
                                style: AppStyles.bodyMedium.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                                if (formKey.currentState!.validate()) {
                                  final email = emailController.text.trim();
                                  final password = passwordController.text;
                                  context.read<AuthCubit>().login(
                                    email,
                                    password,
                                  );
                                }
                              },
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        widget: Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              SvgImageLinks.googleIcon,
                              height: 18,
                              width: 18,
                            ),

                            const SizedBox(width: 10),
                            Text(
                              'Continue with Google',
                              style: AppStyles.bodyMedium.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        onPressed: () =>
                            context.read<AuthCubit>().googleSignIn(),
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Do not have an account ?",
                            style: AppStyles.bodyMedium,
                          ),
                          TextButton(
                            child: Text(
                              'Signup',
                              style: AppStyles.headingSmall.copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushNamed(context, MyRoutes.signup);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
