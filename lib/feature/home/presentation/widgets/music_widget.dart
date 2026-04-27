import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/feature/relax/presentation/cubit/music_cubit.dart';
import 'package:afiete/feature/relax/presentation/screens/music_hub_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomMusicWidget extends StatelessWidget {
  const CustomMusicWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppStyles.padding),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primaryContainer.withValues(alpha: 0.45),
              theme.cardColor,
            ],
          ),
          border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
          borderRadius: BorderRadius.circular(AppStyles.borderRadius),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: CircleAvatar(
            backgroundColor: colorScheme.primaryContainer,
            child: Icon(
              Icons.library_music_rounded,
              color: colorScheme.primary,
            ),
          ),
          title: Text(
            SettingsStrings.relax,
            style: AppStyles.headingSmall.copyWith(color: colorScheme.primary),
          ),
          subtitle: Text(
            SettingsStrings.musicSubtitle,
            style: AppStyles.bodySmall,
          ),
          trailing: Icon(
            Icons.arrow_forward_ios_rounded,
            size: 18,
            color: colorScheme.onSurfaceVariant,
          ),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<MusicCubit>(),
                  child: const MusicHubScreen(),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
