import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  static const String _genderMale = 'Male';
  static const String _genderFemale = 'Female';

  String _normalizeGenderValue(String? raw) {
    final value = (raw ?? '').trim().toLowerCase();
    if (value == 'male' || value == 'ذكر') return _genderMale;
    if (value == 'female' || value == 'أنثى' || value == 'انثى') {
      return _genderFemale;
    }
    return _genderMale;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listenWhen: (previous, current) => current is AuthError,
      listener: (context, state) {
        if (state is AuthError && state.message.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final theme = Theme.of(context);
        final colorScheme = theme.colorScheme;
        final user = _currentUser(state);
        final nickname = user?.nickname.trim().isNotEmpty == true
            ? user!.nickname.trim()
            : '—';
        final username = user?.username.trim().isNotEmpty == true
            ? user!.username.trim()
            : '—';
        final displayAge = user?.age ?? 0;
        final displayGender = _displayGender(user?.gender);
        final displayBirthDate = _displayBirthDate(user?.birthDate);
        final displayPhone = user?.phoneNumber?.trim().isNotEmpty == true
            ? user!.phoneNumber!.trim()
            : '—';
        final displayEmail = user?.email.trim().isNotEmpty == true
            ? user!.email.trim()
            : '—';

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: theme.scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
            elevation: 0,
            title: Text(
              SettingsStrings.profileTitle,
              style: AppStyles.headingSmall,
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppStyles.padding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 44,
                      backgroundColor: colorScheme.primary.withValues(
                        alpha: 0.18,
                      ),
                      child: Icon(
                        Icons.person,
                        size: 50,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nickname, style: AppStyles.headingMedium),
                          const SizedBox(height: 8),
                          InkWell(
                            onTap: () => _copyUsername(context, username),
                            borderRadius: BorderRadius.circular(10),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      username,
                                      style: AppStyles.bodyMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.copy_outlined,
                                    size: 18,
                                    color: colorScheme.primary,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            SettingsStrings.yearsOld(displayAge),
                            style: AppStyles.bodySmall.copyWith(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  SettingsStrings.updateProfileHint,
                  style: AppStyles.bodyMedium.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 20),
                _buildInfoRow(
                  context: context,
                  label: SettingsStrings.nicknameLabel,
                  value: nickname,
                  icon: Icons.badge_outlined,
                  onEdit: user == null ? null : () => _editNickname(user),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  context: context,
                  label: SettingsStrings.emailTitleProfile,
                  value: displayEmail,
                  icon: Icons.email_outlined,
                  onEdit: user == null ? null : () => _editEmail(user),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  context: context,
                  label: SettingsStrings.passwordTitle,
                  value: '••••••••',
                  icon: Icons.lock_outline,
                  onEdit: user == null ? null : () => _editPassword(user),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  context: context,
                  label: SettingsStrings.birthDateTitle,
                  value: displayBirthDate,
                  icon: Icons.cake_outlined,
                  onEdit: user == null ? null : () => _editBirthDate(user),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  context: context,
                  label: SettingsStrings.genderTitle,
                  value: displayGender,
                  icon: Icons.person_outline,
                  onEdit: user == null ? null : () => _editGender(user),
                ),
                const SizedBox(height: 12),
                _buildInfoRow(
                  context: context,
                  label: SettingsStrings.phoneTitleProfile,
                  value: displayPhone,
                  icon: Icons.phone_outlined,
                  onEdit: user == null ? null : () => _editPhone(user),
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.center,
                  child: TextButton(
                    onPressed: _handleDeleteAccount,
                    child: Text(SettingsStrings.deleteAccountTitle),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _copyUsername(BuildContext context, String username) async {
    if (username.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: username));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${SettingsStrings.usernameLabel} copied')),
    );
  }

  UserAuthEntity? _currentUser(AuthState authState) {
    if (authState is AuthLoaded) return authState.user;
    if (authState is AuthProfileUpdated) return authState.user;
    return null;
  }

  String _displayGender(String? raw) {
    final normalized = _normalizeGenderValue(raw);
    if (normalized == _genderFemale) return SettingsStrings.female;
    return SettingsStrings.male;
  }

  String _displayBirthDate(DateTime? birthDate) {
    if (birthDate == null) return '—';
    return birthDate.toLocal().toString().split(' ').first;
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required VoidCallback? onEdit,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.4)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: colorScheme.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppStyles.bodySmall),
                const SizedBox(height: 4),
                Text(
                  value,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppStyles.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: onEdit,
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(SettingsStrings.editNote),
          ),
        ],
      ),
    );
  }

  Future<String?> _showTextEditor({
    required String title,
    required String label,
    required String initialValue,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? hintText,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    int? maxLength,
  }) async {
    final controller = TextEditingController(text: initialValue);
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<String?>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              inputFormatters: inputFormatters,
              maxLength: maxLength,
              validator: validator,
              decoration: InputDecoration(
                labelText: label,
                hintText: hintText,
                prefixIcon: Icon(icon),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(SettingsStrings.cancel),
            ),
            FilledButton(
              onPressed: () {
                if (!(formKey.currentState?.validate() ?? false)) {
                  return;
                }
                Navigator.pop(dialogContext, controller.text.trim());
              },
              child: Text(SettingsStrings.saveChanges),
            ),
          ],
        );
      },
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        controller.dispose();
      } catch (_) {}
    });

    return result;
  }

  Future<String?> _showGenderEditor(UserAuthEntity user) async {
    String selectedGender = _normalizeGenderValue(user.gender);

    return showDialog<String?>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(SettingsStrings.genderTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      RadioGroup<String>(
                        groupValue: selectedGender,
                        onChanged: (value) {
                          if (value == null) return;
                          setDialogState(() {
                            selectedGender = value;
                          });
                        },
                        child: const Radio<String>(value: _genderMale),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(SettingsStrings.male)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      RadioGroup<String>(
                        groupValue: selectedGender,
                        onChanged: (value) {
                          if (value == null) return;
                          setDialogState(() {
                            selectedGender = value;
                          });
                        },
                        child: const Radio<String>(value: _genderFemale),
                      ),
                      const SizedBox(width: 8),
                      Expanded(child: Text(SettingsStrings.female)),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: Text(SettingsStrings.cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(dialogContext, selectedGender),
                  child: Text(SettingsStrings.saveChanges),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<({String currentPassword, String newPassword})?>
  _showPasswordEditor() async {
    final formKey = GlobalKey<FormState>();
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    bool showCurrentPassword = false;
    bool showNewPassword = false;
    bool showConfirmPassword = false;

    final result =
        await showDialog<({String currentPassword, String newPassword})>(
          context: context,
          builder: (dialogContext) {
            return StatefulBuilder(
              builder: (context, setDialogState) {
                return AlertDialog(
                  scrollable: true,
                  title: Text(SettingsStrings.passwordTitle),
                  content: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          controller: currentPasswordController,
                          obscureText: !showCurrentPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return SettingsStrings.currentPasswordRequired;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: SettingsStrings.oldPasswordLabel,
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                showCurrentPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                setDialogState(() {
                                  showCurrentPassword = !showCurrentPassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: newPasswordController,
                          obscureText: !showNewPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return SettingsStrings.newPasswordRequired;
                            }
                            if (value.length < 6) {
                              return SettingsStrings.passwordAtLeastSixChars;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: SettingsStrings.newPasswordLabel,
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                showNewPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                setDialogState(() {
                                  showNewPassword = !showNewPassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: confirmPasswordController,
                          obscureText: !showConfirmPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return SettingsStrings.confirmPasswordRequired;
                            }
                            if (value != newPasswordController.text) {
                              return SettingsStrings.passwordMismatch;
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: SettingsStrings.confirmPasswordLabel,
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(
                                showConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                setDialogState(() {
                                  showConfirmPassword = !showConfirmPassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialogContext),
                      child: Text(SettingsStrings.cancel),
                    ),
                    FilledButton(
                      onPressed: () {
                        if (!(formKey.currentState?.validate() ?? false)) {
                          return;
                        }
                        Navigator.pop(dialogContext, (
                          currentPassword: currentPasswordController.text,
                          newPassword: newPasswordController.text,
                        ));
                      },
                      child: Text(SettingsStrings.saveChanges),
                    ),
                  ],
                );
              },
            );
          },
        );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        currentPasswordController.dispose();
      } catch (_) {}
      try {
        newPasswordController.dispose();
      } catch (_) {}
      try {
        confirmPasswordController.dispose();
      } catch (_) {}
    });

    return result;
  }

  Future<void> _editNickname(UserAuthEntity user) async {
    final newNickname = await _showTextEditor(
      title: SettingsStrings.editProfileTitle,
      label: SettingsStrings.nicknameLabel,
      initialValue: user.nickname,
      icon: Icons.badge_outlined,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return SettingsStrings.nameRequired;
        }
        return null;
      },
    );

    if (newNickname == null || newNickname == user.nickname.trim()) {
      return;
    }

    await _saveProfileInfo(user, nickname: newNickname);
  }

  Future<void> _editPhone(UserAuthEntity user) async {
    final newPhone = await _showTextEditor(
      title: SettingsStrings.phoneTitleProfile,
      label: SettingsStrings.phoneTitleProfile,
      initialValue: user.phoneNumber ?? '',
      icon: Icons.phone_outlined,
      keyboardType: TextInputType.phone,
      validator: (value) {
        final text = value?.trim() ?? '';
        if (text.isNotEmpty && text.length < 10) {
          return SettingsStrings.invalidPhoneNumber;
        }
        return null;
      },
    );

    if (newPhone == null) {
      return;
    }

    final normalizedPhone = newPhone.trim();
    if (normalizedPhone == (user.phoneNumber ?? '').trim()) {
      return;
    }

    await _saveProfileInfo(
      user,
      phoneNumber: normalizedPhone.isEmpty ? '' : normalizedPhone,
    );
  }

  Future<void> _editBirthDate(UserAuthEntity user) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: user.birthDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (picked == null) {
      return;
    }

    if (user.birthDate != null && _sameDate(user.birthDate!, picked)) {
      return;
    }

    await _saveProfileInfo(user, birthDate: picked);
  }

  Future<void> _editGender(UserAuthEntity user) async {
    final selectedGender = await _showGenderEditor(user);
    if (selectedGender == null) {
      return;
    }

    if (_normalizeGenderValue(user.gender) == selectedGender) {
      return;
    }

    await _saveProfileInfo(user, gender: selectedGender);
  }

  Future<void> _editPassword(UserAuthEntity user) async {
    if (user.email.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(SettingsStrings.couldNotRetrieveUserEmail)),
      );
      return;
    }

    final messenger = ScaffoldMessenger.of(context);
    final authCubit = context.read<AuthCubit>();

    final credentials = await _showPasswordEditor();
    if (credentials == null) {
      return;
    }

    final success = await authCubit.changePassword(
      email: user.email.trim(),
      currentPassword: credentials.currentPassword,
      newPassword: credentials.newPassword,
    );

    if (!mounted) return;

    if (success) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(SettingsStrings.passwordChanged)),
      );
    }
  }

  Future<void> _editEmail(UserAuthEntity user) async {
    final messenger = ScaffoldMessenger.of(context);
    final authCubit = context.read<AuthCubit>();

    final newEmail = await _showTextEditor(
      title: SettingsStrings.changeEmailTitle,
      label: SettingsStrings.emailAddressLabel,
      initialValue: user.email,
      icon: Icons.email_outlined,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        final text = value?.trim() ?? '';
        if (text.isEmpty) {
          return SettingsStrings.emailRequired;
        }
        if (!text.contains('@')) {
          return SettingsStrings.invalidEmailError;
        }
        return null;
      },
    );

    if (newEmail == null || newEmail == user.email.trim()) {
      return;
    }

    final otpMessage = await authCubit.requestEmailChangeOtp(
      newEmail: newEmail,
    );
    if (!mounted) return;

    if (otpMessage != null) {
      messenger.showSnackBar(SnackBar(content: Text(otpMessage)));
      return;
    }

    messenger.showSnackBar(
      SnackBar(content: Text(SettingsStrings.otpSentToNewEmail)),
    );

    final otp = await _showTextEditor(
      title: SettingsStrings.verifyNewEmailTitle,
      label: SettingsStrings.verify,
      initialValue: '',
      icon: Icons.pin_outlined,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      maxLength: 4,
      validator: (value) {
        final text = value?.trim() ?? '';
        if (text.length != 4) {
          return SettingsStrings.invalidFourDigitCode;
        }
        return null;
      },
    );

    if (otp == null) {
      return;
    }

    final success = await authCubit.confirmEmailChange(
      newEmail: newEmail,
      otp: otp,
    );
    if (!mounted) return;

    if (success) {
      messenger.showSnackBar(
        SnackBar(content: Text(SettingsStrings.emailUpdatedSuccess)),
      );
    }
  }

  Future<void> _saveProfileInfo(
    UserAuthEntity user, {
    String? nickname,
    DateTime? birthDate,
    String? gender,
    String? phoneNumber,
  }) async {
    final saved = await context.read<AuthCubit>().updateProfileInfo(
      nickname: nickname ?? user.nickname,
      birthDate: birthDate ?? user.birthDate ?? DateTime.now(),
      gender: gender ?? _normalizeGenderValue(user.gender),
      phoneNumber: phoneNumber ?? user.phoneNumber ?? '',
    );

    if (!mounted) return;

    if (saved) {
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(content: Text(SettingsStrings.profileUpdatedSuccess)),
      );
    }
  }

  bool _sameDate(DateTime first, DateTime second) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }

  Future<void> _handleDeleteAccount() async {
    await Navigator.pushNamed(context, MyRoutes.deleteAccountScreen);
  }
}
