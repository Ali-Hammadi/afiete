import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/assignments/data/datasources/assignments_remote_datasource.dart';
import 'package:afiete/feature/assignments/domain/entity/assignment_entity.dart';
import 'package:afiete/feature/assignments/domain/repositories/assignments_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AssignmentsRepositoryImpl implements AssignmentsRepository {
  final AssignmentsRemoteDataSource remoteDataSource;

  const AssignmentsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<AssignmentEntity>>>
  getAssignmentQuestions() async {
    try {
      final questions = await remoteDataSource.getAssignmentQuestions();
      return Right(questions);
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }

  @override
  Future<Either<Failure, AssignmentEntity>> submitAssignment({
    required List<AssignmentEntity> answers,
  }) async {
    try {
      final result = await remoteDataSource.submitAssignment(answers: answers);
      return Right(result);
    } on DioException catch (error) {
      return Left(ServerFailure.fromDioError(error));
    } catch (error) {
      return Left(ServerFailure(error.toString()));
    }
  }
}
