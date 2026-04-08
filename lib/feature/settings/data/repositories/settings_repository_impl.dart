import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/settings/data/data_source/settings_remote_data_source.dart';
import 'package:afiete/feature/settings/domin/entities/medical_profile_entity.dart';
import 'package:afiete/feature/settings/domin/repositories/settings_repository.dart';
import 'package:dartz/dartz.dart';

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
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
