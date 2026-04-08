import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/settings/domin/entities/medical_profile_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SettingsRepository {
  Future<Either<Failure, MedicalProfileEntity>> getMedicalProfile(
    String userId,
  );

  Future<Either<Failure, String>> submitReportIssue({
    required String userId,
    required String reason,
    required String details,
  });
}
