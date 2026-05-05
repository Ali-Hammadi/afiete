import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class RequestForgotPasswordOtpParams {
  final String email;

  const RequestForgotPasswordOtpParams({required this.email});
}

class RequestForgotPasswordOtpUseCase
    implements UseCase<String, RequestForgotPasswordOtpParams> {
  final AuthRepository repository;

  const RequestForgotPasswordOtpUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(RequestForgotPasswordOtpParams params) {
    return repository.requestForgotPasswordOtp(email: params.email);
  }
}
