import 'package:afiete/core/constants/feeling_type.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/feeling/data/datasources/feeling_local_data_source.dart';
import 'package:afiete/feature/feeling/domain/entities/feeling_entry_entity.dart';
import 'package:afiete/feature/feeling/domain/repositories/feeling_repository.dart';
import 'package:dartz/dartz.dart';

class FeelingRepositoryImpl implements FeelingRepository {
  final FeelingLocalDataSource localDataSource;

  const FeelingRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, FeelingType?>> getCurrentFeeling() async {
    try {
      return Right(await localDataSource.getCurrentFeeling());
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, List<FeelingEntryEntity>>> getFeelingHistory({
    int limit = 30,
  }) async {
    try {
      return Right(await localDataSource.getFeelingHistory(limit: limit));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, FeelingEntryEntity>> saveFeeling({
    required FeelingType feeling,
    int intensity = 3,
  }) async {
    try {
      return Right(
        await localDataSource.saveFeeling(
          feeling: feeling,
          intensity: intensity,
        ),
      );
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
