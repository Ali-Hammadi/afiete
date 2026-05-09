import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/auth/domain/entities/otp_entity.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class ForgotPasswordParams {
  final String email;

  const ForgotPasswordParams({required this.email});
}

/// Usecase for requesting OTP during password recovery.
/// Public endpoint (no auth required).
/// Returns OtpEntity indicating OTP has been sent to email.
class RequestForgotPasswordOtpUseCase
    implements UseCase<OtpEntity, ForgotPasswordParams> {
  final AuthRepository repository;

  const RequestForgotPasswordOtpUseCase(this.repository);

  @override
  Future<Either<Failure, OtpEntity>> call(ForgotPasswordParams params) {
    return repository.requestForgotPasswordOtp(email: params.email);
  }
}
