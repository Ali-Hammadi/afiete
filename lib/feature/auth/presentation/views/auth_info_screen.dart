import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/feature/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../cubits/auth_cubit.dart';

class AuthInfoScreen extends StatefulWidget {
  const AuthInfoScreen({super.key});

  @override
  State<AuthInfoScreen> createState() => _AuthInfoScreenState();
}

class _AuthInfoScreenState extends State<AuthInfoScreen> {
  DateTime? selectedDate;
  String? selectedGender;
  final TextEditingController birthdateController = TextEditingController();

  @override
  void dispose() {
    birthdateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        birthdateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: null,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppStyles.padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text(
                    "Let's get to know you",
                    textAlign: TextAlign.center,
                    style: AppStyles.headingLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "The following information will help us to personalize your experience",
                    textAlign: TextAlign.center,
                    style: AppStyles.bodyLarge.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.75),
                    ),
                  ),
                  const SizedBox(height: 32),
                  InkWell(
                    onTap: _selectDate,
                    child: AbsorbPointer(
                      child: CustomTextFormFiled(
                        label: 'Birthdate',
                        controller: birthdateController,
                        obscureText: false,
                        keyboardType: TextInputType.text,
                        prefixIcon: Icons.calendar_today,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    initialValue: selectedGender,
                    decoration: InputDecoration(
                      labelText: 'Gender',
                      labelStyle: AppStyles.bodyMedium,
                      prefixIcon: Icon(
                        Icons.person,
                        color: colorScheme.primary,
                      ),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: colorScheme.primary,
                      ),
                      fillColor: colorScheme.primaryContainer.withValues(
                        alpha: 0.45,
                      ),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: colorScheme.outline),
                        borderRadius: BorderRadius.circular(
                          AppStyles.borderRadius,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: colorScheme.outline),
                        borderRadius: BorderRadius.circular(
                          AppStyles.borderRadius,
                        ),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Male', child: Text('Male')),
                      DropdownMenuItem(value: 'Female', child: Text('Female')),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGender = newValue;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              CustomButton(
                widget: Text(
                  'Next',
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  if (selectedDate == null || selectedGender == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Please enter your birthdate and gender.',
                        ),
                      ),
                    );
                    return;
                  }

                  context.read<AuthCubit>().updateProfileInfo(
                    birthDate: selectedDate!,
                    gender: selectedGender!,
                  );
                  Navigator.pushReplacementNamed(
                    context,
                    MyRoutes.verifyAccountScreen,
                  );
                },
              ),
              SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
