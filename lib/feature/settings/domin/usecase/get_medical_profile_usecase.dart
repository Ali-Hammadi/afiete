import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/settings/domin/entities/medical_profile_entity.dart';
import 'package:afiete/feature/settings/domin/repositories/settings_repository.dart';
import 'package:dartz/dartz.dart';

class GetMedicalProfileUseCase
    implements UseCase<MedicalProfileEntity, String> {
  final SettingsRepository repository;

  const GetMedicalProfileUseCase(this.repository);

  @override
  Future<Either<Failure, MedicalProfileEntity>> call(String userId) {
    return repository.getMedicalProfile(userId);
  }
}
