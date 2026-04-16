import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/settings/domin/entities/medical_profile_entity.dart';
import 'package:afiete/feature/settings/domin/repositories/settings_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateMedicalNoteParams {
  final String userId;
  final String noteTitle;
  final String previousUpdatedAt;
  final String newTitle;
  final String newContent;

  const UpdateMedicalNoteParams({
    required this.userId,
    required this.noteTitle,
    required this.previousUpdatedAt,
    required this.newTitle,
    required this.newContent,
  });
}

class UpdateMedicalNoteUseCase
    implements UseCase<MedicalProfileEntity, UpdateMedicalNoteParams> {
  final SettingsRepository repository;

  const UpdateMedicalNoteUseCase(this.repository);

  @override
  Future<Either<Failure, MedicalProfileEntity>> call(
    UpdateMedicalNoteParams params,
  ) {
    return repository.updateMedicalNote(
      userId: params.userId,
      noteTitle: params.noteTitle,
      previousUpdatedAt: params.previousUpdatedAt,
      newTitle: params.newTitle,
      newContent: params.newContent,
    );
  }
}
