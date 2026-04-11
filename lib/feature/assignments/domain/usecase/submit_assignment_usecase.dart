import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/assignments/domain/entity/assignment_entity.dart';
import 'package:afiete/feature/assignments/domain/repositories/assignments_repository.dart';
import 'package:dartz/dartz.dart';

class SubmitAssignmentParams {
  final List<AssignmentEntity> answers;

  const SubmitAssignmentParams({required this.answers});
}

class SubmitAssignmentUseCase
    implements UseCase<AssignmentEntity, SubmitAssignmentParams> {
  final AssignmentsRepository repository;

  const SubmitAssignmentUseCase(this.repository);

  @override
  Future<Either<Failure, AssignmentEntity>> call(
    SubmitAssignmentParams params,
  ) {
    return repository.submitAssignment(answers: params.answers);
  }
}
