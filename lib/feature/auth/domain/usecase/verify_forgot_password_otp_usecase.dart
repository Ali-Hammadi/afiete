import 'package:dartz/dartz.dart';
import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/auth/domain/entities/otp_entity.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';

class VerifyForgotPasswordOtpParams {
  final String email;
  final String otpCode;
  final String newPassword;
  final String confirmPassword;
  final String? correlationId;

  const VerifyForgotPasswordOtpParams({
    required this.email,
    required this.otpCode,
    required this.newPassword,
    required this.confirmPassword,
    this.correlationId,
  });
}

/// Usecase for verifying OTP during password recovery flow.
/// Backend validates OTP, updates password, and returns status.
/// After successful verification, user should call LoginUseCase with new password.
class VerifyForgotPasswordOtpUseCase
    implements UseCase<OtpEntity, VerifyForgotPasswordOtpParams> {
  final AuthRepository repository;

  const VerifyForgotPasswordOtpUseCase(this.repository);

  @override
  Future<Either<Failure, OtpEntity>> call(
    VerifyForgotPasswordOtpParams params,
  ) async {
    return await repository.verifyForgotPasswordOtp(
      email: params.email,
      otpCode: params.otpCode,
      newPassword: params.newPassword,
      confirmPassword: params.confirmPassword,
      correlationId: params.correlationId,
    );
  }
}
