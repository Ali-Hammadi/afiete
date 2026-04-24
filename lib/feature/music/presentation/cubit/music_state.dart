part of 'music_cubit.dart';

abstract class MusicState extends Equatable {
  const MusicState();

  @override
  List<Object?> get props => [];
}

class MusicInitial extends MusicState {}

class MusicLoading extends MusicState {}

class MusicLoaded extends MusicState {
  final FeelingType selectedFeeling;
  final List<MusicEntity> tracks;
  final List<BreathingExerciseEntity> breathingExercises;
  final MusicEntity? activeTrack;
  final BreathingExerciseEntity? activeBreathingExercise;
  final bool hasSavedFeeling;

  const MusicLoaded({
    required this.selectedFeeling,
    required this.tracks,
    required this.breathingExercises,
    required this.hasSavedFeeling,
    this.activeTrack,
    this.activeBreathingExercise,
  });

  MusicLoaded copyWith({
    FeelingType? selectedFeeling,
    List<MusicEntity>? tracks,
    List<BreathingExerciseEntity>? breathingExercises,
    MusicEntity? activeTrack,
    BreathingExerciseEntity? activeBreathingExercise,
    bool? hasSavedFeeling,
  }) {
    return MusicLoaded(
      selectedFeeling: selectedFeeling ?? this.selectedFeeling,
      tracks: tracks ?? this.tracks,
      breathingExercises: breathingExercises ?? this.breathingExercises,
      activeTrack: activeTrack ?? this.activeTrack,
      activeBreathingExercise:
          activeBreathingExercise ?? this.activeBreathingExercise,
      hasSavedFeeling: hasSavedFeeling ?? this.hasSavedFeeling,
    );
  }

  @override
  List<Object?> get props => [
    selectedFeeling,
    tracks,
    breathingExercises,
    activeTrack,
    activeBreathingExercise,
    hasSavedFeeling,
  ];
}

class MusicError extends MusicState {
  final String message;

  const MusicError(this.message);

  @override
  List<Object?> get props => [message];
}
