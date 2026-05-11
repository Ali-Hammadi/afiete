import 'package:dartz/dartz.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';

class UpdatePasswordParams {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final String? correlationId;

  const UpdatePasswordParams({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
    this.correlationId,
  });
}

/// Usecase for changing user's password from profile settings.
/// Requires current password verification for security.
/// Requires access token (authenticated request).
class UpdatePasswordUseCase
    implements UseCase<UserAuthEntity, UpdatePasswordParams> {
  final AuthRepository repository;

  const UpdatePasswordUseCase(this.repository);

  @override
  Future<Either<Failure, UserAuthEntity>> call(
    UpdatePasswordParams params,
  ) async {
    return await repository.updatePassword(
      currentPassword: params.currentPassword,
      newPassword: params.newPassword,
      confirmPassword: params.confirmPassword,
      correlationId: params.correlationId,
    );
  }
}
