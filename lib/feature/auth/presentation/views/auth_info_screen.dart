import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/feature/auth/presentation/widgets/custom_text_form_field.dart';
import 'package:afiete/core/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return Scaffold(
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
                      color: AppColors.secondarytextColor,
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
                        color: AppColors.primaryColor,
                      ),
                      suffixIcon: Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.primaryColor,
                      ),
                      fillColor: AppColors.primaryFillColor,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.selectedFieldColor,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppStyles.borderRadius,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: AppColors.unselectedFieldColor,
                        ),
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
                widget: const Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
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
