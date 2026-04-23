import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/core/theme/language_cubit.dart';
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
    final authState = context.watch<AuthCubit>().state;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final locale = context.select<LanguageCubit, Locale>(
      (cubit) => cubit.state,
    );
    final selectedLanguage = locale.languageCode == 'ar'
        ? '${SettingsStrings.arabic} (${SettingsStrings.arabicNative})'
        : SettingsStrings.english;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppStyles.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, authState),
              const SizedBox(height: 20),
              CustomSettingTile(
                icon: Icons.medical_services_outlined,
                title: SettingsStrings.medicalProfileTitle,
                subtitle: SettingsStrings.medicalProfileSubtitle,
                onTap: () {
                  Navigator.pushNamed(context, MyRoutes.medicalProfileScreen);
                },
              ),
              const SizedBox(height: 12),
              CustomSettingTile(
                icon: Icons.language,
                title: SettingsStrings.languageTitle,
                trailing: Text(
                  selectedLanguage,
                  style: AppStyles.bodySmall.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                onTap: () => _showLanguageSheet(context),
              ),
              const SizedBox(height: 12),
              CustomSettingTile(
                icon: Icons.support_agent,
                title: SettingsStrings.supportTitle,
                subtitle: SettingsStrings.supportSubtitle,
                onTap: () => _showSupportSheet(context),
              ),
              const SizedBox(height: 12),
              CustomSettingTile(
                icon: Icons.dark_mode_outlined,
                title: SettingsStrings.themeTitle,
                trailing: Transform.scale(
                  scale: 0.88,
                  child: Switch(
                    value: isDarkMode,
                    onChanged: (value) =>
                        context.read<ThemeCubit>().toggleTheme(value),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              CustomSettingTile(
                icon: Icons.privacy_tip_outlined,
                title: SettingsStrings.termsPrivacyTitle,
                onTap: () {
                  Navigator.pushNamed(context, MyRoutes.privacyScreen);
                },
              ),
              const SizedBox(height: 12),
              CustomSettingTile(
                icon: Icons.mail_outline,
                title: SettingsStrings.contactUsTitle,
                onTap: () {
                  Navigator.pushNamed(context, MyRoutes.contactUsScreen);
                },
              ),
              const SizedBox(height: 12),
              CustomSettingTile(
                icon: Icons.report_problem_outlined,
                title: SettingsStrings.reportsTitle,
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

  Widget _buildHeader(BuildContext context, AuthState authState) {
    final profile = _resolveProfile(authState);
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
    final locale = context.read<LanguageCubit>().state;
    final selectedLanguage = locale.languageCode == 'ar'
        ? SettingsStrings.arabic
        : SettingsStrings.english;
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
                  Text(
                    SettingsStrings.selectLanguageTitle,
                    style: AppStyles.headingMedium,
                  ),
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
                        CustomLanguageOption(value: SettingsStrings.english),
                        CustomLanguageOption(
                          value: SettingsStrings.arabic,
                          label:
                              '${SettingsStrings.arabic} (${SettingsStrings.arabicNative})',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          SettingsStrings.cancel,
                          style: AppStyles.bodyMedium,
                        ),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () {
                          final languageCode =
                              tempLanguage == SettingsStrings.arabic
                              ? 'ar'
                              : 'en';
                          context.read<LanguageCubit>().setLanguageCode(
                            languageCode,
                          );
                          Navigator.pop(context);
                        },
                        child: Text(
                          SettingsStrings.select,
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

  void _showSupportSheet(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.all(AppStyles.padding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                SettingsStrings.supportCenterTitle,
                style: AppStyles.headingMedium,
              ),
              const SizedBox(height: 8),
              Text(
                SettingsStrings.supportCenterSubtitle,
                style: AppStyles.bodySmall.copyWith(color: colorScheme.outline),
              ),
              const SizedBox(height: 14),
              _supportActionTile(
                icon: Icons.phone_in_talk_outlined,
                title: SettingsStrings.supportQuickCall,
                subtitle: SettingsStrings.supportQuickCallHint,
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showInfoSnackBar('Opening quick call support...');
                },
              ),
              const SizedBox(height: 8),
              _supportActionTile(
                icon: Icons.chat_bubble_outline,
                title: SettingsStrings.supportLiveChat,
                subtitle: SettingsStrings.supportLiveChatHint,
                onTap: () {
                  Navigator.pop(sheetContext);
                  _showInfoSnackBar('Opening support chat...');
                },
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: colorScheme.error.withValues(alpha: 0.35),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded, color: colorScheme.error),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            SettingsStrings.supportEmergencyTitle,
                            style: AppStyles.bodyMedium.copyWith(
                              color: colorScheme.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            SettingsStrings.supportEmergencyHint,
                            style: AppStyles.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  Widget _supportActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppStyles.bodyMedium),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppStyles.bodySmall.copyWith(
                      color: colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 14, color: colorScheme.outline),
          ],
        ),
      ),
    );
  }

  UserSettingsProfileEntity _resolveProfile(AuthState authState) {
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
