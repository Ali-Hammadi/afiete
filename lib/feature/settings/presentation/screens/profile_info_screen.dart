import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/routes/app_route.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:afiete/feature/settings/presentation/widgets/info_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileInfoScreen extends StatefulWidget {
  const ProfileInfoScreen({super.key});

  @override
  State<ProfileInfoScreen> createState() => _ProfileInfoScreenState();
}

class _ProfileInfoScreenState extends State<ProfileInfoScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  DateTime _selectedBirthDate = DateTime.now();
  String _selectedGender = 'Male';
  bool _isInitialized = false;
  bool _isSaving = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInitialized) return;
    final user = _currentUser;
    _nameController.text = user?.name ?? '';
    _emailController.text = user?.email ?? '';
    _selectedBirthDate = user?.birthDate ?? DateTime.now();
    _selectedGender = user?.gender ?? 'Male';
    _isInitialized = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = _currentUser;
    final displayId = user?.id.isNotEmpty == true ? user!.id : '1253465';
    final displayAge = user?.age ?? 24;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
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
                        Text(
                          _nameController.text.isNotEmpty
                              ? _nameController.text
                              : '—',
                          style: AppStyles.headingSmall,
                        ),
                        const SizedBox(height: 4),
                        Row(
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
                controller: _nameController,
                label: SettingsStrings.fullNameTitle,
                icon: Icons.badge_outlined,
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
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
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                  DropdownMenuItem(value: 'Other', child: Text('Other')),
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
              Row(
                children: [
                  Icon(
                    Icons.cake_outlined,
                    color: colorScheme.outline,
                    size: 30,
                  ),
                  const SizedBox(width: 8),
                  Text('$displayAge Years old', style: AppStyles.bodyMedium),
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
              const SizedBox(height: 20),
              CustomInfoRow(
                icon: Icons.email,
                leftText: _emailController.text.isNotEmpty
                    ? _emailController.text
                    : '—',
                rightActionText: SettingsStrings.changeEmailTitle,
                onActionPressed: _handleChangeEmail,
              ),
              const SizedBox(height: 20),
              CustomInfoRow(
                icon: Icons.lock,
                leftText: '************',
                rightActionText: SettingsStrings.changePasswordTitle,
                onActionPressed: _handleChangePassword,
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
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
      ),
      onChanged: (_) => setState(() {}),
    );
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final name = _nameController.text.trim();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(SettingsStrings.editProfileTitle),
          content: const Text('Save these profile changes?'),
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
        name: name,
        birthDate: _selectedBirthDate,
        gender: _selectedGender,
        phoneNumber: '',
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

  Future<void> _handleChangeEmail() async {
    await Navigator.pushNamed(context, MyRoutes.emailChangeScreen);
    if (mounted) {
      setState(() {
        final user = _currentUser;
        _emailController.text = user?.email ?? '';
      });
    }
  }

  Future<void> _handleChangePassword() async {
    await Navigator.pushNamed(context, MyRoutes.passwordChangeScreen);
  }

  Future<void> _handleDeleteAccount() async {
    await Navigator.pushNamed(context, MyRoutes.deleteAccountScreen);
  }
}
