import 'package:dartz/dartz.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/auth/domain/entities/otp_entity.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';

class SignupParams {
  final String nickname;
  final String email;
  final String password;

  const SignupParams({
    required this.nickname,
    required this.email,
    required this.password,
  });
}

/// Usecase for signup initiation.
/// Returns OtpEntity indicating OTP has been sent to email for verification.
/// Next step: Call VerifySignupOtpUseCase with the OTP code.
class SignupUseCase implements UseCase<OtpEntity, SignupParams> {
  final AuthRepository repository;

  const SignupUseCase(this.repository);

  @override
  Future<Either<Failure, OtpEntity>> call(SignupParams params) async {
    return await repository.signup(
      nickname: params.nickname,
      email: params.email,
      password: params.password,
    );
  }
}
