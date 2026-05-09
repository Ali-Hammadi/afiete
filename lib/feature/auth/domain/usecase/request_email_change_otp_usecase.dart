import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/auth/domain/entities/otp_entity.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

/// Usecase for requesting OTP for email change.
/// OTP will be sent to current email address.
/// No parameters needed; uses current authenticated session (token from header).
/// Requires access token.
class RequestEmailChangeOtpUseCase implements UseCase<OtpEntity, NoParams> {
  final AuthRepository repository;

  const RequestEmailChangeOtpUseCase(this.repository);

  @override
  Future<Either<Failure, OtpEntity>> call(NoParams params) {
    return repository.requestEmailChangeOtp();
  }
}
