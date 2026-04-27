import 'package:afiete/core/constants/settings_strings.dart';
import 'package:afiete/core/constants/styles.dart';
import 'package:afiete/feature/relax/domain/entities/breathing_exercise_entity.dart';
import 'package:flutter/material.dart';

class BreathingExerciseCard extends StatelessWidget {
  final BreathingExerciseEntity exercise;
  final VoidCallback onStart;

  const BreathingExerciseCard({
    super.key,
    required this.exercise,
    required this.onStart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Get localized exercise details
    final localizedTitle = exercise.type.localizedTitle;
    final localizedDescription = exercise.type.localizedDescription;
    final localizedRecommendedFor = exercise.type.localizedRecommendedFor;
    final localizedSteps = exercise.type.localizedSteps;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(AppStyles.borderRadius),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.15)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: colorScheme.secondary.withValues(
                    alpha: 0.12,
                  ),
                  child: Icon(Icons.air_rounded, color: colorScheme.secondary),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizedTitle,
                        style: AppStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${exercise.durationMinutes} ${SettingsStrings.minuteAbbreviation} • $localizedRecommendedFor',
                        style: AppStyles.bodySmall.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              localizedDescription,
              style: AppStyles.bodySmall.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: localizedSteps
                  .map(
                    (step) => Chip(
                      label: Text(step),
                      backgroundColor: colorScheme.primaryContainer.withValues(
                        alpha: 0.38,
                      ),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                onPressed: onStart,
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(SettingsStrings.playLabel),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
