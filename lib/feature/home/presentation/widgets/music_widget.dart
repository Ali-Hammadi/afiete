import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/core/assets/icon_image_links.dart';
import 'package:afiete/feature/music/presentation/cubit/music_cubit.dart';
import 'package:afiete/feature/music/presentation/screens/music_hub_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomMusicWidget extends StatelessWidget {
  const CustomMusicWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return BlocBuilder<MusicCubit, MusicState>(
      builder: (context, state) {
        final trackTitle = state is MusicLoaded && state.activeTrack != null
            ? state.activeTrack!.title
            : SettingsStrings.recommendedForYou;
        final trackSubtitle = state is MusicLoaded && state.activeTrack != null
            ? state.activeTrack!.description ?? SettingsStrings.musicSubtitle
            : SettingsStrings.musicSubtitle;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: AppStyles.padding),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  colorScheme.primaryContainer.withValues(alpha: 0.55),
                  theme.cardColor,
                ],
              ),
              border: Border.all(
                color: colorScheme.primary.withValues(alpha: 0.18),
              ),
              color: theme.cardColor,
              borderRadius: BorderRadius.all(
                Radius.circular(AppStyles.borderRadius),
              ),
            ),
            child: Column(
              children: [
                Image.asset(ImageLinks.beatch),
                ListTile(
                  title: Text(
                    trackTitle,
                    style: AppStyles.bodyMedium.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  subtitle: Text(trackSubtitle, style: AppStyles.bodyMedium),
                  trailing: SizedBox(
                    width: 64,
                    child: IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => BlocProvider.value(
                              value: context.read<MusicCubit>(),
                              child: const MusicHubScreen(),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
