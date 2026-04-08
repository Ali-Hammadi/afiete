import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:afiete/feature/settings/domin/entity/setting_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isDarkMode = false;
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
    return Scaffold(
      backgroundColor: AppColors.primarybackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppStyles.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _SettingTile(
                icon: Icons.medical_services_outlined,
                title: 'Medical Profile',
                subtitle: 'Notes | Prescriptions',
                onTap: () {
                  Navigator.pushNamed(context, MyRoutes.medicalProfileScreen);
                },
              ),
              const SizedBox(height: 12),
              _SettingTile(
                icon: Icons.language,
                title: 'Language',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.unselectedIconColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    selectedLanguage,
                    style: AppStyles.bodySmall.copyWith(
                      color: AppColors.whiteColor,
                    ),
                  ),
                ),
                onTap: () => _showLanguageSheet(context),
              ),
              const SizedBox(height: 12),
              _SettingTile(
                icon: Icons.support_agent,
                title: 'Support',
                subtitle: '24/7 Support',
                onTap: () =>
                    _showInfoSnackBar('Support center is coming soon.'),
              ),
              const SizedBox(height: 12),
              _SettingTile(
                icon: Icons.dark_mode_outlined,
                title: 'Theme',
                trailing: Switch(
                  value: isDarkMode,
                  activeColor: AppColors.primaryColor,
                  onChanged: (value) {
                    setState(() {
                      isDarkMode = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              _SettingTile(
                icon: Icons.privacy_tip_outlined,
                title: 'Terms & Privacy',
                onTap: () =>
                    _showInfoSnackBar('Terms & privacy page is coming soon.'),
              ),
              const SizedBox(height: 12),
              _SettingTile(
                icon: Icons.mail_outline,
                title: 'Contact us',
                onTap: () => _showInfoSnackBar('Contact page is coming soon.'),
              ),
              const SizedBox(height: 12),
              _SettingTile(
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

    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, MyRoutes.profileInfoScreen);
      },
      borderRadius: BorderRadius.circular(AppStyles.borderRadius),
      child: Row(
        children: [
          CircleAvatar(
            radius: 38,
            backgroundColor: AppColors.unselectedFieldColor,
            child: Icon(Icons.person, size: 44, color: AppColors.whiteColor),
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
                      color: AppColors.primaryColor,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: AppColors.unselectedIconColor,
          ),
        ],
      ),
    );
  }

  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(AppStyles.padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Select language', style: AppStyles.headingMedium),
              const SizedBox(height: 12),
              _LanguageTile(
                value: 'English',
                groupValue: selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value;
                  });
                  Navigator.pop(context);
                },
              ),
              _LanguageTile(
                value: 'Arabic',
                groupValue: selectedLanguage,
                onChanged: (value) {
                  setState(() {
                    selectedLanguage = value;
                  });
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.primaryColor),
    );
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

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppStyles.borderRadius - 4),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppStyles.borderRadius - 4),
          border: Border.all(
            color: AppColors.unselectedFieldColor.withValues(alpha: 0.4),
          ),
          color: AppColors.whiteColor,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.unselectedIconColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppStyles.bodyMedium),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!, style: AppStyles.bodySmall),
                  ],
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppColors.unselectedIconColor,
                ),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;

  const _LanguageTile({
    required this.value,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(value, style: AppStyles.bodyMedium),
      trailing: Radio<String>(
        value: value,
        groupValue: groupValue,
        activeColor: AppColors.primaryColor,
        onChanged: (v) {
          if (v != null) {
            onChanged(v);
          }
        },
      ),
      onTap: () => onChanged(value),
    );
  }
}
