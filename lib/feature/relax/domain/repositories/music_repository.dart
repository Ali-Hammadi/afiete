import 'package:afiete/core/constants/feeling_type.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/relax/domain/entities/breathing_exercise_entity.dart';
import 'package:afiete/feature/relax/domain/entities/music_entity.dart';
import 'package:dartz/dartz.dart';

abstract class MusicRepository {
  Future<Either<Failure, FeelingType?>> getLastSelectedFeeling();

  Future<Either<Failure, void>> saveLastSelectedFeeling(FeelingType feeling);

  Future<Either<Failure, List<MusicEntity>>> getRecommendedTracks({
    required FeelingType feeling,
    int limit,
    String? excludeTrackId,
  });

  Future<Either<Failure, List<MusicEntity>>> getTracksByGoal(
    MusicTherapeuticGoal goal, {
    int limit,
  });

  Future<Either<Failure, List<BreathingExerciseEntity>>>
  getBreathingExercises();

  Future<Either<Failure, MusicEntity>> getTrackById(String id);
}
