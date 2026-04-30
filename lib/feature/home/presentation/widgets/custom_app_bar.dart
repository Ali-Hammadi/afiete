import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final authState = context.watch<AuthCubit>().state;

    String userName = '';
    if (authState is AuthLoaded) {
      userName = authState.user.nickname;
    } else if (authState is AuthProfileUpdated) {
      userName = authState.user.nickname;
    }

    final greetingText = userName.isNotEmpty
        ? SettingsStrings.welcomeUser(userName)
        : SettingsStrings.startYourJourney;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 5.0),
      child: ListTile(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.person, size: 40),
        ),
        contentPadding: EdgeInsets.zero,
        title: Text(
          greetingText,
          style: AppStyles.headingMedium.copyWith(color: colorScheme.primary),
        ),
        subtitle: Text(
          SettingsStrings.startYourJourney,
          style: AppStyles.bodyMedium,
        ),
      ),
    );
  }
}
