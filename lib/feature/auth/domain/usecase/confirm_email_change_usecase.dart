import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class ConfirmEmailChangeParams {
  final String userId;
  final String newEmail;
  final String otp;

  const ConfirmEmailChangeParams({
    required this.userId,
    required this.newEmail,
    required this.otp,
  });
}

class ConfirmEmailChangeUseCase
    implements UseCase<UserAuthEntity, ConfirmEmailChangeParams> {
  final AuthRepository repository;

  const ConfirmEmailChangeUseCase(this.repository);

  @override
  Future<Either<Failure, UserAuthEntity>> call(
    ConfirmEmailChangeParams params,
  ) {
    return repository.confirmEmailChange(
      userId: params.userId,
      newEmail: params.newEmail,
      otp: params.otp,
    );
  }
}
