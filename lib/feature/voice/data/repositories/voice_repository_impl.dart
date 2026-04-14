import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/voice/data/datasources/voice_remote_datasource.dart';
import 'package:afiete/feature/voice/domain/entities/voice_call_entity.dart';
import 'package:afiete/feature/voice/domain/repositories/voice_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class VoiceRepositoryImpl implements VoiceRepository {
  final VoiceRemoteDataSource dataSource;

  const VoiceRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<VoiceCallEntity>>> getCallHistory(
    String patientId,
  ) async {
    try {
      final result = await dataSource.getCallHistory(patientId);
      return Right<Failure, List<VoiceCallEntity>>(result);
    } on DioException catch (e) {
      return Left<Failure, List<VoiceCallEntity>>(
        ServerFailure.fromDioError(e),
      );
    } catch (_) {
      return Left<Failure, List<VoiceCallEntity>>(
        ServerFailure('Unable to load voice call history.'),
      );
    }
  }

  @override
  Future<Either<Failure, VoiceCallEntity>> startCall({
    required String doctorId,
    required String patientId,
    required String sessionId,
  }) async {
    try {
      final result = await dataSource.startCall(
        doctorId: doctorId,
        patientId: patientId,
        sessionId: sessionId,
      );
      return Right<Failure, VoiceCallEntity>(result);
    } on DioException catch (e) {
      return Left<Failure, VoiceCallEntity>(ServerFailure.fromDioError(e));
    } catch (_) {
      return Left<Failure, VoiceCallEntity>(
        ServerFailure('Unable to start voice call.'),
      );
    }
  }

  @override
  Future<Either<Failure, VoiceCallEntity>> endCall(String callId) async {
    try {
      final result = await dataSource.endCall(callId);
      return Right<Failure, VoiceCallEntity>(result);
    } on DioException catch (e) {
      return Left<Failure, VoiceCallEntity>(ServerFailure.fromDioError(e));
    } catch (_) {
      return Left<Failure, VoiceCallEntity>(
        ServerFailure('Unable to end voice call.'),
      );
    }
  }
}
