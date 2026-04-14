import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/video/domain/entities/video_call_entity.dart';
import 'package:dartz/dartz.dart';

abstract class VideoRepository {
  Future<Either<Failure, List<VideoCallEntity>>> getCallHistory(
    String patientId,
  );

  Future<Either<Failure, VideoCallEntity>> startCall({
    required String doctorId,
    required String patientId,
    required String sessionId,
  });

  Future<Either<Failure, VideoCallEntity>> endCall(String callId);
}
