import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/video/data/datasources/video_remote_datasource.dart';
import 'package:afiete/feature/video/domain/entities/video_call_entity.dart';
import 'package:afiete/feature/video/domain/repositories/video_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class VideoRepositoryImpl implements VideoRepository {
  final VideoRemoteDataSource dataSource;

  const VideoRepositoryImpl({required this.dataSource});

  @override
  Future<Either<Failure, List<VideoCallEntity>>> getCallHistory(
    String patientId,
  ) async {
    try {
      final result = await dataSource.getCallHistory(patientId);
      return Right<Failure, List<VideoCallEntity>>(result);
    } on DioException catch (e) {
      return Left<Failure, List<VideoCallEntity>>(
        ServerFailure.fromDioError(e),
      );
    } catch (_) {
      return Left<Failure, List<VideoCallEntity>>(
        ServerFailure('Unable to load video call history.'),
      );
    }
  }

  @override
  Future<Either<Failure, VideoCallEntity>> startCall({
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
      return Right<Failure, VideoCallEntity>(result);
    } on DioException catch (e) {
      return Left<Failure, VideoCallEntity>(ServerFailure.fromDioError(e));
    } catch (_) {
      return Left<Failure, VideoCallEntity>(
        ServerFailure('Unable to start video call.'),
      );
    }
  }

  @override
  Future<Either<Failure, VideoCallEntity>> endCall(String callId) async {
    try {
      final result = await dataSource.endCall(callId);
      return Right<Failure, VideoCallEntity>(result);
    } on DioException catch (e) {
      return Left<Failure, VideoCallEntity>(ServerFailure.fromDioError(e));
    } catch (_) {
      return Left<Failure, VideoCallEntity>(
        ServerFailure('Unable to end video call.'),
      );
    }
  }
}
