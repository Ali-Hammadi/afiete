import 'package:afiete/core/constants/app_colors.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:afiete/feature/settings/domin/entity/setting_entity.dart';
import 'package:afiete/feature/settings/presentation/widget/info_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileInfoScreen extends StatelessWidget {
  const ProfileInfoScreen({super.key});

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
    final authState = context.watch<AuthCubit>().state;
    final user = authState is AuthLoaded
      ? authState.user
      : authState is AuthProfileUpdated
      ? authState.user
      : null;

    final displayName = user?.name.isNotEmpty == true
      ? user!.name
      : _profile.fullName;
    final displayId = user?.id.isNotEmpty == true ? user!.id : _profile.userId;
    final displayEmail = user?.email.isNotEmpty == true
      ? user!.email
      : _profile.email;
    final displayPhone = user?.phoneNumber?.isNotEmpty == true
      ? user!.phoneNumber!
      : _profile.phoneNumber;
    final displayGender = user?.gender?.isNotEmpty == true
      ? user!.gender!
      : _profile.gender;
    final displayAge = user?.age ?? _profile.age;

    return Scaffold(
      backgroundColor: AppColors.primarybackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primarybackgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppStyles.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 44,
                  backgroundColor: AppColors.unselectedFieldColor,
                  child: Icon(
                    Icons.person,
                    size: 50,
                    color: AppColors.whiteColor,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(displayName, style: AppStyles.headingSmall),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(displayId, style: AppStyles.bodyLarge),
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
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.edit_square, color: AppColors.primaryColor),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Divider(
              color: AppColors.unselectedIconColor.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 24),
            InfoRow(
              icon: Icons.call,
              leftText: displayPhone,
              rightActionText: 'Add Number',
            ),
            const SizedBox(height: 20),
            InfoRow(
              icon: Icons.email,
              leftText: displayEmail,
              rightActionText: 'Change Email',
            ),
            const SizedBox(height: 20),
            InfoRow(
              icon: Icons.lock,
              leftText: '************',
              rightActionText: 'Change Password',
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Icon(Icons.male, color: AppColors.selectedIconcolor, size: 34),
                const SizedBox(width: 8),
                Text(displayGender, style: AppStyles.bodyMedium),
                const SizedBox(width: 30),
                Icon(
                  Icons.cake_outlined,
                  color: AppColors.unselectedIconColor,
                  size: 30,
                ),
                const SizedBox(width: 8),
                Text('$displayAge Years old', style: AppStyles.bodyMedium),
              ],
            ),
            const SizedBox(height: 64),
            Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.errorColor,
                  foregroundColor: AppColors.whiteColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'Delete Account',
                  style: AppStyles.headingSmall.copyWith(
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
