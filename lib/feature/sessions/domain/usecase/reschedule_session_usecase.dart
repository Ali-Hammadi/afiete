import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/sessions/domain/entities/session_entity.dart';
import 'package:afiete/feature/sessions/domain/repositories/sessions_repository.dart';
import 'package:dartz/dartz.dart';

class RescheduleSessionParams {
  final String sessionId;
  final DateTime newScheduledAt;

  const RescheduleSessionParams({
    required this.sessionId,
    required this.newScheduledAt,
  });
}

class RescheduleSessionUseCase
    implements UseCase<SessionEntity, RescheduleSessionParams> {
  final SessionsRepository repository;

  const RescheduleSessionUseCase(this.repository);

  @override
  Future<Either<Failure, SessionEntity>> call(RescheduleSessionParams params) {
    return repository.rescheduleSession(
      sessionId: params.sessionId,
      newScheduledAt: params.newScheduledAt,
    );
  }
}
