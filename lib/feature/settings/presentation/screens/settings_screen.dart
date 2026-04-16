import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/core/theme/theme_cubit.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:afiete/feature/settings/domin/entity/setting_entity.dart';
import 'package:afiete/feature/settings/presentation/widgets/language_option.dart';
import 'package:afiete/feature/settings/presentation/widgets/setting_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String selectedLanguage = 'English';

  static const UserSettingsProfileEntity _profile = UserSettingsProfileEntity(
    fullName: 'ALi Hammadi',
    userId: '1253465',
    email: 'hamadea524@gmail.com',
    phoneNumber: '0963937472856',
    gender: 'Male',
    age: 24,
  );

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.select<ThemeCubit, bool>(
      (themeCubit) => themeCubit.state == ThemeMode.dark,
    );
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppStyles.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              CustomSettingTile(
                icon: Icons.medical_services_outlined,
                title: 'Medical Profile',
                subtitle: 'Prescriptions | Medicine | Notes',
                onTap: () {
                  Navigator.pushNamed(context, MyRoutes.medicalProfileScreen);
                },
              ),
              const SizedBox(height: 12),
              CustomSettingTile(
                icon: Icons.language,
                title: 'Language',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    selectedLanguage,
                    style: AppStyles.bodySmall.copyWith(
                      color: colorScheme.onPrimary,
                    ),
                  ),
                ),
                onTap: () => _showLanguageSheet(context),
              ),
              const SizedBox(height: 12),
              CustomSettingTile(
                icon: Icons.support_agent,
                title: 'Support',
                subtitle: '24/7 Support',
                onTap: () =>
                    _showInfoSnackBar('Support center is coming soon.'),
              ),
              const SizedBox(height: 12),
              CustomSettingTile(
                icon: Icons.dark_mode_outlined,
                title: 'Theme',
                trailing: Switch(
                  value: isDarkMode,
                  onChanged: (value) =>
                      context.read<ThemeCubit>().toggleTheme(value),
                ),
              ),
              const SizedBox(height: 12),
              CustomSettingTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Terms & Privacy',
                onTap: () {
                  Navigator.pushNamed(context, MyRoutes.privacyScreen);
                },
              ),
              const SizedBox(height: 12),
              CustomSettingTile(
                icon: Icons.mail_outline,
                title: 'Contact us',
                onTap: () {
                  Navigator.pushNamed(context, MyRoutes.contactUsScreen);
                },
              ),
              const SizedBox(height: 12),
              CustomSettingTile(
                icon: Icons.report_problem_outlined,
                title: 'Reports',
                onTap: () {
                  Navigator.pushNamed(context, MyRoutes.reportIssueScreen);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final profile = _resolveProfile(context);
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, MyRoutes.profileInfoScreen);
      },
      borderRadius: BorderRadius.circular(AppStyles.borderRadius),
      child: Row(
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: colorScheme.primary.withValues(alpha: 0.18),
            child: Icon(Icons.person, size: 44, color: colorScheme.primary),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(profile.fullName, style: AppStyles.headingSmall),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(profile.userId, style: AppStyles.bodyMedium),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.copy_outlined,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: colorScheme.outline),
        ],
      ),
    );
  }

  void _showLanguageSheet(BuildContext context) {
    String tempLanguage = selectedLanguage;
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(AppStyles.padding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Select language', style: AppStyles.headingMedium),
                  const SizedBox(height: 12),
                  RadioGroup<String>(
                    onChanged: (value) {
                      if (value != null) {
                        setModalState(() {
                          tempLanguage = value;
                        });
                      }
                    },
                    child: Column(
                      children: [
                        CustomLanguageOption(value: 'English'),
                        CustomLanguageOption(value: 'Arabic'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel', style: AppStyles.bodyMedium),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () {
                          setState(() {
                            selectedLanguage = tempLanguage;
                          });
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Select',
                          style: AppStyles.bodyMedium.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  UserSettingsProfileEntity _resolveProfile(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    UserAuthEntity? user;

    if (authState is AuthLoaded) {
      user = authState.user;
    } else if (authState is AuthProfileUpdated) {
      user = authState.user;
    }

    if (user == null) {
      return _profile;
    }

    return UserSettingsProfileEntity(
      fullName: user.name.isNotEmpty ? user.name : _profile.fullName,
      userId: user.id.isNotEmpty ? user.id : _profile.userId,
      email: user.email.isNotEmpty ? user.email : _profile.email,
      phoneNumber: (user.phoneNumber != null && user.phoneNumber!.isNotEmpty)
          ? user.phoneNumber!
          : _profile.phoneNumber,
      gender: (user.gender != null && user.gender!.isNotEmpty)
          ? user.gender!
          : _profile.gender,
      age: user.age ?? _profile.age,
    );
  }
}
