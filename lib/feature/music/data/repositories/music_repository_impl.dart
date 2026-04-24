import 'package:afiete/core/constants/feeling_type.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/music/data/datasources/music_local_data_source.dart';
import 'package:afiete/feature/music/domain/entities/breathing_exercise_entity.dart';
import 'package:afiete/feature/music/domain/entities/music_entity.dart';
import 'package:afiete/feature/music/domain/repositories/music_repository.dart';
import 'package:dartz/dartz.dart';

class MusicRepositoryImpl implements MusicRepository {
  final MusicLocalDataSource dataSource;

  const MusicRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, FeelingType?>> getLastSelectedFeeling() async {
    try {
      return Right(await dataSource.getLastSelectedFeeling());
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveLastSelectedFeeling(
    FeelingType feeling,
  ) async {
    try {
      await dataSource.saveLastSelectedFeeling(feeling);
      return const Right(null);
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MusicEntity>>> getRecommendedTracks({
    required FeelingType feeling,
    int limit = 5,
    String? excludeTrackId,
  }) async {
    try {
      return Right(
        await dataSource.getRecommendedTracks(
          feeling: feeling,
          limit: limit,
          excludeTrackId: excludeTrackId,
        ),
      );
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MusicEntity>>> getTracksByGoal(
    MusicTherapeuticGoal goal, {
    int limit = 5,
  }) async {
    try {
      return Right(await dataSource.getTracksByGoal(goal, limit: limit));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BreathingExerciseEntity>>>
  getBreathingExercises() async {
    try {
      return Right(await dataSource.getBreathingExercises());
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, MusicEntity>> getTrackById(String id) async {
    try {
      final track = await dataSource.getTrackById(id);
      if (track == null) {
        return Left(ServerFailure('Track not found'));
      }
      return Right(track);
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
