import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/core/theme/language_cubit.dart';
import 'package:afiete/core/theme/theme_cubit.dart';
import 'package:afiete/core/utils/age_utils.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:afiete/feature/settings/presentation/widgets/language_option.dart';
import 'package:afiete/feature/settings/presentation/widgets/setting_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthCubit>().refreshProfileFromBackend();
    });
  }

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
        ? SettingsStrings.arabic
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
                subtitle:
                    '${SettingsStrings.currentLanguageTitle}: $selectedLanguage',
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedLanguage,
                        style: AppStyles.bodySmall.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 18,
                        color: colorScheme.primary,
                      ),
                    ],
                  ),
                ),
                onTap: () => _showLanguageSheet(context),
              ),
              const SizedBox(height: 12),
              CustomSettingTile(
                icon: Icons.dark_mode_outlined,
                title: SettingsStrings.themeTitle,
                trailing: SwitchTheme(
                  data: SwitchTheme.of(context).copyWith(
                    trackOutlineWidth: const WidgetStatePropertyAll(0.8),
                  ),
                  child: Transform.scale(
                    scale: 0.88,
                    child: Switch(
                      value: isDarkMode,
                      onChanged: (value) =>
                          context.read<ThemeCubit>().toggleTheme(value),
                    ),
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
              const SizedBox(height: 12),
              CustomSettingTile(
                icon: Icons.logout,
                title: SettingsStrings.logoutTitle,
                subtitle: SettingsStrings.logoutSubtitle,
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.black,
                ),
                onTap: () => _confirmLogout(context, authState),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AuthState authState) {
    final authUser = _resolveAuthUser(authState);
    final colorScheme = Theme.of(context).colorScheme;
    final displayName = _displayUserValue(
      authUser?.nickname?.trim(),
      fallback: authUser?.username.trim() ?? '—',
    );
    final username = _displayUserValue(authUser?.username.trim());
    final email = _displayUserValue(authUser?.email.trim());
    final phoneNumber = _displayUserValue(authUser?.phoneNumber?.trim());
    final gender = _displayGender(authUser?.gender);
    final age = authUser?.age ?? calculateAge(authUser?.birthDate) ?? 0;
    final birthDate = _displayBirthDate(authUser?.birthDate);

    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          MyRoutes.profileInfoScreen,
          arguments: authUser,
        );
      },
      borderRadius: BorderRadius.circular(AppStyles.borderRadius),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.22),
          borderRadius: BorderRadius.circular(AppStyles.borderRadius),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.22),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 38,
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.18),
                  child: Icon(
                    Icons.person,
                    size: 44,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(displayName, style: AppStyles.headingSmall),
                      const SizedBox(height: 4),
                      Text(
                        SettingsStrings.updateProfileHint,
                        style: AppStyles.bodySmall.copyWith(
                          color: colorScheme.onSurface.withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildProfileLine(
              context,
              label: SettingsStrings.usernameLabel,
              value: username,
              onCopy: username == '—'
                  ? null
                  : () => _copyToClipboard(
                      context,
                      username,
                      SettingsStrings.usernameLabel,
                    ),
            ),
            const SizedBox(height: 8),
            _buildProfileLine(
              context,
              label: SettingsStrings.emailTitleProfile,
              value: email,
              onCopy: email == '—'
                  ? null
                  : () => _copyToClipboard(
                      context,
                      email,
                      SettingsStrings.emailTitleProfile,
                    ),
            ),
            const SizedBox(height: 8),
            _buildProfileLine(
              context,
              label: SettingsStrings.phoneTitleProfile,
              value: phoneNumber,
              onCopy: phoneNumber == '—'
                  ? null
                  : () => _copyToClipboard(
                      context,
                      phoneNumber,
                      SettingsStrings.phoneTitleProfile,
                    ),
            ),
            const SizedBox(height: 8),
            _buildProfileLine(
              context,
              label: SettingsStrings.genderTitle,
              value: gender,
            ),
            const SizedBox(height: 8),
            _buildProfileLine(
              context,
              label: SettingsStrings.birthDateTitle,
              value: birthDate,
            ),
            const SizedBox(height: 8),
            _buildProfileLine(
              context,
              label: SettingsStrings.ageTitle,
              value: age > 0 ? age.toString() : '—',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileLine(
    BuildContext context, {
    required String label,
    required String value,
    VoidCallback? onCopy,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 118,
          child: Text(
            label,
            style: AppStyles.bodySmall.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.68),
            ),
          ),
        ),
        Expanded(
          child: InkWell(
            onTap: onCopy,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      value,
                      style: AppStyles.bodyMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (onCopy != null) ...[
                    const SizedBox(width: 8),
                    Icon(
                      Icons.copy_outlined,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  String _displayUserValue(String? value, {String fallback = '—'}) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return fallback;
    return trimmed;
  }

  String _displayGender(String? raw) {
    final value = (raw ?? '').trim().toLowerCase();
    if (value.isEmpty) return '—';
    if (value == 'female' ||
        value == 'f' ||
        value == 'أنثى' ||
        value == 'انثى') {
      return SettingsStrings.female;
    }
    if (value == 'male' || value == 'm' || value == 'ذكر') {
      return SettingsStrings.male;
    }
    return raw!.trim();
  }

  String _displayBirthDate(DateTime? birthDate) {
    if (birthDate == null) return '—';
    return birthDate.toLocal().toString().split(' ').first;
  }

  Future<void> _copyToClipboard(
    BuildContext context,
    String value,
    String label,
  ) async {
    if (value.isEmpty || value == '—') return;
    await Clipboard.setData(ClipboardData(text: value));
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$label copied')));
  }

  void _showLanguageSheet(BuildContext context) {
    final currentLocale = context.read<LanguageCubit>().state;
    String tempLanguage = currentLocale.languageCode == 'ar' ? 'ar' : 'en';
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
                  Column(
                    children: [
                      CustomLanguageOption(
                        value: 'en',
                        groupValue: tempLanguage,
                        label: SettingsStrings.english,
                        onTap: () => setModalState(() => tempLanguage = 'en'),
                      ),
                      const SizedBox(height: 10),
                      CustomLanguageOption(
                        value: 'ar',
                        groupValue: tempLanguage,
                        label: SettingsStrings.arabic,
                        onTap: () => setModalState(() => tempLanguage = 'ar'),
                      ),
                    ],
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
                        onPressed: () async {
                          await context.read<LanguageCubit>().setLanguageCode(
                            tempLanguage,
                          );
                          if (context.mounted) {
                            Navigator.pop(context);
                          }
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

  Future<void> _confirmLogout(BuildContext context, AuthState authState) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(SettingsStrings.logoutConfirmTitle),
          content: Text(SettingsStrings.logoutConfirmMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(SettingsStrings.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(SettingsStrings.logoutTitle),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) return;

    final loggedOut = await context.read<AuthCubit>().logout();

    // The logout flow triggers a full app wipe and restart; don't perform
    // duplicate local clearing or navigation here.
    if (!context.mounted || !loggedOut) return;
  }

  UserAuthEntity? _resolveAuthUser(AuthState authState) {
    if (authState is AuthLoaded) return authState.user;
    if (authState is AuthProfileUpdated) return authState.user;
    if (authState is SignupOtpVerified) return authState.user;
    return null;
  }
}
