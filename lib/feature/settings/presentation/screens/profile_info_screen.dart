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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nicknameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  DateTime _selectedBirthDate = DateTime.now();
  String _selectedGender = _genderMale;
  bool _isInitialized = false;
  bool _isSaving = false;
  bool _isPasswordVisible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;
    final user = _currentUser;

    _nicknameController.text = user?.nickname ?? '';
    _emailController.text = user?.email ?? '';
    _phoneController.text = user?.phoneNumber ?? '';
    _selectedBirthDate = user?.birthDate ?? DateTime.now();
    _selectedGender = _normalizeGenderValue(user?.gender);
    _isInitialized = true;
  }

  String _normalizeGenderValue(String? raw) {
    final value = (raw ?? '').trim().toLowerCase();
    if (value == 'male' || value == 'ذكر') return _genderMale;
    if (value == 'female' || value == 'أنثى' || value == 'انثى') {
      return _genderFemale;
    }
    return _genderMale;
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = _currentUser;
    final displayUsername = user?.username.isNotEmpty == true
        ? user!.username
        : '';
    final displayId = displayUsername;
    final displayAge = user?.age ?? 0;

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
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                        const SizedBox(height: 6),

                        InkWell(
                          onTap: () => _copyUsername(context, displayId),
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(displayId, style: AppStyles.bodyLarge),
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
                        const SizedBox(height: 4),

                        const SizedBox(height: 2),
                        Text(
                          user?.nickname?.isNotEmpty == true
                              ? user!.nickname ?? '—'
                              : '—',
                          style: AppStyles.bodyMedium,
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
              _buildField(
                controller: _nicknameController,
                label: 'Nickname',
                icon: Icons.badge_outlined,
                keyboardType: TextInputType.text,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Nickname is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _emailController,
                label: SettingsStrings.emailAddressLabel,
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.isEmpty) {
                    return 'Email is required';
                  }
                  if (!text.contains('@')) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildField(
                controller: _passwordController,
                label: SettingsStrings.passwordTitle,
                icon: Icons.lock_outline,
                keyboardType: TextInputType.visiblePassword,
                isPassword: true,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedBirthDate,
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedBirthDate = picked;
                    });
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: SettingsStrings.birthDateTitle,
                    prefixIcon: const Icon(Icons.cake_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    _selectedBirthDate.toLocal().toString().split(' ').first,
                    style: AppStyles.bodyMedium,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedGender,
                decoration: InputDecoration(
                  labelText: SettingsStrings.genderTitle,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  prefixIcon: const Icon(Icons.transgender),
                ),
                items: [
                  DropdownMenuItem(
                    value: _genderMale,
                    child: Text(SettingsStrings.male),
                  ),
                  DropdownMenuItem(
                    value: _genderFemale,
                    child: Text(SettingsStrings.female),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedGender = value;
                    });
                  }
                },
              ),
              const SizedBox(height: 18),
              _buildField(
                controller: _phoneController,
                label:
                    '${SettingsStrings.phoneTitleProfile} (with country code)',
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (value.length < 10) {
                      return SettingsStrings.invalidPhoneNumber;
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Icon(
                    Icons.cake_outlined,
                    color: colorScheme.outline,
                    size: 30,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    SettingsStrings.yearsOld(displayAge),
                    style: AppStyles.bodyMedium,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _isSaving ? null : _handleSave,
                  child: _isSaving
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
                          SettingsStrings.saveProfileChanges,
                          style: AppStyles.bodyMedium.copyWith(
                            color: colorScheme.onPrimary,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _handleDeleteAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    SettingsStrings.deleteAccountTitle,
                    style: AppStyles.headingSmall.copyWith(
                      color: colorScheme.onError,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
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

  UserAuthEntity? get _currentUser {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthLoaded) return authState.user;
    if (authState is AuthProfileUpdated) return authState.user;
    return null;
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required TextInputType keyboardType,
    required String? Function(String?) validator,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: isPassword && !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final nickname = _nicknameController.text.trim();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(SettingsStrings.editProfileTitle),
          content: Text(SettingsStrings.saveProfileChangesConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(SettingsStrings.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(SettingsStrings.select),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _isSaving = true;
    });

    try {
      final saved = await context.read<AuthCubit>().updateProfileInfo(
        nickname: nickname,
        birthDate: _selectedBirthDate,
        gender: _selectedGender,
        phoneNumber: _phoneController.text.trim().isNotEmpty
            ? _phoneController.text.trim()
            : null,
      );

      if (!mounted || !saved) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(SettingsStrings.profileUpdatedSuccess)),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Future<void> _handleDeleteAccount() async {
    await Navigator.pushNamed(context, MyRoutes.deleteAccountScreen);
  }
}
