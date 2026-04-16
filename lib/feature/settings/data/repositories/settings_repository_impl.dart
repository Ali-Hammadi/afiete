import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/settings/data/data_source/settings_remote_data_source.dart';
import 'package:afiete/feature/settings/domin/entities/medical_profile_entity.dart';
import 'package:afiete/feature/settings/domin/repositories/settings_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsRemoteDataSource remoteDataSource;

  const SettingsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, MedicalProfileEntity>> getMedicalProfile(
    String userId,
  ) async {
    try {
      final result = await remoteDataSource.getMedicalProfile(userId);
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MedicalProfileEntity>> updateMedicalNote({
    required String userId,
    required String noteTitle,
    required String previousUpdatedAt,
    required String newTitle,
    required String newContent,
  }) async {
    try {
      final result = await remoteDataSource.updateMedicalNote(
        userId: userId,
        noteTitle: noteTitle,
        previousUpdatedAt: previousUpdatedAt,
        newTitle: newTitle,
        newContent: newContent,
      );
      return Right(result.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> shareMedicalNoteWithDoctor({
    required String userId,
    required String noteTitle,
    required String noteContent,
    required String doctorId,
  }) async {
    try {
      final result = await remoteDataSource.shareMedicalNoteWithDoctor(
        userId: userId,
        noteTitle: noteTitle,
        noteContent: noteContent,
        doctorId: doctorId,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> submitReportIssue({
    required String userId,
    required String reason,
    required String details,
  }) async {
    try {
      final result = await remoteDataSource.submitReportIssue(
        userId: userId,
        reason: reason,
        details: details,
      );
      return Right(result);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
