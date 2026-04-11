import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/assignments/domain/entity/assignment_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AssignmentsRepository {
  Future<Either<Failure, List<AssignmentEntity>>> getAssignmentQuestions();

  Future<Either<Failure, AssignmentEntity>> submitAssignment({
    required List<AssignmentEntity> answers,
  });
}
