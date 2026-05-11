import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/core/utils/logger.dart';
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
  final _log = loggerFor('AuthInfoScreen');
  DateTime? selectedDate;
  String? selectedGender;
  bool _isSubmitting = false;
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void dispose() {
    birthdateController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    _log.info('birthdate_picker:open');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked == null) {
      _log.warn('birthdate_picker:cancelled');
      return;
    }

    if (picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        birthdateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
      _log.info(
        'birthdate_picker:selected',
        data: {'birthDate': birthdateController.text},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final authState = context.watch<AuthCubit>().state;
    final currentNickname = authState is AuthLoaded
        ? authState.user.nickname
        : authState is AuthProfileUpdated
        ? authState.user.nickname
      : authState is SignupOtpVerified
      ? authState.user.nickname
        : '';

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: null,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppStyles.padding),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        SettingsStrings.letsGetToKnowYou,
                        textAlign: TextAlign.center,
                        style: AppStyles.headingLarge,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        SettingsStrings.personalizeExperienceHint,
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
                            label: SettingsStrings.birthdateLabel,
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
                          labelText: SettingsStrings.genderTitle,
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
                        items: [
                          DropdownMenuItem(
                            value: SettingsStrings.male,
                            child: Text(SettingsStrings.male),
                          ),
                          DropdownMenuItem(
                            value: SettingsStrings.female,
                            child: Text(SettingsStrings.female),
                          ),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedGender = newValue;
                          });
                          _log.info(
                            'gender:selected',
                            data: {'gender': selectedGender},
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      CustomTextFormFiled(
                        label: SettingsStrings.phoneNumberTitle,
                        controller: phoneController,
                        obscureText: false,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone,
                        validator: (value) {
                          if (value != null && value.isNotEmpty) {
                            if (value.length < 9) {
                              return SettingsStrings.invalidPhoneNumber;
                            }
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              CustomButton(
                widget: Text(
                  _isSubmitting ? 'Saving...' : SettingsStrings.next,
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: _isSubmitting
                    ? null
                    : () async {
                        final phone = phoneController.text.trim();
                        final missingFields = <String>[];
                        if (selectedDate == null) {
                          missingFields.add('birthDate');
                        }
                        if (selectedGender == null ||
                            selectedGender!.trim().isEmpty) {
                          missingFields.add('gender');
                        }
                        if (phone.isEmpty) missingFields.add('phoneNumber');

                        _log.info(
                          'submit_profile_info:tap',
                          data: {
                            'hasBirthDate': selectedDate != null,
                            'gender': selectedGender,
                            'phoneLength': phone.length,
                            'missingFields': missingFields,
                          },
                        );

                        if (missingFields.isNotEmpty) {
                          _log.warn(
                            'submit_profile_info:validation_missing_fields',
                            data: {'missingFields': missingFields},
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(SettingsStrings.fillAllFieldsError),
                            ),
                          );
                          return;
                        }

                        final digitsOnly = phone.replaceAll(
                          RegExp(r'[^0-9]'),
                          '',
                        );
                        if (digitsOnly.length < 9 || digitsOnly.length > 15) {
                          _log.warn(
                            'submit_profile_info:validation_phone_invalid',
                            data: {
                              'phoneLength': phone.length,
                              'digitLength': digitsOnly.length,
                            },
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(SettingsStrings.invalidPhoneNumber),
                            ),
                          );
                          return;
                        }

                        setState(() {
                          _isSubmitting = true;
                        });

                        try {
                            final cid = context
                                .read<AuthCubit>()
                                .activeAuthFlowCorrelationId;

                          final saved = await context
                              .read<AuthCubit>()
                              .updateProfileInfo(
                                nickname: currentNickname,
                                birthDate: selectedDate!,
                                gender: selectedGender!,
                                phoneNumber: phone,
                              );

                          if (!context.mounted) return;

                          if (!saved) {
                            final currentState = context
                                .read<AuthCubit>()
                                .state;
                            final message = currentState is AuthError
                                ? currentState.message
                                : 'Could not complete your profile information. Please try again.';

                            _log.error(
                              'submit_profile_info:failed',
                              data: {
                                'cid': cid,
                                'stateType': currentState.runtimeType
                                    .toString(),
                                'message': message,
                              },
                            );

                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(message)));
                            return;
                          }

                          _log.info(
                            'submit_profile_info:success',
                            data: {'cid': cid},
                          );
                          Navigator.pushReplacementNamed(
                            context,
                            MyRoutes.homeScreen,
                          );
                        } catch (e, st) {
                          _log.error(
                            'submit_profile_info:exception',
                            data: {'error': e.toString()},
                            error: e,
                            stackTrace: st,
                          );

                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Unexpected error while saving your profile info. Please try again.',
                              ),
                            ),
                          );
                        } finally {
                          if (context.mounted) {
                            setState(() {
                              _isSubmitting = false;
                            });
                          }
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
