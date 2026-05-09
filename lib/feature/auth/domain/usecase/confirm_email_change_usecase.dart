import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class ConfirmEmailChangeParams {
  final String newEmail;
  final String otpCode;

  const ConfirmEmailChangeParams({
    required this.newEmail,
    required this.otpCode,
  });
}

/// Usecase for confirming email change by verifying OTP.
/// Used when user changes their email address and needs to verify the new email with OTP.
/// After successful verification, email is changed in backend.
/// Requires access token.
class ConfirmEmailChangeUseCase
    implements UseCase<void, ConfirmEmailChangeParams> {
  final AuthRepository repository;

  const ConfirmEmailChangeUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(ConfirmEmailChangeParams params) {
    return repository.confirmEmailChange(
      newEmail: params.newEmail,
      otpCode: params.otpCode,
    );
  }
}
