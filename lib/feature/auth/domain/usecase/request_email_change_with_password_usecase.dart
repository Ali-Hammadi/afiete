import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/auth/domain/entities/otp_entity.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class RequestEmailChangeWithPasswordParams {
  final String email;
  final String password;
  final String newEmail;

  const RequestEmailChangeWithPasswordParams({
    required this.email,
    required this.password,
    required this.newEmail,
  });
}

class RequestEmailChangeWithPasswordUseCase
    implements UseCase<OtpEntity, RequestEmailChangeWithPasswordParams> {
  final AuthRepository repository;

  const RequestEmailChangeWithPasswordUseCase(this.repository);

  @override
  Future<Either<Failure, OtpEntity>> call(
    RequestEmailChangeWithPasswordParams params,
  ) {
    return repository.requestEmailChangeWithPassword(
      email: params.email,
      password: params.password,
      newEmail: params.newEmail,
    );
  }
}
