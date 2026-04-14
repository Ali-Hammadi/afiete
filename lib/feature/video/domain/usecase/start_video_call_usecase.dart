import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/video/domain/entities/video_call_entity.dart';
import 'package:afiete/feature/video/domain/repositories/video_repository.dart';
import 'package:dartz/dartz.dart';

class StartVideoCallUseCase
    implements UseCase<VideoCallEntity, StartVideoCallParams> {
  final VideoRepository repository;

  const StartVideoCallUseCase(this.repository);

  @override
  Future<Either<Failure, VideoCallEntity>> call(StartVideoCallParams params) {
    return repository.startCall(
      doctorId: params.doctorId,
      patientId: params.patientId,
      sessionId: params.sessionId,
    );
  }
}

class StartVideoCallParams {
  final String doctorId;
  final String patientId;
  final String sessionId;

  const StartVideoCallParams({
    required this.doctorId,
    required this.patientId,
    required this.sessionId,
  });
}
