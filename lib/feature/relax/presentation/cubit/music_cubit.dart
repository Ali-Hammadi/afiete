import 'package:bloc/bloc.dart';
import 'package:afiete/core/constants/feeling_type.dart';
import 'package:equatable/equatable.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/relax/domain/entities/breathing_exercise_entity.dart';
import 'package:afiete/feature/relax/domain/entities/music_entity.dart';
import 'package:afiete/feature/relax/domain/usecase/get_recommended_music_usecase.dart';

part 'music_state.dart';

class MusicCubit extends Cubit<MusicState> {
  final GetRecommendedMusicUseCase getRecommendedMusicUseCase;
  final GetBreathingExercisesUseCase getBreathingExercisesUseCase;
  final GetLastSelectedFeelingUseCase getLastSelectedFeelingUseCase;
  final SaveLastSelectedFeelingUseCase saveLastSelectedFeelingUseCase;

  MusicCubit(
    this.getRecommendedMusicUseCase,
    this.getBreathingExercisesUseCase,
    this.getLastSelectedFeelingUseCase,
    this.saveLastSelectedFeelingUseCase,
  ) : super(MusicInitial());

  Future<void> loadHub() async {
    emit(MusicLoading());

    final lastFeelingResult = await getLastSelectedFeelingUseCase(NoParams());
    final breathingResult = await getBreathingExercisesUseCase(NoParams());

    final resolvedFeeling = lastFeelingResult.fold(
      (_) => FeelingType.neutral,
      (feeling) => feeling ?? FeelingType.neutral,
    );

    final tracksResult = await getRecommendedMusicUseCase(
      GetRecommendedMusicParams(feeling: resolvedFeeling, limit: 6),
    );

    final tracks = tracksResult.fold((_) => <MusicEntity>[], (items) => items);
    final breathingExercises = breathingResult.fold(
      (_) => <BreathingExerciseEntity>[],
      (items) => items,
    );
    final savedFeeling = lastFeelingResult.fold(
      (_) => null,
      (feeling) => feeling,
    );

    emit(
      MusicLoaded(
        selectedFeeling: resolvedFeeling,
        tracks: tracks,
        breathingExercises: breathingExercises,
        activeTrack: tracks.isNotEmpty ? tracks.first : null,
        activeBreathingExercise: breathingExercises.isNotEmpty
            ? breathingExercises.first
            : null,
        hasSavedFeeling: savedFeeling != null,
      ),
    );
  }

  Future<void> selectFeeling(FeelingType feeling) async {
    final currentState = state;
    if (currentState is MusicLoaded) {
      emit(currentState.copyWith(selectedFeeling: feeling));
    } else {
      emit(MusicLoading());
    }

    await saveLastSelectedFeelingUseCase(
      SaveLastSelectedFeelingParams(feeling: feeling),
    );

    final tracksResult = await getRecommendedMusicUseCase(
      GetRecommendedMusicParams(
        feeling: feeling,
        limit: 6,
        excludeTrackId: currentState is MusicLoaded
            ? currentState.activeTrack?.id
            : null,
      ),
    );
    final breathingResult = await getBreathingExercisesUseCase(NoParams());

    final tracks = tracksResult.fold((_) => <MusicEntity>[], (items) => items);
    final breathingExercises = breathingResult.fold(
      (_) => <BreathingExerciseEntity>[],
      (items) => items,
    );

    emit(
      MusicLoaded(
        selectedFeeling: feeling,
        tracks: tracks,
        breathingExercises: breathingExercises,
        activeTrack: tracks.isNotEmpty ? tracks.first : null,
        activeBreathingExercise: breathingExercises.isNotEmpty
            ? breathingExercises.first
            : null,
        hasSavedFeeling: true,
      ),
    );
  }

  void selectTrack(MusicEntity track) {
    final currentState = state;
    if (currentState is MusicLoaded) {
      emit(currentState.copyWith(activeTrack: track));
    }
  }

  void selectBreathingExercise(BreathingExerciseEntity exercise) {
    final currentState = state;
    if (currentState is MusicLoaded) {
      emit(currentState.copyWith(activeBreathingExercise: exercise));
    }
  }
}
