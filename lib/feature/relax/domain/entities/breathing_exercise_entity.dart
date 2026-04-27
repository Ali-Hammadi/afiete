import 'package:afiete/core/constants/settings_strings.dart';
import 'package:equatable/equatable.dart';

enum BreathingExerciseType {
  boxBreathing,
  fourSevenEight,
  diaphragmatic,
  pacedBreathing,
  resonance,
}

extension BreathingExerciseTypeExtension on BreathingExerciseType {
  String get localizedTitle {
    switch (this) {
      case BreathingExerciseType.boxBreathing:
        return SettingsStrings.boxBreathingTitle;
      case BreathingExerciseType.fourSevenEight:
        return SettingsStrings.fourSevenEightTitle;
      case BreathingExerciseType.diaphragmatic:
        return SettingsStrings.diaphragmaticTitle;
      case BreathingExerciseType.pacedBreathing:
        return SettingsStrings.pacedBreathingTitle;
      case BreathingExerciseType.resonance:
        return SettingsStrings.resonanceTitle;
    }
  }

  String get localizedDescription {
    switch (this) {
      case BreathingExerciseType.boxBreathing:
        return SettingsStrings.boxBreathingDesc;
      case BreathingExerciseType.fourSevenEight:
        return SettingsStrings.fourSevenEightDesc;
      case BreathingExerciseType.diaphragmatic:
        return SettingsStrings.diaphragmaticDesc;
      case BreathingExerciseType.pacedBreathing:
        return SettingsStrings.pacedBreathingDesc;
      case BreathingExerciseType.resonance:
        return SettingsStrings.resonanceDesc;
    }
  }

  String get localizedRecommendedFor {
    switch (this) {
      case BreathingExerciseType.boxBreathing:
        return SettingsStrings.boxBreathingFor;
      case BreathingExerciseType.fourSevenEight:
        return SettingsStrings.fourSevenEightFor;
      case BreathingExerciseType.diaphragmatic:
        return SettingsStrings.diaphragmaticFor;
      case BreathingExerciseType.pacedBreathing:
        return SettingsStrings.pacedBreathingFor;
      case BreathingExerciseType.resonance:
        return SettingsStrings.resonanceFor;
    }
  }

  List<String> get localizedSteps {
    switch (this) {
      case BreathingExerciseType.boxBreathing:
        return [
          SettingsStrings.boxBreathingStep1,
          SettingsStrings.boxBreathingStep2,
          SettingsStrings.boxBreathingStep3,
          SettingsStrings.boxBreathingStep4,
        ];
      case BreathingExerciseType.fourSevenEight:
        return [
          SettingsStrings.fourSevenEightStep1,
          SettingsStrings.fourSevenEightStep2,
          SettingsStrings.fourSevenEightStep3,
        ];
      case BreathingExerciseType.diaphragmatic:
        return [
          SettingsStrings.diaphragmaticStep1,
          SettingsStrings.diaphragmaticStep2,
          SettingsStrings.diaphragmaticStep3,
          SettingsStrings.diaphragmaticStep4,
        ];
      case BreathingExerciseType.pacedBreathing:
        return [
          SettingsStrings.pacedBreathingStep1,
          SettingsStrings.pacedBreathingStep2,
          SettingsStrings.pacedBreathingStep3,
        ];
      case BreathingExerciseType.resonance:
        return [
          SettingsStrings.resonanceStep1,
          SettingsStrings.resonanceStep2,
          SettingsStrings.resonanceStep3,
        ];
    }
  }
}

class BreathingExerciseEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final BreathingExerciseType type;
  final int durationMinutes;
  final int inhaleSeconds;
  final int holdSeconds;
  final int exhaleSeconds;
  final int restSeconds;
  final List<String> steps;
  final String recommendedFor;

  const BreathingExerciseEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.durationMinutes,
    required this.inhaleSeconds,
    required this.holdSeconds,
    required this.exhaleSeconds,
    required this.restSeconds,
    required this.steps,
    required this.recommendedFor,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    type,
    durationMinutes,
    inhaleSeconds,
    holdSeconds,
    exhaleSeconds,
    restSeconds,
    steps,
    recommendedFor,
  ];
}
