import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/voice/domain/entities/voice_call_entity.dart';
import 'package:afiete/feature/voice/domain/repositories/voice_repository.dart';
import 'package:dartz/dartz.dart';

class StartVoiceCallUseCase
    implements UseCase<VoiceCallEntity, StartVoiceCallParams> {
  final VoiceRepository repository;

  const StartVoiceCallUseCase(this.repository);

  @override
  Future<Either<Failure, VoiceCallEntity>> call(StartVoiceCallParams params) {
    return repository.startCall(
      doctorId: params.doctorId,
      patientId: params.patientId,
      sessionId: params.sessionId,
    );
  }
}

class StartVoiceCallParams {
  final String doctorId;
  final String patientId;
  final String sessionId;

  const StartVoiceCallParams({
    required this.doctorId,
    required this.patientId,
    required this.sessionId,
  });
}
