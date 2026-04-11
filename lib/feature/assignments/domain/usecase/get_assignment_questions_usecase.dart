import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/assignments/domain/entity/assignment_entity.dart';
import 'package:afiete/feature/assignments/domain/repositories/assignments_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:afiete/core/error/failure.dart';

class GetAssignmentQuestionsUseCase
    implements UseCase<List<AssignmentEntity>, NoParams> {
  final AssignmentsRepository repository;

  const GetAssignmentQuestionsUseCase(this.repository);

  @override
  Future<Either<Failure, List<AssignmentEntity>>> call(NoParams params) {
    return repository.getAssignmentQuestions();
  }
}
