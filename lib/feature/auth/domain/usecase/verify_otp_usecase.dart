import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class VerifyOtpParams {
  final String email;
  final String code;

  const VerifyOtpParams({required this.email, required this.code});
}

class VerifyOtpUseCase implements UseCase<UserAuthEntity, VerifyOtpParams> {
  final AuthRepository repository;

  const VerifyOtpUseCase(this.repository);

  @override
  Future<Either<Failure, UserAuthEntity>> call(VerifyOtpParams params) {
    return repository.verifyOtp(params.email, params.code);
  }
}