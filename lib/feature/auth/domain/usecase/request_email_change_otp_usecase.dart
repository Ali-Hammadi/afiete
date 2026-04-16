import 'package:afiete/core/error/failure.dart';
import 'package:afiete/core/usecases/usecase.dart';
import 'package:afiete/feature/auth/domain/repositories/auth_repository.dart';
import 'package:dartz/dartz.dart';

class RequestEmailChangeOtpParams {
  final String userId;
  final String newEmail;

  const RequestEmailChangeOtpParams({
    required this.userId,
    required this.newEmail,
  });
}

class RequestEmailChangeOtpUseCase
    implements UseCase<String, RequestEmailChangeOtpParams> {
  final AuthRepository repository;

  const RequestEmailChangeOtpUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(RequestEmailChangeOtpParams params) {
    return repository.requestEmailChangeOtp(
      userId: params.userId,
      newEmail: params.newEmail,
    );
  }
}
