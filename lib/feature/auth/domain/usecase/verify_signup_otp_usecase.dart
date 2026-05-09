import 'package:dartz/dartz.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/auth/domain/entities/auth_user_entity.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';

class VerifySignupOtpParams {
  final String email;
  final String otpCode;

  const VerifySignupOtpParams({required this.email, required this.otpCode});
}

/// Usecase for verifying OTP during signup flow.
/// After successful verification, user receives access_token and enters profile completion step.
///
/// **CRITICAL**: Token must be cached immediately after this usecase succeeds,
/// as the next step (updateProfileInfo) requires an authenticated request.
class VerifySignupOtpUseCase
    implements UseCase<UserAuthEntity, VerifySignupOtpParams> {
  final AuthRepository repository;

  const VerifySignupOtpUseCase(this.repository);

  @override
  Future<Either<Failure, UserAuthEntity>> call(
    VerifySignupOtpParams params,
  ) async {
    return await repository.verifySignupOtp(
      email: params.email,
      otpCode: params.otpCode,
    );
  }
}
