import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/voice/domain/entities/voice_call_entity.dart';
import 'package:dartz/dartz.dart';

abstract class VoiceRepository {
  Future<Either<Failure, List<VoiceCallEntity>>> getCallHistory(
    String patientId,
  );

  Future<Either<Failure, VoiceCallEntity>> startCall({
    required String doctorId,
    required String patientId,
    required String sessionId,
  });

  Future<Either<Failure, VoiceCallEntity>> endCall(String callId);
}
