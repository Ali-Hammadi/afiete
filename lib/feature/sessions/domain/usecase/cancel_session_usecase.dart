import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/sessions/domain/repositories/sessions_repository.dart';
import 'package:dartz/dartz.dart';

class CancelSessionParams {
  final String sessionId;

  const CancelSessionParams({required this.sessionId});
}

class CancelSessionUseCase implements UseCase<void, CancelSessionParams> {
  final SessionsRepository repository;

  const CancelSessionUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(CancelSessionParams params) {
    return repository.cancelSession(params.sessionId);
  }
}
