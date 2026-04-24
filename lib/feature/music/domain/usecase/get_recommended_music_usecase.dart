import 'package:afiete/core/constants/feeling_type.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/music/domain/entities/breathing_exercise_entity.dart';
import 'package:afiete/feature/music/domain/entities/music_entity.dart';
import 'package:afiete/feature/music/domain/repositories/music_repository.dart';
import 'package:dartz/dartz.dart';

class GetRecommendedMusicParams {
  final FeelingType feeling;
  final int limit;
  final String? excludeTrackId;

  const GetRecommendedMusicParams({
    required this.feeling,
    this.limit = 5,
    this.excludeTrackId,
  });
}

class GetRecommendedMusicUseCase
    implements UseCase<List<MusicEntity>, GetRecommendedMusicParams> {
  final MusicRepository repository;

  const GetRecommendedMusicUseCase(this.repository);

  @override
  Future<Either<Failure, List<MusicEntity>>> call(
    GetRecommendedMusicParams params,
  ) {
    return repository.getRecommendedTracks(
      feeling: params.feeling,
      limit: params.limit,
      excludeTrackId: params.excludeTrackId,
    );
  }
}

class GetTracksByGoalParams {
  final MusicTherapeuticGoal goal;
  final int limit;

  const GetTracksByGoalParams({required this.goal, this.limit = 5});
}

class GetTracksByGoalUseCase
    implements UseCase<List<MusicEntity>, GetTracksByGoalParams> {
  final MusicRepository repository;

  const GetTracksByGoalUseCase(this.repository);

  @override
  Future<Either<Failure, List<MusicEntity>>> call(
    GetTracksByGoalParams params,
  ) {
    return repository.getTracksByGoal(params.goal, limit: params.limit);
  }
}

class GetTrackByIdParams {
  final String id;

  const GetTrackByIdParams({required this.id});
}

class GetTrackByIdUseCase implements UseCase<MusicEntity, GetTrackByIdParams> {
  final MusicRepository repository;

  const GetTrackByIdUseCase(this.repository);

  @override
  Future<Either<Failure, MusicEntity>> call(GetTrackByIdParams params) {
    return repository.getTrackById(params.id);
  }
}

class GetBreathingExercisesUseCase
    implements UseCase<List<BreathingExerciseEntity>, NoParams> {
  final MusicRepository repository;

  const GetBreathingExercisesUseCase(this.repository);

  @override
  Future<Either<Failure, List<BreathingExerciseEntity>>> call(NoParams params) {
    return repository.getBreathingExercises();
  }
}

class SaveLastSelectedFeelingParams {
  final FeelingType feeling;

  const SaveLastSelectedFeelingParams({required this.feeling});
}

class SaveLastSelectedFeelingUseCase
    implements UseCase<void, SaveLastSelectedFeelingParams> {
  final MusicRepository repository;

  const SaveLastSelectedFeelingUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveLastSelectedFeelingParams params) {
    return repository.saveLastSelectedFeeling(params.feeling);
  }
}

class GetLastSelectedFeelingUseCase implements UseCase<FeelingType?, NoParams> {
  final MusicRepository repository;

  const GetLastSelectedFeelingUseCase(this.repository);

  @override
  Future<Either<Failure, FeelingType?>> call(NoParams params) {
    return repository.getLastSelectedFeeling();
  }
}
