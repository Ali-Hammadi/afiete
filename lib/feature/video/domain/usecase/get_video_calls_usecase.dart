import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/video/domain/entities/video_call_entity.dart';
import 'package:afiete/feature/video/domain/repositories/video_repository.dart';
import 'package:dartz/dartz.dart';

class GetVideoCallsUseCase
    implements UseCase<List<VideoCallEntity>, GetVideoCallsParams> {
  final VideoRepository repository;

  const GetVideoCallsUseCase(this.repository);

  @override
  Future<Either<Failure, List<VideoCallEntity>>> call(
    GetVideoCallsParams params,
  ) {
    return repository.getCallHistory(params.patientId);
  }
}

class GetVideoCallsParams {
  final String patientId;

  const GetVideoCallsParams({required this.patientId});
}
