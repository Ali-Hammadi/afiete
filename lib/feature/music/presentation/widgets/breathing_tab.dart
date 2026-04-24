import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/feature/music/domain/entities/breathing_exercise_entity.dart';
import 'package:afiete/feature/music/presentation/cubit/music_cubit.dart';
import 'package:afiete/feature/music/presentation/widgets/breathing_exercise_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BreathingTab extends StatelessWidget {
  final void Function(BreathingExerciseEntity exercise) onOpenExercise;

  const BreathingTab({super.key, required this.onOpenExercise});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<MusicCubit, MusicState>(
      builder: (context, state) {
        if (state is MusicLoaded) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                SettingsStrings.breathingSubtitle,
                style: AppStyles.bodyMedium.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              if (state.activeBreathingExercise != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(AppStyles.borderRadius),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        SettingsStrings.currentSessionLabel,
                        style: AppStyles.bodySmall.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.activeBreathingExercise!.title,
                        style: AppStyles.headingSmall,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.activeBreathingExercise!.description,
                        style: AppStyles.bodyMedium,
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () =>
                            onOpenExercise(state.activeBreathingExercise!),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: Text(SettingsStrings.startExercise),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                SettingsStrings.viewAllExercises,
                style: AppStyles.headingMedium,
              ),
              const SizedBox(height: 12),
              if (state.breathingExercises.isEmpty)
                Text(
                  SettingsStrings.noExerciseAvailable,
                  style: AppStyles.bodyMedium.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                )
              else
                ...state.breathingExercises.map(
                  (exercise) => BreathingExerciseCard(
                    exercise: exercise,
                    onStart: () => onOpenExercise(exercise),
                  ),
                ),
            ],
          );
        }

        if (state is MusicLoading || state is MusicInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is MusicError) {
          return Center(child: Text(state.message));
        }

        return const SizedBox.shrink();
      },
    );
  }
}
