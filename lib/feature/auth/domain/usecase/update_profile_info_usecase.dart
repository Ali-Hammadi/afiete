import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateProfileParams {
  final String? dateOfBirth;
  final String? gender;
  final String? phoneNumber;
  final String? correlationId;

  const UpdateProfileParams({
    this.dateOfBirth,
    this.gender,
    this.phoneNumber,
    this.correlationId,
  });
}

/// Usecase for updating user profile information (partially or fully).
/// All fields are optional; only provided fields are updated.
/// Requires access token (authenticated request).
class UpdateProfileInfoUseCase
    implements UseCase<UserAuthEntity, UpdateProfileParams> {
  final AuthRepository repository;

  const UpdateProfileInfoUseCase(this.repository);

  @override
  Future<Either<Failure, UserAuthEntity>> call(UpdateProfileParams params) {
    return repository.updateProfileInfo(
      dateOfBirth: params.dateOfBirth,
      gender: params.gender,
      phoneNumber: params.phoneNumber,
      correlationId: params.correlationId,
    );
  }
}
