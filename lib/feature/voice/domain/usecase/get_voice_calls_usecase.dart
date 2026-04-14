import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/voice/domain/entities/voice_call_entity.dart';
import 'package:afiete/feature/voice/domain/repositories/voice_repository.dart';
import 'package:dartz/dartz.dart';

class GetVoiceCallsUseCase
    implements UseCase<List<VoiceCallEntity>, GetVoiceCallsParams> {
  final VoiceRepository repository;

  const GetVoiceCallsUseCase(this.repository);

  @override
  Future<Either<Failure, List<VoiceCallEntity>>> call(
    GetVoiceCallsParams params,
  ) {
    return repository.getCallHistory(params.patientId);
  }
}

class GetVoiceCallsParams {
  final String patientId;

  const GetVoiceCallsParams({required this.patientId});
}
