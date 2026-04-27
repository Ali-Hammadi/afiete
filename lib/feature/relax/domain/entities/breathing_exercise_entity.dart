import 'package:equatable/equatable.dart';

enum BreathingExerciseType {
  boxBreathing,
  fourSevenEight,
  diaphragmatic,
  pacedBreathing,
  resonance,
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
