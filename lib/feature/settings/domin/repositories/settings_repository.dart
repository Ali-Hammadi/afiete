import 'package:afiete/core/error/failure.dart';
import 'package:afiete/feature/settings/domin/entities/medical_profile_entity.dart';
import 'package:dartz/dartz.dart';

abstract class SettingsRepository {
  Future<Either<Failure, MedicalProfileEntity>> getMedicalProfile(
    String userId,
  );

  Future<Either<Failure, MedicalProfileEntity>> updateMedicalNote({
    required String userId,
    required String noteTitle,
    required String previousUpdatedAt,
    required String newTitle,
    required String newContent,
  });

  Future<Either<Failure, String>> shareMedicalNoteWithDoctor({
    required String userId,
    required String noteTitle,
    required String noteContent,
    required String doctorId,
  });

  Future<Either<Failure, String>> submitReportIssue({
    required String userId,
    required String reason,
    required String details,
  });
}
